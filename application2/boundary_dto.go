package application2

// import (
// 	"fmt"
// 	"strings"
// 	"time"
// 	"uuid"

// 	exercise "meet-attendance-clean/domain2/excercise"
// 	"meet-attendance-clean/domain2/lesson"
// )

// // Boundary DTOs keep the Wails/frontend contract independent from domain and infrastructure types.
// type DashboardRequest struct {
// 	SearchName         string    `json:"search_name"`
// 	FromDate           time.Time `json:"from_date"`
// 	ToDate             time.Time `json:"to_date"`
// 	MinDurationMinutes int       `json:"min_duration_minutes"`
// }

// type ModelView struct {
// 	ID          string `json:"id"`
// 	DisplayName string `json:"display_name"`
// 	Description string `json:"description"`
// }

// type StudentDetailRequest struct {
// 	StudentID          string    `json:"student_id"`
// 	FromDate           time.Time `json:"from_date"`
// 	ToDate             time.Time `json:"to_date"`
// 	MinDurationMinutes int       `json:"min_duration_minutes"`
// }

// type UpdateStudentRequest struct {
// 	StudentID     string `json:"student_id"`
// 	Name          string `json:"name"`
// 	StartCycleDay int    `json:"start_cycle_day"`
// }

// type GenerateLessonRequest struct {
// 	Title      string `json:"title"`
// 	Model      string `json:"model"`
// 	Prompt     string `json:"prompt"`
// 	URL        string `json:"url"`
// 	Material   string `json:"material"`
// 	DocumentID string `json:"document_id"`
// 	Pages      []int  `json:"pages"`
// }

// type SaveLessonDraftRequest struct {
// 	DraftID string       `json:"draft_id"`
// 	Lesson  LessonUpdate `json:"lesson"`
// }

// type LessonUpdate struct {
// 	Title     string           `json:"title"`
// 	Overview  string           `json:"overview"`
// 	Sections  []SectionUpdate  `json:"sections"`
// 	Exercises []ExerciseUpdate `json:"exercises"`
// }

// type SectionUpdate struct {
// 	SectionTitle      string          `json:"section_title"`
// 	TransitionIntro   string          `json:"transition_intro"`
// 	DetailedContent   string          `json:"detailed_content"`
// 	KeyTakeaway       string          `json:"key_takeaway"`
// 	StudentClozeNotes []string        `json:"student_cloze_notes"`
// 	TeacherExamples   []ExampleUpdate `json:"teacher_examples"`
// }

// type ExampleUpdate struct {
// 	ExampleNum                 int    `json:"example_num"`
// 	Problem                    string `json:"problem"`
// 	TeacherSolution            string `json:"teacher_solution"`
// 	StudentFriendlyExplanation string `json:"student_friendly_explanation"`
// 	CommonMistake              string `json:"common_mistake"`
// }

// type ExerciseUpdate struct {
// 	Type        string       `json:"type"`
// 	Topic       string       `json:"topic"`
// 	Difficulty  string       `json:"difficulty"`
// 	Question    string       `json:"question"`
// 	Options     []string     `json:"options"`
// 	Answer      string       `json:"answer"`
// 	Explanation string       `json:"explanation"`
// 	Parts       []PartUpdate `json:"parts"`
// }

// type PartUpdate struct {
// 	Label    string `json:"label"`
// 	Question string `json:"question"`
// 	Solution string `json:"solution"`
// 	Rubric   string `json:"rubric"`
// }

// type GradeRequest struct {
// 	AssignmentID string   `json:"assignment_id"`
// 	ItemIDs      []string `json:"item_ids"`
// 	Prompt       string   `json:"prompt"`
// 	Model        string   `json:"model"`
// }

// type PublishLessonRequest struct {
// 	LessonID           string `json:"lesson_id"`
// 	StudentID          string `json:"student_id"`
// 	PageName           string `json:"page_name"`
// 	StudentChapterName string `json:"student_chapter_name"`
// 	TeacherChapterName string `json:"teacher_chapter_name"`
// }

// type PreparePublishingRequest struct {
// 	StudentID string `json:"student_id"`
// }

// type RemediationRequest struct {
// 	StudentID string `json:"student_id"`
// 	MistakeID string `json:"mistake_id"`
// 	Title     string `json:"title"`
// 	Model     string `json:"model"`
// 	Prompt    string `json:"prompt"`
// }

// func ParseID(value string, field string) (uuid.UUID, error) {
// 	id, err := uuid.Parse(strings.TrimSpace(value))
// 	if err != nil || id == uuid.Nil() {
// 		return uuid.Nil(), fmt.Errorf("%s không hợp lệ", field)
// 	}
// 	return id, nil
// }

// func (r DashboardRequest) Filter() StudentFilter {
// 	search := strings.TrimSpace(r.SearchName)
// 	var ptr *string
// 	if search != "" {
// 		ptr = &search
// 	}
// 	return StudentFilter{SearchName: ptr, FromDate: r.FromDate, ToDate: r.ToDate, MinDurationMinutes: r.MinDurationMinutes}
// }

// func (r StudentDetailRequest) Filter() (uuid.UUID, MeetingFilter, error) {
// 	id, err := ParseID(r.StudentID, "student_id")
// 	return id, MeetingFilter{FromDate: r.FromDate, ToDate: r.ToDate, MinDurationMinutes: r.MinDurationMinutes}, err
// }

// func (r UpdateStudentRequest) Command() (UpdateInfoStudentCommand, error) {
// 	id, err := ParseID(r.StudentID, "student_id")
// 	return UpdateInfoStudentCommand{StudentID: id, Name: strings.TrimSpace(r.Name), StartCycleDay: r.StartCycleDay}, err
// }

// func (r GenerateLessonRequest) Command() (GenerateLessonCommand, error) {
// 	if strings.EqualFold(strings.TrimSpace(r.Material), "pdf") {
// 		return GenerateLessonCommand{}, fmt.Errorf("PDF cần được tạo material sau khi kiểm tra document")
// 	}
// 	if strings.TrimSpace(r.URL) == "" {
// 		return GenerateLessonCommand{}, fmt.Errorf("đường dẫn YouTube không được để trống")
// 	}
// 	material, err := lesson.NewYouTubeMaterial(r.URL)
// 	return GenerateLessonCommand{Title: strings.TrimSpace(r.Title), Model: strings.TrimSpace(r.Model), Prompt: strings.TrimSpace(r.Prompt), Material: material}, err
// }

// func (r GenerateLessonRequest) PDFCommand(path string) (GenerateLessonCommand, error) {
// 	if !strings.EqualFold(strings.TrimSpace(r.Material), "pdf") {
// 		return GenerateLessonCommand{}, fmt.Errorf("material không phải PDF")
// 	}
// 	if strings.TrimSpace(path) == "" {
// 		return GenerateLessonCommand{}, fmt.Errorf("đường dẫn PDF không được để trống")
// 	}
// 	material, err := lesson.NewSlicedPDFMaterial(path, r.Pages)
// 	if err != nil {
// 		return GenerateLessonCommand{}, err
// 	}
// 	return GenerateLessonCommand{Title: strings.TrimSpace(r.Title), Model: strings.TrimSpace(r.Model), Prompt: strings.TrimSpace(r.Prompt), Material: material}, nil
// }

// func (r GradeRequest) Command() (GradeAssignmentCommand, error) {
// 	assignmentID, err := ParseID(r.AssignmentID, "assignment_id")
// 	if err != nil {
// 		return GradeAssignmentCommand{}, err
// 	}
// 	itemIDs := make([]uuid.UUID, 0, len(r.ItemIDs))
// 	for _, raw := range r.ItemIDs {
// 		id, parseErr := ParseID(raw, "item_id")
// 		if parseErr != nil {
// 			return GradeAssignmentCommand{}, parseErr
// 		}
// 		itemIDs = append(itemIDs, id)
// 	}
// 	return GradeAssignmentCommand{AssignmentID: assignmentID, ItemIDs: itemIDs, Prompt: r.Prompt, Model: r.Model}, nil
// }

// func (r PublishLessonRequest) Command() (AssignNormalLessonCommand, error) {
// 	lessonID, err := ParseID(r.LessonID, "lesson_id")
// 	if err != nil {
// 		return AssignNormalLessonCommand{}, err
// 	}
// 	studentID, err := ParseID(r.StudentID, "student_id")
// 	if err != nil {
// 		return AssignNormalLessonCommand{}, err
// 	}
// 	return AssignNormalLessonCommand{LessonID: lessonID, StudentID: studentID, PageName: r.PageName, StudentChapterName: r.StudentChapterName, TeacherChapterName: r.TeacherChapterName}, nil
// }

// func (r PreparePublishingRequest) ID() (uuid.UUID, error) { return ParseID(r.StudentID, "student_id") }

// func (r RemediationRequest) Command() (GenerateRemediationLessonCommand, error) {
// 	studentID, err := ParseID(r.StudentID, "student_id")
// 	if err != nil {
// 		return GenerateRemediationLessonCommand{}, err
// 	}
// 	mistakeID, err := ParseID(r.MistakeID, "mistake_id")
// 	if err != nil {
// 		return GenerateRemediationLessonCommand{}, err
// 	}
// 	return GenerateRemediationLessonCommand{StudentID: studentID, MistakeID: mistakeID, Title: r.Title, Model: r.Model, Prompt: r.Prompt}, nil
// }

// func BuildLesson(input LessonUpdate, id uuid.UUID, material lesson.StudyMaterial) (*lesson.Lesson, error) {
// 	sections := make([]lesson.Section, 0, len(input.Sections))
// 	for _, section := range input.Sections {
// 		examples := make([]lesson.TeacherExample, 0, len(section.TeacherExamples))
// 		for _, example := range section.TeacherExamples {
// 			examples = append(examples, lesson.TeacherExample{ExampleNum: example.ExampleNum, Problem: example.Problem, TeacherSolution: example.TeacherSolution, StudentFriendlyExplanation: example.StudentFriendlyExplanation, CommonMistake: example.CommonMistake})
// 		}
// 		sections = append(sections, lesson.Section{SectionTitle: section.SectionTitle, TransitionIntro: section.TransitionIntro, DetailedContent: section.DetailedContent, KeyTakeaway: section.KeyTakeaway, StudentClozeNotes: section.StudentClozeNotes, TeacherExamples: examples})
// 	}
// 	exercises := make([]exercise.Exercise, 0, len(input.Exercises))
// 	for _, item := range input.Exercises {
// 		topic := strings.TrimSpace(item.Topic)
// 		if topic == "" {
// 			topic = "general"
// 		}
// 		kind := strings.ToLower(strings.TrimSpace(item.Type))
// 		if kind == string(exercise.ExerciseTypeMultipleChoice) || strings.EqualFold(kind, "trắc nghiệm") {
// 			options := make([]exercise.MCOption, 0, len(item.Options))
// 			for index, option := range item.Options {
// 				label := string(rune('A' + index))
// 				content := strings.TrimSpace(option)
// 				// The editor accepts both "Nội dung" and "A. Nội dung".
// 				for _, prefix := range []string{label + ".", label + ")", label + ":"} {
// 					if strings.HasPrefix(strings.ToUpper(content), prefix) {
// 						content = strings.TrimSpace(content[len(prefix):])
// 						break
// 					}
// 				}
// 				options = append(options, exercise.NewMCOption(label, content))
// 			}
// 			value, err := exercise.NewMultipleChoiceExercise(topic, item.Difficulty, item.Question, options, item.Answer, item.Explanation)
// 			if err != nil {
// 				return nil, err
// 			}
// 			exercises = append(exercises, value)
// 			continue
// 		}
// 		if kind != string(exercise.ExerciseTypeEssay) && !strings.EqualFold(kind, "tự luận") {
// 			return nil, fmt.Errorf("loại bài tập không hợp lệ: %q", item.Type)
// 		}
// 		parts := make([]exercise.EssayPart, 0, len(item.Parts))
// 		for _, part := range item.Parts {
// 			parts = append(parts, exercise.NewEssayPart(part.Label, part.Question, part.Solution, part.Rubric))
// 		}
// 		if len(parts) == 0 {
// 			parts = append(parts, exercise.NewEssayPart("a", item.Question, item.Answer, item.Explanation))
// 		}
// 		value, err := exercise.NewEssayExercise(topic, item.Difficulty, item.Question, parts)
// 		if err != nil {
// 			return nil, err
// 		}
// 		exercises = append(exercises, value)
// 	}
// 	return lesson.ReconstituteLesson(id, input.Title, input.Overview, sections, exercises, material)
// }
