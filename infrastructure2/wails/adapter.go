package wails

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	"uuid"

	wailsRuntime "github.com/wailsapp/wails/v2/pkg/runtime"

	"meet-attendance-clean/application2"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure/onenote"
	"meet-attendance-clean/infrastructure2/googlemeet"
)

const pdfStreamAddress = "127.0.0.1:8765"

// ============================================================================
// 1. APP CORE & DEPENDENCIES
// ============================================================================

type Application2Services struct {
	ListAIModels              func(context.Context) ([]ModelView, error)
	Queries                   *application2.Queries
	SyncMeetings              *application2.SyncMeetingUsecase
	GenerateLesson            *application2.GenerateLessonUsecase
	GenerateRemediationLesson *application2.GenerateRemediationLessonUsecase
	UpdateLessonDraft         *application2.UpdateLessonDraftUsecase
	UpdateStudent             *application2.UpdateInfoStudentUsecase
	PreparePublishingTargets  *application2.PreparePublishingTargetsUsecase
	AssignLesson              *application2.AssignLessonUsecase
	GradeAssignment           *application2.GradeAssignmentUsecase
	Lessons                   application2.LessonRepo
	Assignments               application2.AssignmentRepo
	Workspace                 application2.WorkSpaceGateway
	StorageRoot               string
	UploadHandler             *application2.UploadDocumentHandler
	ExtractHandler            *application2.ExtractPagesHandler
	DocRepo                   application2.DocumentRepository
}

type App struct {
	ctx           context.Context
	oneNoteClient *onenote.Client
	meetClient    *googlemeet.Client
	application2  *Application2Services
}

func NewApp(oneNoteClient *onenote.Client, meetClient *googlemeet.Client) *App {
	return &App{
		oneNoteClient: oneNoteClient,
		meetClient:    meetClient,
	}
}

func (a *App) SetApplication2Services(services *Application2Services) {
	a.application2 = services
}

func (a *App) Startup(ctx context.Context) {
	a.ctx = ctx
	go a.startPDFStreamServer()
}

// parseID là hàm tiện ích validate UUID nội bộ
func parseID(value string, field string) (uuid.UUID, error) {
	id, err := uuid.Parse(strings.TrimSpace(value))
	if err != nil || id == uuid.Nil() {
		return uuid.Nil(), fmt.Errorf("%s không hợp lệ", field)
	}
	return id, nil
}

// ============================================================================
// 2. DASHBOARD
// ============================================================================

type DashboardRequest struct {
	SearchName         string    `json:"search_name"`
	FromDate           time.Time `json:"from_date"`
	ToDate             time.Time `json:"to_date"`
	MinDurationMinutes int       `json:"min_duration_minutes"`
}

func (a *App) V2GetDashboard(request DashboardRequest) (application2.DashboardView, error) {
	search := strings.TrimSpace(request.SearchName)
	var searchPtr *string
	if search != "" {
		searchPtr = &search
	}

	filter := application2.StudentFilter{
		SearchName:         searchPtr,
		FromDate:           request.FromDate,
		ToDate:             request.ToDate,
		MinDurationMinutes: request.MinDurationMinutes,
	}
	return a.application2.Queries.GetDashboard(a.ctx, filter)
}

// ============================================================================
// 3. STUDENT DETAIL & UPDATE
// ============================================================================

type StudentDetailRequest struct {
	StudentID          string    `json:"student_id"`
	FromDate           time.Time `json:"from_date"`
	ToDate             time.Time `json:"to_date"`
	MinDurationMinutes int       `json:"min_duration_minutes"`
}

func (a *App) V2GetStudentDetail(request StudentDetailRequest) (application2.StudentDetailView, error) {
	id, err := parseID(request.StudentID, "student_id")
	if err != nil {
		return application2.StudentDetailView{}, err
	}

	filter := application2.MeetingFilter{
		FromDate:           request.FromDate,
		ToDate:             request.ToDate,
		MinDurationMinutes: request.MinDurationMinutes,
	}
	return a.application2.Queries.GetStudentDetail(a.ctx, id, filter)
}

type UpdateStudentRequest struct {
	StudentID     string `json:"student_id"`
	Name          string `json:"name"`
	StartCycleDay int    `json:"start_cycle_day"`
}

func (a *App) V2UpdateStudent(request UpdateStudentRequest) error {
	id, err := parseID(request.StudentID, "student_id")
	if err != nil {
		return err
	}

	command := application2.UpdateInfoStudentCommand{
		StudentID:     id,
		Name:          strings.TrimSpace(request.Name),
		StartCycleDay: request.StartCycleDay,
	}
	return a.application2.UpdateStudent.UpdateInfoStudent(a.ctx, command)
}

func (a *App) V2ListStudentChoices() ([]application2.StudentView, error) {
	return a.application2.Queries.ListStudentChoices(a.ctx)
}

// ============================================================================
// 4. MEETINGS SYNC
// ============================================================================

func (a *App) V2SyncMeetings() error {
	ctx, cancel := context.WithTimeout(a.ctx, 10*time.Minute)
	defer cancel()

	log.Println("Bắt đầu đồng bộ buổi học từ Google Meet...")
	err := a.application2.SyncMeetings.Sync(ctx)
	if err != nil {
		log.Println("Đồng bộ buổi học thất bại:", err)
		return err
	}
	return nil
}

// ============================================================================
// 5. AI MODELS
// ============================================================================

type ModelView struct {
	ID          string `json:"id"`
	DisplayName string `json:"display_name"`
	Description string `json:"description"`
}

func (a *App) V2ListAIModels() ([]ModelView, error) {
	return a.application2.ListAIModels(a.ctx)
}

// ============================================================================
// 6. LESSON GENERATION (URL & PDF)
// ============================================================================

type GenerateLessonRequest struct {
	Title      string `json:"title"`
	Model      string `json:"model"`
	Prompt     string `json:"prompt"`
	URL        string `json:"url"`
	Material   string `json:"material"`
	DocumentID string `json:"document_id"`
	Pages      []int  `json:"pages"`
}

func (a *App) V2CreateLesson(request GenerateLessonRequest) (string, error) {
	if strings.EqualFold(strings.TrimSpace(request.Material), "pdf") {
		return "", fmt.Errorf("PDF cần được tạo material sau khi kiểm tra document")
	}
	if strings.TrimSpace(request.URL) == "" {
		return "", fmt.Errorf("đường dẫn YouTube không được để trống")
	}

	material, err := lesson.NewYouTubeMaterial(request.URL)
	if err != nil {
		return "", err
	}

	cmd := application2.GenerateLessonCommand{
		Title:    strings.TrimSpace(request.Title),
		Model:    strings.TrimSpace(request.Model),
		Prompt:   strings.TrimSpace(request.Prompt),
		Material: material,
	}

	id, err := a.application2.GenerateLesson.Create(a.ctx, cmd)
	if err != nil {
		return "", err
	}
	return id.String(), nil
}

func (a *App) CreateByUrl(request GenerateLessonRequest) (string, error) {
	return a.V2CreateLesson(request)
}

func (a *App) V2CreateLessonFromPDF(request GenerateLessonRequest) (string, error) {
	if !strings.EqualFold(strings.TrimSpace(request.Material), "pdf") {
		return "", fmt.Errorf("material không phải PDF")
	}

	docID, err := parseID(request.DocumentID, "document_id")
	if err != nil {
		return "", err
	}

	// 1. Lấy thông tin tài liệu gốc từ database để lấy file path thật
	doc, err := a.application2.DocRepo.GetByID(a.ctx, docID)
	if err != nil {
		return "", fmt.Errorf("không tìm thấy tài liệu: %w", err)
	}

	// 2. Tạo Domain Material với file gốc và danh sách trang chọn
	material, err := lesson.NewSlicedPDFMaterial(doc.FilePath, request.Pages)
	if err != nil {
		return "", err
	}

	// 3. Đẩy Command sang Use Case xử lý
	cmd := application2.GenerateLessonCommand{
		Title:    strings.TrimSpace(request.Title),
		Model:    strings.TrimSpace(request.Model),
		Prompt:   strings.TrimSpace(request.Prompt),
		Material: material,
	}

	id, err := a.application2.GenerateLesson.Create(a.ctx, cmd)
	if err != nil {
		return "", err
	}
	return id.String(), nil
}

func (a *App) CreateByPDf(_ GenerateLessonRequest) (string, error) {
	return "", nil
}

// ============================================================================
// 7. LESSON DRAFTS & SAVING (ĐÃ TỐI ƯU HỖ TRỢ OPTION OBJECT TỪ FRONTEND)
// ============================================================================

type ExampleUpdate struct {
	ExampleNum                 int    `json:"example_num"`
	Problem                    string `json:"problem"`
	TeacherSolution            string `json:"teacher_solution"`
	StudentFriendlyExplanation string `json:"student_friendly_explanation"`
	CommonMistake              string `json:"common_mistake"`
}

type SectionUpdate struct {
	SectionTitle      string          `json:"section_title"`
	TransitionIntro   string          `json:"transition_intro"`
	DetailedContent   string          `json:"detailed_content"`
	KeyTakeaway       string          `json:"key_takeaway"`
	StudentClozeNotes []string        `json:"student_cloze_notes"`
	TeacherExamples   []ExampleUpdate `json:"teacher_examples"`
}

type PartUpdate struct {
	Label    string `json:"label"`
	Question string `json:"question"`
	Solution string `json:"solution"`
	Rubric   string `json:"rubric"`
}

// OptionUpdate linh hoạt: Nhận cả object {label, content} lẫn string "A. ..." từ frontend
type OptionUpdate struct {
	Label   string `json:"label"`
	Content string `json:"content"`
}

func (o *OptionUpdate) UnmarshalJSON(b []byte) error {
	// Trường hợp 1: Frontend gửi dạng object {"label": "A", "content": "..."}
	type alias OptionUpdate
	var obj alias
	if err := json.Unmarshal(b, &obj); err == nil && (obj.Label != "" || obj.Content != "") {
		*o = OptionUpdate(obj)
		return nil
	}

	// Trường hợp 2: Frontend gửi dạng chuỗi string "A. ..." hoặc "..."
	var str string
	if err := json.Unmarshal(b, &str); err == nil {
		o.Content = strings.TrimSpace(str)
		return nil
	}

	return nil
}

type ExerciseUpdate struct {
	Type        string         `json:"type"`
	Topic       string         `json:"topic"`
	Difficulty  string         `json:"difficulty"`
	Question    string         `json:"question"`
	Options     []OptionUpdate `json:"options"` // Hỗ trợ mảng OptionUpdate
	Answer      string         `json:"answer"`
	Explanation string         `json:"explanation"`
	Parts       []PartUpdate   `json:"parts"`
}

type LessonUpdate struct {
	Title     string           `json:"title"`
	Overview  string           `json:"overview"`
	Sections  []SectionUpdate  `json:"sections"`
	Exercises []ExerciseUpdate `json:"exercises"`
}

type SaveLessonDraftRequest struct {
	DraftID string       `json:"draft_id"`
	Lesson  LessonUpdate `json:"lesson"`
}

func (a *App) V2ListLessonDrafts() ([]application2.DraftView, error) {
	return a.application2.Queries.ListLessonDrafts(a.ctx)
}

func (a *App) V2GetLessonDraft(id string) (application2.DraftView, error) {
	parsed, err := parseID(id, "draft_id")
	if err != nil {
		return application2.DraftView{}, err
	}
	return a.application2.Queries.GetLessonDraft(a.ctx, parsed)
}

// func (a *App) V2SaveLessonDraft(request SaveLessonDraftRequest) error {
// 	draftID, err := parseID(request.DraftID, "draft_id")
// 	if err != nil {
// 		return err
// 	}

// 	// Chuyển đổi dữ liệu sang struct application2.LessonUpdate
// 	appLesson := LessonUpdate{
// 		Title:    request.Lesson.Title,
// 		Overview: request.Lesson.Overview,
// 	}

// 	for _, s := range request.Lesson.Sections {
// 		examples := make([]ExampleUpdate, 0, len(s.TeacherExamples))
// 		for _, e := range s.TeacherExamples {
// 			examples = append(examples, ExampleUpdate{
// 				ExampleNum:                 e.ExampleNum,
// 				Problem:                    e.Problem,
// 				TeacherSolution:            e.TeacherSolution,
// 				StudentFriendlyExplanation: e.StudentFriendlyExplanation,
// 				CommonMistake:              e.CommonMistake,
// 			})
// 		}
// 		appLesson.Sections = append(appLesson.Sections, SectionUpdate{
// 			SectionTitle:      s.SectionTitle,
// 			TransitionIntro:   s.TransitionIntro,
// 			DetailedContent:   s.DetailedContent,
// 			KeyTakeaway:       s.KeyTakeaway,
// 			StudentClozeNotes: s.StudentClozeNotes,
// 			TeacherExamples:   examples,
// 		})
// 	}

// 	for _, ex := range request.Lesson.Exercises {
// 		parts := make([]PartUpdate, 0, len(ex.Parts))
// 		for _, p := range ex.Parts {
// 			parts = append(parts, PartUpdate{
// 				Label:    p.Label,
// 				Question: p.Question,
// 				Solution: p.Solution,
// 				Rubric:   p.Rubric,
// 			})
// 		}

// 		options := make([]OptionUpdate, 0, len(ex.Options))
// 		for _, opt := range ex.Options {
// 			options = append(options, OptionUpdate{
// 				Label:   opt.Label,
// 				Content: opt.Content,
// 			})
// 		}

// 		appLesson.Exercises = append(appLesson.Exercises, ExerciseUpdate{
// 			Type:        ex.Type,
// 			Topic:       ex.Topic,
// 			Difficulty:  ex.Difficulty,
// 			Question:    ex.Question,
// 			Options:     options,
// 			Answer:      ex.Answer,
// 			Explanation: ex.Explanation,
// 			Parts:       parts,
// 		})
// 	}
// 	lesson ,err:= BuildLesson(appLesson, draftID, )

// 	return a.application2.UpdateLessonDraft.UpdateContent(a.ctx, draftID, appLesson)
// }

// // BuildLesson chuyển đổi DTO LessonUpdate sang Lesson Domain Entity
// func BuildLesson(input LessonUpdate, id uuid.UUID, material lesson.StudyMaterial) (*lesson.Lesson, error) {
// 	sections := make([]lesson.Section, 0, len(input.Sections))
// 	for _, section := range input.Sections {
// 		examples := make([]lesson.TeacherExample, 0, len(section.TeacherExamples))
// 		for _, example := range section.TeacherExamples {
// 			examples = append(examples, lesson.TeacherExample{
// 				ExampleNum:                 example.ExampleNum,
// 				Problem:                    example.Problem,
// 				TeacherSolution:            example.TeacherSolution,
// 				StudentFriendlyExplanation: example.StudentFriendlyExplanation,
// 				CommonMistake:              example.CommonMistake,
// 			})
// 		}
// 		sections = append(sections, lesson.Section{
// 			SectionTitle:      section.SectionTitle,
// 			TransitionIntro:   section.TransitionIntro,
// 			DetailedContent:   section.DetailedContent,
// 			KeyTakeaway:       section.KeyTakeaway,
// 			StudentClozeNotes: section.StudentClozeNotes,
// 			TeacherExamples:   examples,
// 		})
// 	}

// 	exercises := make([]exercise.Exercise, 0, len(input.Exercises))
// 	for _, item := range input.Exercises {
// 		topic := strings.TrimSpace(item.Topic)
// 		if topic == "" {
// 			topic = "Toán tổng hợp"
// 		}

// 		kind := strings.ToLower(strings.TrimSpace(item.Type))

// 		// Xử lý bài tập TRẮC NGHIỆM
// 		if kind == string(exercise.ExerciseTypeMultipleChoice) || strings.EqualFold(kind, "trắc nghiệm") {
// 			options := make([]exercise.MCOption, 0, len(item.Options))
// 			for index, opt := range item.Options {
// 				label := strings.TrimSpace(opt.Label)
// 				if label == "" {
// 					label = string(rune('A' + index))
// 				}

// 				content := strings.TrimSpace(opt.Content)
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

// 		// Xử lý bài tập TỰ LUẬN
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

// ============================================================================
// 8. DOCUMENTS
// ============================================================================

func (a *App) V2ListDocuments() ([]application2.Document, error) {
	return a.application2.DocRepo.List(a.ctx)
}

func (a *App) V2UploadDocument() (*application2.Document, error) {
	path, err := wailsRuntime.OpenFileDialog(a.ctx, wailsRuntime.OpenDialogOptions{
		Title:   "Chọn tài liệu PDF hoặc Word",
		Filters: []wailsRuntime.FileFilter{{DisplayName: "PDF hoặc Word", Pattern: "*.pdf;*.docx"}},
	})
	if err != nil {
		return nil, err
	}
	if strings.TrimSpace(path) == "" {
		return nil, nil
	}
	return a.application2.UploadHandler.Upload(a.ctx, application2.UploadCommand{SourceFilePath: path})
}

func (a *App) V2GetDocument(id string) (*application2.Document, error) {
	parsed, err := parseID(id, "document_id")
	if err != nil {
		return nil, err
	}
	return a.application2.DocRepo.GetByID(a.ctx, parsed)
}

// ============================================================================
// 9. ASSIGNMENTS & GRADING
// ============================================================================

func (a *App) V2ListAssignments(search string) ([]application2.AssignmentSummary, error) {
	return a.application2.Queries.ListGradingPages(a.ctx, search)
}

func (a *App) V2GetAssignment(id string) (application2.AssignmentDetailView, error) {
	parsed, err := parseID(id, "assignment_id")
	if err != nil {
		return application2.AssignmentDetailView{}, err
	}
	return a.application2.Queries.GetAssignment(a.ctx, parsed)
}

type GradeRequest struct {
	AssignmentID string   `json:"assignment_id"`
	ItemIDs      []string `json:"item_ids"`
	Prompt       string   `json:"prompt"`
	Model        string   `json:"model"`
}

func (a *App) V2GradeAssignment(request GradeRequest) error {
	assignmentID, err := parseID(request.AssignmentID, "assignment_id")
	if err != nil {
		return err
	}

	itemIDs := make([]uuid.UUID, 0, len(request.ItemIDs))
	for _, raw := range request.ItemIDs {
		id, parseErr := parseID(raw, "item_id")
		if parseErr != nil {
			return parseErr
		}
		itemIDs = append(itemIDs, id)
	}

	cmd := application2.GradeAssignmentCommand{
		AssignmentID: assignmentID,
		ItemIDs:      itemIDs,
		Prompt:       request.Prompt,
		Model:        request.Model,
	}
	return a.application2.GradeAssignment.Grade(a.ctx, cmd)
}

func (a *App) V2PushAssignmentFeedback(id string) error {
	assignmentID, err := parseID(id, "assignment_id")
	if err != nil {
		return err
	}
	value, err := a.application2.Assignments.GetByID(a.ctx, assignmentID)
	if err != nil {
		return err
	}
	return a.application2.Workspace.PatchFeedback(a.ctx, assignmentID, value.Items())
}

// ============================================================================
// 10. REMEDIATION & MISTAKES
// ============================================================================

func (a *App) V2ListMistakes() ([]application2.StudentMistakeGroup, error) {
	return a.application2.Queries.ListMistakes(a.ctx)
}

type RemediationRequest struct {
	StudentID string `json:"student_id"`
	MistakeID string `json:"mistake_id"`
	Title     string `json:"title"`
	Model     string `json:"model"`
	Prompt    string `json:"prompt"`
}

func (a *App) V2GenerateRemediation(request RemediationRequest) (string, error) {
	studentID, err := parseID(request.StudentID, "student_id")
	if err != nil {
		return "", err
	}
	mistakeID, err := parseID(request.MistakeID, "mistake_id")
	if err != nil {
		return "", err
	}

	cmd := application2.GenerateRemediationLessonCommand{
		StudentID: studentID,
		MistakeID: mistakeID,
		Title:     request.Title,
		Model:     request.Model,
		Prompt:    request.Prompt,
	}

	id, err := a.application2.GenerateRemediationLesson.Create(a.ctx, cmd)
	if err != nil {
		return "", err
	}
	return id.String(), nil
}

// ============================================================================
// 11. PUBLISHING TARGETS & PUBLISH LESSON
// ============================================================================

type PreparePublishingRequest struct {
	StudentID string `json:"student_id"`
}

func (a *App) V2PreparePublishing(request PreparePublishingRequest) (application2.PublishingTargets, error) {
	id, err := parseID(request.StudentID, "student_id")
	if err != nil {
		return application2.PublishingTargets{}, err
	}
	return a.application2.PreparePublishingTargets.Prepare(a.ctx, id)
}

type PublishLessonRequest struct {
	LessonID           string `json:"lesson_id"`
	StudentID          string `json:"student_id"`
	PageName           string `json:"page_name"`
	StudentChapterName string `json:"student_chapter_name"`
	TeacherChapterName string `json:"teacher_chapter_name"`
}

func (a *App) V2PublishLesson(request PublishLessonRequest) error {
	lessonID, err := parseID(request.LessonID, "lesson_id")
	if err != nil {
		return err
	}
	studentID, err := parseID(request.StudentID, "student_id")
	if err != nil {
		return err
	}

	value, err := a.application2.Lessons.GetByID(a.ctx, lessonID)
	if err != nil {
		return err
	}

	// Bài học khắc phục lỗi (Remediation) có chu trình MistakeGraph riêng biệt
	if _, ok := value.Material().(lesson.MistakeMaterial); ok {
		return a.application2.AssignLesson.AssignRemediation(a.ctx, application2.AssignRemediationLessonCommand{
			LessonID:           lessonID,
			PageName:           request.PageName,
			StudentChapterName: request.StudentChapterName,
			TeacherChapterName: request.TeacherChapterName,
		})
	}

	return a.application2.AssignLesson.AssignNormal(a.ctx, application2.AssignNormalLessonCommand{
		LessonID:           lessonID,
		StudentID:          studentID,
		PageName:           request.PageName,
		StudentChapterName: request.StudentChapterName,
		TeacherChapterName: request.TeacherChapterName,
	})
}

// ============================================================================
// 12. OAUTH FLOW (TẬP TRUNG TẠI APP.GO & DÙNG WAILS RUNTIME ĐỂ MỞ BROWSER)
// ============================================================================

func (a *App) ConnectOneNote() error {
	authURL := a.oneNoteClient.AuthorizationURL("onenote-auth")
	return a.runOAuthFlow("OneNote", authURL, a.oneNoteClient.Exchange)
}

func (a *App) ConnectGoogleMeet() error {
	authURL := a.meetClient.AuthorizationURL("google-auth")
	return a.runOAuthFlow("Google Meet", authURL, a.meetClient.Exchange)
}

func (a *App) runOAuthFlow(
	serviceName string,
	authURL string,
	exchangeFn func(ctx context.Context, code string) error,
) error {
	flowCtx, cancel := context.WithTimeout(a.ctx, 3*time.Minute)
	defer cancel()

	resultChan := make(chan error, 1)
	sendResult := func(err error) {
		select {
		case resultChan <- err:
		default:
		}
	}

	server := &http.Server{
		Addr: ":9000",
		Handler: http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			if r.URL.Path == "/favicon.ico" {
				http.NotFound(w, r)
				return
			}

			if authErr := r.URL.Query().Get("error"); authErr != "" {
				errDesc := r.URL.Query().Get("error_description")
				if errDesc == "" {
					errDesc = authErr
				}
				http.Error(w, "Bạn đã từ chối cấp quyền: "+errDesc, http.StatusUnauthorized)
				sendResult(fmt.Errorf("người dùng từ chối cấp quyền: %s", errDesc))
				return
			}

			code := r.URL.Query().Get("code")
			if code == "" {
				http.Redirect(w, r, authURL, http.StatusTemporaryRedirect)
				return
			}

			if err := exchangeFn(r.Context(), code); err != nil {
				http.Error(w, "Đổi token thất bại: "+err.Error(), http.StatusInternalServerError)
				sendResult(fmt.Errorf("đổi token thất bại: %w", err))
				return
			}

			w.Header().Set("Content-Type", "text/html; charset=utf-8")
			fmt.Fprintf(w, `
				<html>
				<head><meta charset="utf-8"><title>Thành công</title></head>
				<body style="font-family: system-ui, sans-serif; text-align: center; padding: 60px 20px; background: #f8faf9;">
					<div style="max-width: 480px; margin: auto; background: #fff; padding: 30px; border-radius: 12px; border: 1px solid #e2e8f0;">
						<h2 style="color: #15803d; margin-top: 0;">Đăng nhập %s thành công!</h2>
						<p style="color: #64748b;">Bạn có thể đóng tab này và quay lại ứng dụng Desktop.</p>
					</div>
				</body>
				</html>
			`, serviceName)

			sendResult(nil)
		}),
	}

	defer func() {
		shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 2*time.Second)
		defer shutdownCancel()
		_ = server.Shutdown(shutdownCtx)
	}()

	go func() {
		if err := server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			sendResult(err)
		}
	}()

	wailsRuntime.BrowserOpenURL(a.ctx, authURL)

	select {
	case err := <-resultChan:
		return err
	case <-flowCtx.Done():
		if errors.Is(flowCtx.Err(), context.DeadlineExceeded) {
			return fmt.Errorf("quá thời gian đăng nhập %s (Timeout)", serviceName)
		}
		return flowCtx.Err()
	}
}

// ============================================================================
// 13. PDF STREAM SERVER (PHỤC VỤ VIEWER LOCAL)
// ============================================================================

func (a *App) startPDFStreamServer() {
	mux := http.NewServeMux()
	mux.HandleFunc("/pdf-stream", a.servePDFStream)
	server := &http.Server{Addr: pdfStreamAddress, Handler: mux}
	log.Printf("PDF stream server listening at http://%s", pdfStreamAddress)
	if err := server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
		log.Printf("PDF stream server stopped: %v", err)
	}
}

func (a *App) servePDFStream(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, HEAD, OPTIONS")
	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusNoContent)
		return
	}
	if r.Method != http.MethodGet && r.Method != http.MethodHead {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	if a.application2 == nil || a.application2.DocRepo == nil {
		http.Error(w, "document service unavailable", http.StatusServiceUnavailable)
		return
	}

	documentID, err := parseID(r.URL.Query().Get("id"), "document_id")
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	doc, err := a.application2.DocRepo.GetByID(r.Context(), documentID)
	if err != nil {
		http.Error(w, "document not found", http.StatusNotFound)
		return
	}

	file, err := os.Open(doc.FilePath)
	if err != nil {
		http.Error(w, "document file unavailable", http.StatusNotFound)
		return
	}
	defer file.Close()

	info, err := file.Stat()
	if err != nil {
		http.Error(w, "cannot read document metadata", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/pdf")
	w.Header().Set("Accept-Ranges", "bytes")
	http.ServeContent(w, r, doc.FileName, info.ModTime(), file)
}
