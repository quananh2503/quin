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

type TeacherExampleView struct {
	ExampleNum                 int    `json:"example_num"`
	Problem                    string `json:"problem"`
	TeacherSolution            string `json:"teacher_solution"`
	StudentFriendlyExplanation string `json:"student_friendly_explanation"`
	CommonMistake              string `json:"common_mistake"`
}
type SectionView struct {
	SectionTitle      string               `json:"section_title"`
	TransitionIntro   string               `json:"transition_intro"`
	DetailedContent   string               `json:"detailed_content"`
	KeyTakeaway       string               `json:"key_takeaway"`
	StudentClozeNotes []string             `json:"student_cloze_notes"`
	TeacherExamples   []TeacherExampleView `json:"teacher_examples"`
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
	Type        string          `json:"type"`
	Topic       string          `json:"topic"`
	Difficulty  string          `json:"difficulty"`
	Question    string          `json:"question"`
	Options     []OptionView    `json:"options"`
	Answer      string          `json:"answer"`
	Explanation string          `json:"explanation"`
	Parts       []EssayPartView `json:"parts"`
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
