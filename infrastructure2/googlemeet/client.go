package googlemeet

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"sort"
	"strings"
	"time"

	goauth2 "golang.org/x/oauth2"
	"golang.org/x/oauth2/google"

	"meet-attendance-clean/infrastructure2/oauth2"
)

const (
	meetAPIBase     = "https://meet.googleapis.com/v2"
	calendarAPIBase = "https://www.googleapis.com/calendar/v3"
)

// DTO nội bộ của Google Meet, không để rò rỉ ra ngoài application/domain
type rawMeeting struct {
	RecordID     string
	SpaceID      string
	MeetingCode  string
	SpaceName    string
	StartedAt    time.Time
	EndedAt      time.Time
	Participants []rawParticipant
}

type rawParticipant struct {
	DisplayName string
	FirstJoined time.Time
	LastLeft    time.Time
	DurationMin int
}

type Client struct {
	*oauth2.Manager
}

func NewClient(credentialsJSON []byte, tokenPath, redirectURL string) (*Client, error) {
	if len(credentialsJSON) == 0 {
		return nil, errors.New("cấu hình Google OAuth credentials đang trống")
	}

	cfg, err := google.ConfigFromJSON(
		credentialsJSON,
		"https://www.googleapis.com/auth/meetings.space.readonly",
		"https://www.googleapis.com/auth/calendar.readonly",
	)
	if err != nil {
		return nil, fmt.Errorf("cấu hình Google OAuth không hợp lệ: %w", err)
	}
	cfg.RedirectURL = redirectURL

	return &Client{
		Manager: oauth2.NewManager(cfg, tokenPath),
	}, nil
}

func (c *Client) AuthorizationURL(state string) string {
	return c.Manager.AuthURL(
		state,
		goauth2.AccessTypeOffline,
		goauth2.ApprovalForce,
		goauth2.SetAuthURLParam("prompt", "select_account"),
	)
}

// FetchRawMeetings tải toàn bộ lịch sử họp và người tham gia từ Google API
func (c *Client) FetchRawMeetings(ctx context.Context, fromTime time.Time) ([]rawMeeting, error) {
	httpClient, err := c.GetHTTPClient(ctx)
	if err != nil {
		return nil, err
	}

	calendarTitles, err := c.fetchCalendarTitles(ctx, httpClient, fromTime)
	if err != nil {
		return nil, err
	}

	spaceCache := make(map[string]string) // spaceID -> meetingCode
	filter := fmt.Sprintf("start_time >= %q", fromTime.UTC().Format(time.RFC3339))
	var meetings []rawMeeting
	pageToken := ""

	for {
		endpoint := fmt.Sprintf("%s/conferenceRecords?filter=%s&pageSize=100", meetAPIBase, url.QueryEscape(filter))
		if pageToken != "" {
			endpoint += "&pageToken=" + pageToken
		}

		var page struct {
			Records []struct {
				Name      string `json:"name"`
				StartTime string `json:"startTime"`
				EndTime   string `json:"endTime"`
				Space     string `json:"space"`
			} `json:"conferenceRecords"`
			NextPageToken string `json:"nextPageToken"`
		}

		if err := c.getJSON(ctx, httpClient, endpoint, &page); err != nil {
			return nil, err
		}

		for _, rec := range page.Records {
			spaceID := strings.TrimPrefix(rec.Space, "spaces/")
			meetingCode, ok := spaceCache[spaceID]
			if !ok {
				meetingCode, err = c.fetchMeetingCode(ctx, httpClient, spaceID)
				if err != nil {
					return nil, fmt.Errorf("lấy mã Meet của %s: %w", rec.Space, err)
				}
				spaceCache[spaceID] = meetingCode
			}

			startedAt, err := time.Parse(time.RFC3339, rec.StartTime)
			if err != nil {
				continue
			}
			startedAt = startedAt.UTC()

			var endedAt time.Time
			if rec.EndTime != "" {
				if t, err := time.Parse(time.RFC3339, rec.EndTime); err == nil {
					endedAt = t.UTC()
				}
			}

			participants, err := c.fetchParticipants(ctx, httpClient, rec.Name, startedAt, endedAt)
			if err != nil {
				return nil, fmt.Errorf("lấy người tham gia %s: %w", rec.Name, err)
			}

			meetings = append(meetings, rawMeeting{
				RecordID:     strings.TrimPrefix(rec.Name, "conferenceRecords/"),
				SpaceID:      spaceID,
				MeetingCode:  meetingCode,
				SpaceName:    calendarTitles[strings.ToLower(meetingCode)],
				StartedAt:    startedAt,
				EndedAt:      endedAt,
				Participants: participants,
			})
		}

		pageToken = page.NextPageToken
		if pageToken == "" {
			break
		}
	}

	return meetings, nil
}

func (c *Client) fetchMeetingCode(ctx context.Context, client *http.Client, spaceID string) (string, error) {
	var resp struct {
		MeetingCode string `json:"meetingCode"`
	}
	endpoint := fmt.Sprintf("%s/spaces/%s", meetAPIBase, url.PathEscape(spaceID))
	if err := c.getJSON(ctx, client, endpoint, &resp); err != nil {
		return "", err
	}
	if strings.TrimSpace(resp.MeetingCode) == "" {
		return "", errors.New("Google Meet không trả meetingCode")
	}
	return resp.MeetingCode, nil
}

func (c *Client) fetchParticipants(ctx context.Context, client *http.Client, recordName string, meetStart, meetEnd time.Time) ([]rawParticipant, error) {
	var list []rawParticipant
	pageToken := ""

	for {
		endpoint := fmt.Sprintf("%s/%s/participants?pageSize=100", meetAPIBase, recordName)
		if pageToken != "" {
			endpoint += "&pageToken=" + pageToken
		}

		var page struct {
			Participants []struct {
				Name         string `json:"name"`
				SignedInUser *struct {
					DisplayName string `json:"displayName"`
				} `json:"signedInUser"`
				AnonymousUser *struct {
					DisplayName string `json:"displayName"`
				} `json:"anonymousUser"`
			} `json:"participants"`
			NextPageToken string `json:"nextPageToken"`
		}

		if err := c.getJSON(ctx, client, endpoint, &page); err != nil {
			return nil, err
		}

		for _, p := range page.Participants {
			name := "Khách ẩn danh"
			if p.SignedInUser != nil && p.SignedInUser.DisplayName != "" {
				name = p.SignedInUser.DisplayName
			} else if p.AnonymousUser != nil && p.AnonymousUser.DisplayName != "" {
				name = p.AnonymousUser.DisplayName
			}

			firstJoin, lastLeave, duration := c.readSessions(ctx, client, p.Name, meetStart, meetEnd)
			if !firstJoin.IsZero() {
				list = append(list, rawParticipant{
					DisplayName: name,
					FirstJoined: firstJoin,
					LastLeft:    lastLeave,
					DurationMin: duration,
				})
			}
		}

		pageToken = page.NextPageToken
		if pageToken == "" {
			break
		}
	}

	return list, nil
}

func (c *Client) readSessions(ctx context.Context, client *http.Client, participantName string, meetStart, meetEnd time.Time) (time.Time, time.Time, int) {
	var intervals [][2]time.Time
	pageToken := ""

	for {
		endpoint := fmt.Sprintf("%s/%s/participantSessions?pageSize=100", meetAPIBase, participantName)
		if pageToken != "" {
			endpoint += "&pageToken=" + pageToken
		}

		var page struct {
			Sessions []struct {
				StartTime string `json:"startTime"`
				EndTime   string `json:"endTime"`
			} `json:"participantSessions"`
			NextPageToken string `json:"nextPageToken"`
		}

		if err := c.getJSON(ctx, client, endpoint, &page); err != nil || len(page.Sessions) == 0 {
			break
		}

		for _, s := range page.Sessions {
			startUTC, err1 := time.Parse(time.RFC3339, s.StartTime)
			if err1 != nil {
				continue
			}
			startUTC = startUTC.UTC()

			endUTC, err2 := time.Parse(time.RFC3339, s.EndTime)
			if err2 == nil {
				endUTC = endUTC.UTC()
			} else {
				endUTC = meetEnd
				if endUTC.IsZero() {
					endUTC = time.Now().UTC()
				}
			}

			intervals = append(intervals, [2]time.Time{startUTC, endUTC})
		}

		pageToken = page.NextPageToken
		if pageToken == "" {
			break
		}
	}

	return calculateDuration(intervals)
}

func (c *Client) fetchCalendarTitles(ctx context.Context, client *http.Client, fromTime time.Time) (map[string]string, error) {
	result := make(map[string]string)
	pageToken := ""

	for {
		query := url.Values{
			"singleEvents": {"false"},
			"timeMin":      {fromTime.UTC().Add(-24 * time.Hour).Format(time.RFC3339)},
			"timeMax":      {time.Now().UTC().AddDate(1, 0, 0).Format(time.RFC3339)},
			"maxResults":   {"2500"},
			"fields":       {"items(summary,hangoutLink,conferenceData(entryPoints(entryPointType,uri,meetingCode))),nextPageToken"},
		}
		if pageToken != "" {
			query.Set("pageToken", pageToken)
		}

		var response struct {
			Items []struct {
				Summary        string `json:"summary"`
				HangoutLink    string `json:"hangoutLink"`
				ConferenceData struct {
					EntryPoints []struct {
						EntryPointType string `json:"entryPointType"`
						URI            string `json:"uri"`
						MeetingCode    string `json:"meetingCode"`
					} `json:"entryPoints"`
				} `json:"conferenceData"`
			} `json:"items"`
			NextPageToken string `json:"nextPageToken"`
		}

		endpoint := calendarAPIBase + "/calendars/primary/events?" + query.Encode()
		if err := c.getJSON(ctx, client, endpoint, &response); err != nil {
			return nil, fmt.Errorf("đọc Google Calendar: %w", err)
		}

		for _, item := range response.Items {
			title := strings.TrimSpace(item.Summary)
			if title == "" {
				continue
			}

			for _, code := range extractMeetingCodes(item.HangoutLink, item.ConferenceData.EntryPoints) {
				result[strings.ToLower(code)] = title
			}
		}

		pageToken = response.NextPageToken
		if pageToken == "" {
			break
		}
	}

	return result, nil
}

func extractMeetingCodes(hangoutLink string, entryPoints []struct {
	EntryPointType string `json:"entryPointType"`
	URI            string `json:"uri"`
	MeetingCode    string `json:"meetingCode"`
}) []string {
	seen := map[string]struct{}{}
	add := func(v string) {
		v = strings.TrimSpace(v)
		if parsed, err := url.Parse(v); err == nil && parsed.Host == "meet.google.com" {
			v = strings.Trim(parsed.Path, "/")
		}
		if v != "" {
			seen[strings.ToLower(v)] = struct{}{}
		}
	}

	add(hangoutLink)
	for _, ep := range entryPoints {
		if ep.EntryPointType == "video" {
			add(ep.MeetingCode)
			add(ep.URI)
		}
	}

	out := make([]string, 0, len(seen))
	for k := range seen {
		out = append(out, k)
	}
	return out
}

func (c *Client) getJSON(ctx context.Context, client *http.Client, endpoint string, target any) error {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)
	if err != nil {
		return err
	}
	res, err := client.Do(req)
	if err != nil {
		return err
	}
	defer res.Body.Close()

	if res.StatusCode < 200 || res.StatusCode > 299 {
		body, _ := io.ReadAll(io.LimitReader(res.Body, 2048))
		return fmt.Errorf("Google API (%d): %s", res.StatusCode, string(body))
	}
	return json.NewDecoder(res.Body).Decode(target)
}

// calculateDuration gộp các khoảng giao nhau (overlap) trước khi tính tổng phút
func calculateDuration(intervals [][2]time.Time) (time.Time, time.Time, int) {
	if len(intervals) == 0 {
		return time.Time{}, time.Time{}, 0
	}

	sort.Slice(intervals, func(i, j int) bool {
		return intervals[i][0].Before(intervals[j][0])
	})

	var merged [][2]time.Time
	for _, it := range intervals {
		if len(merged) == 0 {
			merged = append(merged, it)
			continue
		}
		last := &merged[len(merged)-1]
		if !it[0].After(last[1]) {
			if it[1].After(last[1]) {
				last[1] = it[1]
			}
		} else {
			merged = append(merged, it)
		}
	}

	firstJoin := merged[0][0]
	lastLeave := merged[len(merged)-1][1]
	var total time.Duration
	for _, it := range merged {
		total += it[1].Sub(it[0])
	}

	return firstJoin, lastLeave, int(total.Minutes())
}
