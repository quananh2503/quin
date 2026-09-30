package application2

import (
	"time"
	"uuid"
)

//	type ModelView struct {
//		ID          string `json:"id"`
//		DisplayName string `json:"display_name"`
//		Description string `json:"description"`
//	}
type StudentFilter struct {
	SearchName         *string   `json:"SearchName"`
	FromDate           time.Time `json:"from_date"`
	ToDate             time.Time `json:"to_date"`
	MinDurationMinutes int       `json:"min_duration_minutes"`
}
type MeetingFilter struct {
	FromDate           time.Time `json:"from_date"`
	ToDate             time.Time `json:"to_date"`
	MinDurationMinutes int       `json:"min_duration_minutes"`
}
type StudentView struct {
	ID            uuid.UUID `json:"id"`
	Name          string    `json:"name"`
	Class         string    `json:"class"`
	MeetingCode   string    `json:"meeting_code"`
	SpaceName     string    `json:"space_name"`
	CycleStartDay int       `json:"cycle_start_day"`
	CreatedAt     time.Time `json:"created_at"`
}
type StudentSummary struct {
	StudentView
	TotalSessions        int `json:"total_sessions"`
	TotalDurationMinutes int `json:"total_duration_minutes"`
}
type DashboardView struct {
	TotalStudents        int              `json:"total_students"`
	TotalSessions        int              `json:"total_sessions"`
	TotalDurationMinutes int              `json:"total_duration_minutes"`
	Students             []StudentSummary `json:"students"`
}
type ParticipantView struct {
	Name          string    `json:"name"`
	FirstJoinedAt time.Time `json:"first_joined_at"`
	LastLeftAt    time.Time `json:"last_left_at"`
	Duration      int       `json:"duration"`
}
type MeetingView struct {
	ID           uuid.UUID         `json:"id"`
	StartedAt    time.Time         `json:"started_at"`
	EndedAt      time.Time         `json:"ended_at"`
	Participants []ParticipantView `json:"participants"`
}
type StudentDetailView struct {
	Student              StudentView   `json:"student"`
	TotalSessions        int           `json:"total_sessions"`
	TotalDurationMinutes int           `json:"total_duration_minutes"`
	Meetings             []MeetingView `json:"meetings"`
}

type BlockView struct {
	Type        string            `json:"type"`
	Body        string            `json:"body,omitempty"`
	Ordered     bool              `json:"ordered,omitempty"`
	Items       []string          `json:"items,omitempty"`
	Math        string            `json:"math,omitempty"`
	Title       string            `json:"title,omitempty"`
	Problem     string            `json:"problem,omitempty"`
	Solution    string            `json:"solution,omitempty"`
	Explanation string            `json:"explanation,omitempty"`
	SVG         string            `json:"svg,omitempty"`
	Caption     string            `json:"caption,omitempty"`
	CalloutKind string            `json:"callout_kind,omitempty"`
	ClozeItems  [][]ClozePartView `json:"cloze_items,omitempty"`
}
type ClozePartView struct {
	Type  string `json:"type"`
	Value string `json:"value"`
}
type TopicView struct {
	Title  string      `json:"title"`
	Blocks []BlockView `json:"blocks"`
}
type SectionView struct {
	Title  string      `json:"title"`
	Topics []TopicView `json:"topics"`
}
type OptionView struct {
	Label   string `json:"label"`
	Content string `json:"content"`
}
type EssayPartView struct {
	Label    string `json:"label"`
	Question string `json:"question"`
	Solution string `json:"solution"`
	Rubric   string `json:"rubric"`
}
type ExerciseView struct {
	Type           string          `json:"type"`
	Topic          string          `json:"topic"`
	Difficulty     string          `json:"difficulty"`
	Question       string          `json:"question"`
	DiagramType    string          `json:"diagram_type"`
	DiagramContent string          `json:"diagram_content"`
	Options        []OptionView    `json:"options"`
	Answer         string          `json:"answer"`
	Explanation    string          `json:"explanation"`
	Parts          []EssayPartView `json:"parts"`
}
type LessonView struct {
	ID        uuid.UUID      `json:"id"`
	Title     string         `json:"title"`
	Overview  string         `json:"overview"`
	Sections  []SectionView  `json:"sections"`
	Exercises []ExerciseView `json:"exercises"`
}
type DraftView struct {
	ID           uuid.UUID   `json:"id"`
	Title        string      `json:"title"`
	Model        string      `json:"model"`
	CustomPrompt string      `json:"custom_prompt"`
	Status       string      `json:"status"`
	SourceType   string      `json:"source_type"`
	SourceURL    string      `json:"source_url"`
	CreatedAt    time.Time   `json:"created_at"`
	UpdatedAt    *time.Time  `json:"updated_at,omitempty"`
	ErrorMessage string      `json:"error_message"`
	LessonData   *LessonView `json:"lesson_data,omitempty"`
}
type AssignmentSummary struct {
	AssignmentID      uuid.UUID `json:"assignment_id"`
	StudentID         uuid.UUID `json:"student_id"`
	StudentName       string    `json:"student_name"`
	Title             string    `json:"title"`
	Status            string    `json:"status"`
	AssignedAt        time.Time `json:"assigned_at"`
	CorrectCount      int       `json:"correct_count"`
	GradedCount       int       `json:"graded_count"`
	TotalCount        int       `json:"total_count"`
	StudentPageWebURL string    `json:"student_page_web_url"`
	TeacherPageWebURL string    `json:"teacher_page_web_url"`
}
type AnswerView struct {
	SelectedOption string   `json:"selected_option,omitempty"`
	Text           string   `json:"text"`
	HasImages      bool     `json:"has_images"`
	TargetParts    []string `json:"target_parts,omitempty"`
}
type EssayPartResultView struct {
	Label    string `json:"label"`
	Selected bool   `json:"selected"`
	Correct  bool   `json:"correct"`
	Comment  string `json:"comment"`
}
type AssignmentItemView struct {
	ID            uuid.UUID             `json:"id"`
	Exercise      ExerciseView          `json:"exercise"`
	Answer        *AnswerView           `json:"answer,omitempty"`
	Outcome       string                `json:"outcome"`
	IsEvaluated   bool                  `json:"is_evaluated"`
	IsValid       bool                  `json:"is_valid"`
	InvalidReason string                `json:"invalid_reason"`
	OutputResult  string                `json:"output_result"`
	Comment       string                `json:"comment"`
	SubItems      []EssayPartResultView `json:"sub_items"`
}
type AssignmentDetailView struct {
	AssignmentID      uuid.UUID            `json:"assignment_id"`
	StudentID         uuid.UUID            `json:"student_id"`
	StudentName       string               `json:"student_name"`
	Title             string               `json:"title"`
	Status            string               `json:"status"`
	AssignedAt        time.Time            `json:"assigned_at"`
	Purpose           string               `json:"purpose"`
	OriginMistakeID   *uuid.UUID           `json:"origin_mistake_id,omitempty"`
	StudentPageWebURL string               `json:"student_page_web_url"`
	TeacherPageWebURL string               `json:"teacher_page_web_url"`
	Items             []AssignmentItemView `json:"items"`
}
type MistakeNodeView struct {
	ID                 uuid.UUID         `json:"id"`
	Topic              string            `json:"topic"`
	Reason             string            `json:"reason"`
	Status             string            `json:"status"`
	CreatedAt          time.Time         `json:"created_at"`
	ResolvedAt         *time.Time        `json:"resolved_at,omitempty"`
	SourceItemID       uuid.UUID         `json:"source_item_id"`
	SourceAssignmentID *uuid.UUID        `json:"source_assignment_id,omitempty"`
	Children           []MistakeNodeView `json:"children"`
}
type StudentMistakeGroup struct {
	StudentID   uuid.UUID         `json:"student_id"`
	StudentName string            `json:"student_name"`
	Mistakes    []MistakeNodeView `json:"mistakes"`
}
type DocumentView struct {
	ID          uuid.UUID `json:"id"`
	FileName    string    `json:"file_name"`
	Status      string    `json:"status"`
	PageCount   int       `json:"page_count"`
	PreviewURLs []string  `json:"preview_urls"`
	ErrorReason string    `json:"error_reason"`
	CreatedAt   time.Time `json:"created_at"`
}
