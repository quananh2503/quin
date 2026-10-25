package wails

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	"uuid"

	wailsRuntime "github.com/wailsapp/wails/v2/pkg/runtime"

	"meet-attendance-clean/application2"
	"meet-attendance-clean/domain2/assignment"
	"meet-attendance-clean/domain2/lesson"

	// "meet-attendance-clean/infrastructure/onenote"
	"meet-attendance-clean/infrastructure2/gemini"
	"meet-attendance-clean/infrastructure2/googlemeet"
	"meet-attendance-clean/infrastructure2/onenote"
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
	Drafts                    application2.LessonDraftEditorRepo
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

func (a *App) SetContext(ctx context.Context) {
	a.ctx = ctx
}

func (a *App) getContext() context.Context {
	if a.ctx == nil {
		return context.Background()
	}
	return a.ctx
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
	Title       string   `json:"title"`
	Model       string   `json:"model"`
	Prompt      string   `json:"prompt"`
	URL         string   `json:"url"`
	URLs        []string `json:"urls"`
	Material    string   `json:"material"`
	DocumentID  string   `json:"document_id"`
	DocumentIDs []string `json:"document_ids"`
	Pages       []int    `json:"pages"`
}

func (a *App) V2CreateLesson(request GenerateLessonRequest) (string, error) {
	title := strings.TrimSpace(request.Title)
	if title == "" {
		return "", errors.New("tiêu đề bài học không được để trống")
	}

	materials := make([]lesson.StudyMaterial, 0)

	// 1. Xử lý tài liệu YouTube (hỗ trợ cả mảng URLs lẫn trường URL đơn lẻ)
	youtubeURLs := request.URLs
	if len(youtubeURLs) == 0 && strings.TrimSpace(request.URL) != "" {
		youtubeURLs = []string{request.URL}
	}
	for _, rawURL := range youtubeURLs {
		rawURL = strings.TrimSpace(rawURL)
		if rawURL == "" {
			continue
		}
		ytMaterial, err := lesson.NewYouTubeMaterial(rawURL)
		if err != nil {
			return "", fmt.Errorf("tài liệu YouTube không hợp lệ (%s): %w", rawURL, err)
		}
		materials = append(materials, ytMaterial)
	}

	// 2. Xử lý các tài liệu PDF (nếu có). DocumentID vẫn được hỗ trợ cho request cũ.
	documentIDs := request.DocumentIDs
	if len(documentIDs) == 0 && strings.TrimSpace(request.DocumentID) != "" {
		documentIDs = []string{request.DocumentID}
	}
	for _, documentID := range documentIDs {
		docUUID, err := uuid.Parse(strings.TrimSpace(documentID))
		if err != nil {
			return "", fmt.Errorf("document_id không hợp lệ: %w", err)
		}

		// Truy vấn bảng documents để lấy đường dẫn file thực tế trên ổ cứng
		// (Giả sử bạn gọi qua Repo Documents sẵn có trong DB)
		doc, err := a.application2.DocRepo.GetByID(a.getContext(), docUUID)
		if err != nil {
			return "", fmt.Errorf("không tìm thấy file PDF tương ứng: %w", err)
		}

		var pdfMaterial lesson.PDFMaterial
		if len(request.Pages) > 0 {
			// TRƯỜNG HỢP A: Người dùng có chọn trang cụ thể
			pdfMaterial, err = lesson.NewSlicedPDFMaterial(doc.FilePath, request.Pages)
		} else {
			// TRƯỜNG HỢP B (Nghiệp vụ mới): Lấy NGUYÊN FILE BỰ không cần chọn trang
			pdfMaterial, err = lesson.NewFullPDFMaterial(doc.FilePath)
		}

		if err != nil {
			return "", fmt.Errorf("khởi tạo tài liệu PDF thất bại: %w", err)
		}
		materials = append(materials, pdfMaterial)
	}

	// 3. Kiểm tra xem có ít nhất 1 tài liệu hay chưa
	if len(materials) == 0 {
		return "", errors.New("vui lòng cung cấp ít nhất một tài liệu (link YouTube hoặc file PDF)")
	}

	// 4. Tạo Command và gọi Use Case
	cmd := application2.GenerateLessonCommand{
		Title:    title,
		Model:    strings.TrimSpace(request.Model),
		Prompt:   strings.TrimSpace(request.Prompt),
		Material: materials, // Sửa lỗi typo: truyền slice materials
	}

	id, err := a.application2.GenerateLesson.Create(a.getContext(), cmd)
	if err != nil {
		fmt.Printf("Lỗi tạo lesson draft: %v\n", err)
		return "", fmt.Errorf("lỗi tạo lesson draft: %w", err)
	}

	return id.String(), nil
}

func (a *App) CreateByUrl(request GenerateLessonRequest) (string, error) {
	return a.V2CreateLesson(request)
}

// func (a *App) V2CreateLessonFromPDF(request GenerateLessonRequest) (string, error) {
// 	if !strings.EqualFold(strings.TrimSpace(request.Material), "pdf") {
// 		return "", fmt.Errorf("material không phải PDF")
// 	}

// 	docID, err := parseID(request.DocumentID, "document_id")
// 	if err != nil {
// 		return "", err
// 	}

// 	// 1. Lấy thông tin tài liệu gốc từ database để lấy file path thật
// 	doc, err := a.application2.DocRepo.GetByID(a.ctx, docID)
// 	if err != nil {
// 		return "", fmt.Errorf("không tìm thấy tài liệu: %w", err)
// 	}

// 	// 2. Tạo Domain Material với file gốc và danh sách trang chọn
// 	material, err := lesson.NewSlicedPDFMaterial(doc.FilePath, request.Pages)
// 	if err != nil {
// 		return "", err
// 	}

// 	// 3. Đẩy Command sang Use Case xử lý
// 	cmd := application2.GenerateLessonCommand{
// 		Title:    strings.TrimSpace(request.Title),
// 		Model:    strings.TrimSpace(request.Model),
// 		Prompt:   strings.TrimSpace(request.Prompt),
// 		Material: material,
// 	}

// 	id, err := a.application2.GenerateLesson.Create(a.getContext(), cmd)
// 	if err != nil {
// 		return "", err
// 	}
// 	return id.String(), nil
// }

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
	return a.application2.Queries.ListLessonDrafts(a.getContext())
}

func (a *App) V2GetLessonDraft(id string) (application2.DraftView, error) {
	parsed, err := parseID(id, "draft_id")
	if err != nil {
		return application2.DraftView{}, err
	}
	return a.application2.Queries.GetLessonDraft(a.getContext(), parsed)
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

func (a *App) V2UploadDocuments() ([]*application2.Document, error) {
	paths, err := wailsRuntime.OpenMultipleFilesDialog(a.ctx, wailsRuntime.OpenDialogOptions{
		Title:   "Chọn các tài liệu PDF",
		Filters: []wailsRuntime.FileFilter{{DisplayName: "PDF", Pattern: "*.pdf"}},
	})
	if err != nil {
		return nil, err
	}

	documents := make([]*application2.Document, 0, len(paths))
	for _, path := range paths {
		if strings.TrimSpace(path) == "" {
			continue
		}
		doc, uploadErr := a.application2.UploadHandler.Upload(a.ctx, application2.UploadCommand{SourceFilePath: path})
		if uploadErr != nil {
			return nil, fmt.Errorf("không thể tải file %q: %w", filepath.Base(path), uploadErr)
		}
		documents = append(documents, doc)
	}
	return documents, nil
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

// GetStudentNotebookRequest chứa thông tin truy vấn sổ tay OneNote của học sinh.
type GetStudentNotebookRequest struct {
	StudentID string `json:"student_id"`
	Audience  string `json:"audience,omitempty"`
}

// StudentNotebookView trả về trạng thái liên kết sổ tay OneNote của học sinh.
type StudentNotebookView struct {
	StudentID       string `json:"student_id"`
	Audience        string `json:"audience"`
	NotebookID      string `json:"notebook_id"`
	NotebookName    string `json:"notebook_name"`
	IsBound         bool   `json:"is_bound"`
	LastChapterName string `json:"last_chapter_name,omitempty"`
}

// ListOneNoteSectionsRequest chứa thông tin truy vấn các chương (sections) trong một sổ tay OneNote.
type ListOneNoteSectionsRequest struct {
	NotebookID string `json:"notebook_id"`
}

// SaveLastChapterRequest chứa thông tin lưu chương cuối cùng cho học sinh.
type SaveLastChapterRequest struct {
	StudentID   string `json:"student_id"`
	Audience    string `json:"audience,omitempty"`
	ChapterName string `json:"chapter_name"`
}

// BindStudentNotebookRequest chứa thông tin để liên kết học sinh với một cuốn sổ tay OneNote.
type BindStudentNotebookRequest struct {
	StudentID    string `json:"student_id"`
	Audience     string `json:"audience,omitempty"`
	NotebookID   string `json:"notebook_id"`
	NotebookName string `json:"notebook_name"`
}

// V2GetStudentNotebook lấy thông tin sổ tay OneNote đang liên kết với học sinh (mặc định audience "HS").
// Nếu chưa liên kết, trả về tên sổ tay mặc định và IsBound = false.
func (a *App) V2GetStudentNotebook(request GetStudentNotebookRequest) (StudentNotebookView, error) {
	studentUUID, err := parseID(request.StudentID, "student_id")
	if err != nil {
		return StudentNotebookView{}, err
	}
	audience := request.Audience
	if audience == "" {
		audience = "HS"
	}
	if a.oneNoteClient == nil {
		return StudentNotebookView{}, errors.New("OneNote client chưa được cấu hình")
	}
	binding, found, err := a.oneNoteClient.GetStudentNotebookBinding(a.getContext(), studentUUID, audience)
	if err != nil {
		return StudentNotebookView{}, fmt.Errorf("lấy thông tin sổ tay học sinh thất bại: %w", err)
	}

	var lastCh string
	if ch, chFound, chErr := a.oneNoteClient.GetStudentLastChapter(a.getContext(), studentUUID, audience); chErr == nil && chFound {
		lastCh = ch
	}

	if found {
		return StudentNotebookView{
			StudentID:       request.StudentID,
			Audience:        audience,
			NotebookID:      binding.ID,
			NotebookName:    binding.Name,
			IsBound:         true,
			LastChapterName: lastCh,
		}, nil
	}
	studentName := ""
	if a.application2 != nil && a.application2.Queries != nil {
		detail, qErr := a.application2.Queries.GetStudentDetail(a.getContext(), studentUUID, application2.MeetingFilter{})
		if qErr != nil {
			log.Printf("cảnh báo: không lấy được thông tin chi tiết học sinh %s: %v, sử dụng tên mặc định", studentUUID, qErr)
		} else if detail.Student.Name != "" {
			studentName = detail.Student.Name
		}
	}
	defaultName := onenote.DefaultNotebookName(studentName, audience)
	return StudentNotebookView{
		StudentID:       request.StudentID,
		Audience:        audience,
		NotebookID:      "",
		NotebookName:    defaultName,
		IsBound:         false,
		LastChapterName: lastCh,
	}, nil
}

// V2ListOneNoteNotebooks lấy danh sách các sổ tay OneNote của tài khoản giáo viên hiện tại từ Graph API.
func (a *App) V2ListOneNoteNotebooks() ([]onenote.NotebookInfo, error) {
	if a.oneNoteClient == nil {
		return nil, errors.New("OneNote client chưa được cấu hình")
	}
	notebooks, err := a.oneNoteClient.ListNotebooks(a.getContext())
	if err != nil {
		return nil, fmt.Errorf("lấy danh sách sổ tay OneNote thất bại: %w", err)
	}
	return notebooks, nil
}

// V2BindStudentNotebook cập nhật liên kết giữa học sinh và một cuốn sổ tay OneNote vào CSDL SQLite.
func (a *App) V2BindStudentNotebook(request BindStudentNotebookRequest) error {
	studentUUID, err := parseID(request.StudentID, "student_id")
	if err != nil {
		return err
	}
	if strings.TrimSpace(request.NotebookID) == "" {
		return errors.New("notebook_id không được để trống")
	}
	if strings.TrimSpace(request.NotebookName) == "" {
		return errors.New("notebook_name không được để trống")
	}
	audience := request.Audience
	if audience == "" {
		audience = "HS"
	}
	if a.oneNoteClient == nil {
		return errors.New("OneNote client chưa được cấu hình")
	}
	if err := a.oneNoteClient.BindStudentNotebook(a.getContext(), studentUUID, audience, strings.TrimSpace(request.NotebookID), strings.TrimSpace(request.NotebookName)); err != nil {
		return fmt.Errorf("liên kết sổ tay học sinh thất bại: %w", err)
	}
	return nil
}

// V2ListOneNoteSections truy vấn danh sách tất cả các chương (sections) trong một sổ tay OneNote qua Graph API.
func (a *App) V2ListOneNoteSections(request ListOneNoteSectionsRequest) ([]onenote.SectionInfo, error) {
	if strings.TrimSpace(request.NotebookID) == "" {
		return nil, errors.New("notebook_id không được để trống")
	}
	if a.oneNoteClient == nil {
		return nil, errors.New("OneNote client chưa được cấu hình")
	}
	sections, err := a.oneNoteClient.ListSections(a.getContext(), strings.TrimSpace(request.NotebookID))
	if err != nil {
		return nil, fmt.Errorf("lấy danh sách sections OneNote thất bại: %w", err)
	}
	return sections, nil
}

// V2SaveLastChapter lưu lại tên chương được chọn gần nhất của học sinh (HS hoặc GV) vào SQLite.
func (a *App) V2SaveLastChapter(request SaveLastChapterRequest) error {
	studentUUID, err := parseID(request.StudentID, "student_id")
	if err != nil {
		return err
	}
	if strings.TrimSpace(request.ChapterName) == "" {
		return errors.New("chapter_name không được để trống")
	}
	audience := request.Audience
	if audience == "" {
		audience = "HS"
	}
	if a.oneNoteClient == nil {
		return errors.New("OneNote client chưa được cấu hình")
	}
	if err := a.oneNoteClient.SaveStudentLastChapter(a.getContext(), studentUUID, audience, strings.TrimSpace(request.ChapterName)); err != nil {
		return fmt.Errorf("lưu tên chương thất bại: %w", err)
	}
	return nil
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
	materials := value.Materials()
	if len(materials) < 1 {
		return fmt.Errorf("lesson chưa có material nào, không thể publish")
	}
	// Bài học khắc phục lỗi (Remediation) có chu trình MistakeGraph riêng biệt
	var assignErr error
	if _, ok := materials[0].(lesson.MistakeMaterial); ok {
		assignErr = a.application2.AssignLesson.AssignRemediation(a.ctx, application2.AssignRemediationLessonCommand{
			LessonID:           lessonID,
			PageName:           request.PageName,
			StudentChapterName: request.StudentChapterName,
			TeacherChapterName: request.TeacherChapterName,
		})
	} else {
		assignErr = a.application2.AssignLesson.AssignNormal(a.ctx, application2.AssignNormalLessonCommand{
			LessonID:           lessonID,
			StudentID:          studentID,
			PageName:           request.PageName,
			StudentChapterName: request.StudentChapterName,
			TeacherChapterName: request.TeacherChapterName,
		})
	}
	if assignErr != nil {
		return assignErr
	}
	if a.oneNoteClient != nil {
		if strings.TrimSpace(request.StudentChapterName) != "" {
			if sErr := a.oneNoteClient.SaveStudentLastChapter(a.getContext(), studentID, "HS", strings.TrimSpace(request.StudentChapterName)); sErr != nil {
				log.Printf("cảnh báo: không thể lưu last chapter HS: %v", sErr)
			}
		}
		if strings.TrimSpace(request.TeacherChapterName) != "" {
			if tErr := a.oneNoteClient.SaveStudentLastChapter(a.getContext(), studentID, "GV", strings.TrimSpace(request.TeacherChapterName)); tErr != nil {
				log.Printf("cảnh báo: không thể lưu last chapter GV: %v", tErr)
			}
		}
	}
	return nil
}

// ============================================================================
// 11b. PUBLISH PDF LESSON (FULL PIPELINE ĐẨY TRỰC TIẾP LÊN ONENOTE)
// ============================================================================

type PublishPDFLessonRequest struct {
	LessonID           string `json:"lesson_id"`
	StudentID          string `json:"student_id"`
	TeacherPDFPath     string `json:"teacher_pdf_path"`
	StudentPDFPath     string `json:"student_pdf_path"`
	PageName           string `json:"page_name"`
	StudentChapterName string `json:"student_chapter_name"`
	TeacherChapterName string `json:"teacher_chapter_name"`
}

// ResolveLessonPDFPaths xác định đường dẫn thực tế của 2 file PDF Giáo viên & Học sinh.
// Khi teacherPath hoặc studentPath rỗng, hàm sẽ tự động tìm kiếm các file đầu ra chuẩn trong .artifacts/full_pipeline_output.
func ResolveLessonPDFPaths(teacherPath, studentPath string) (string, string) {
	tResolved := teacherPath
	if strings.TrimSpace(tResolved) == "" {
		primaryTeacher := filepath.Join(".artifacts", "full_pipeline_output", "GIAO_AN_GIAO_VIEN.pdf")
		fallbackTeacher := filepath.Join(".artifacts", "full_pipeline_output", "teacher_lesson.pdf")
		if info, err := os.Stat(primaryTeacher); err == nil && !info.IsDir() {
			tResolved = primaryTeacher
		} else {
			tResolved = fallbackTeacher
		}
	}

	sResolved := studentPath
	if strings.TrimSpace(sResolved) == "" {
		primaryStudent := filepath.Join(".artifacts", "full_pipeline_output", "PHIEU_BAI_TAP_HOC_SINH.pdf")
		fallbackStudent := filepath.Join(".artifacts", "full_pipeline_output", "student_lesson.pdf")
		if info, err := os.Stat(primaryStudent); err == nil && !info.IsDir() {
			sResolved = primaryStudent
		} else {
			sResolved = fallbackStudent
		}
	}

	return tResolved, sResolved
}

// RenderLessonPDFBytes biên dịch động một Lesson Entity sang định dạng PDF Bytes bằng Typst.
// Cờ isTeacher quyết định sinh bản in cho Giáo viên (kèm lời giải) hay Học sinh (có chỗ làm bài).
func RenderLessonPDFBytes(ctx context.Context, lsn *lesson.Lesson, isTeacher bool) ([]byte, error) {
	if lsn == nil {
		return nil, errors.New("lesson không được nil")
	}

	renderer := gemini.NewDefaultLessonTypstRenderer()
	typstCode, err := renderer.Render(lsn)
	if err != nil {
		return nil, fmt.Errorf("sinh mã Typst thất bại: %w", err)
	}

	compiler := gemini.NewCLITypstCompiler()
	tmpDir, err := os.MkdirTemp("", "typst_pdf_*")
	if err != nil {
		return nil, fmt.Errorf("tạo thư mục tạm thất bại: %w", err)
	}
	defer func() {
		if rmErr := os.RemoveAll(tmpDir); rmErr != nil {
			log.Printf("cảnh báo: dọn dẹp thư mục tạm %s thất bại: %v", tmpDir, rmErr)
		}
	}()

	outPath := filepath.Join(tmpDir, "rendered.pdf")
	teacherVal := "false"
	if isTeacher {
		teacherVal = "true"
	}

	_, err = compiler.Compile(ctx, typstCode, gemini.CompileOptions{
		IsTeacher:  isTeacher,
		OutPDFPath: outPath,
		Inputs:     map[string]string{"teacher": teacherVal},
	})
	if err != nil {
		return nil, fmt.Errorf("biên dịch Typst PDF thất bại: %w", err)
	}

	pdfBytes, err := os.ReadFile(outPath)
	if err != nil {
		return nil, fmt.Errorf("đọc file PDF thất bại: %w", err)
	}

	return pdfBytes, nil
}

func (a *App) V2PublishPDFLesson(request PublishPDFLessonRequest) error {
	lessonID, err := parseID(request.LessonID, "lesson_id")
	if err != nil {
		return err
	}
	studentID, err := parseID(request.StudentID, "student_id")
	if err != nil {
		return err
	}

	var teacherBytes []byte
	var studentBytes []byte
	var teacherPNGPages [][]byte
	var studentPNGPages [][]byte

	hasTeacherPath := strings.TrimSpace(request.TeacherPDFPath) != ""
	hasStudentPath := strings.TrimSpace(request.StudentPDFPath) != ""

	var lsn *lesson.Lesson
	if a.application2 != nil && a.application2.Lessons != nil {
		foundLesson, getErr := a.application2.Lessons.GetByID(a.getContext(), lessonID)
		if getErr == nil && foundLesson != nil {
			lsn = foundLesson
		} else if getErr != nil {
			log.Printf("không tìm thấy bài học trong Lessons repo: %v", getErr)
		}
	}

	if lsn == nil && a.application2 != nil && a.application2.Drafts != nil {
		draft, draftErr := a.application2.Drafts.GetByID(a.getContext(), lessonID)
		if draftErr == nil && draft != nil && draft.Lesson() != nil {
			lsn = draft.Lesson()
		} else if draftErr != nil {
			log.Printf("không tìm thấy draft hoặc draft chưa hoàn thành: %v", draftErr)
		}
	}

	if hasTeacherPath && hasStudentPath {
		teacherBytes, err = os.ReadFile(request.TeacherPDFPath)
		if err != nil {
			return fmt.Errorf("không thể đọc file PDF Giáo viên %q: %w", request.TeacherPDFPath, err)
		}
		studentBytes, err = os.ReadFile(request.StudentPDFPath)
		if err != nil {
			return fmt.Errorf("không thể đọc file PDF Học sinh %q: %w", request.StudentPDFPath, err)
		}
	} else {
		if lsn != nil {
			// Ưu tiên render các trang ảnh PNG 300 DPI để trang OneNote không bị vỡ/mờ hạt
			tPages, tErr := gemini.RenderLessonPNGPages(a.getContext(), lsn, true, 300)
			sPages, sErr := gemini.RenderLessonPNGPages(a.getContext(), lsn, false, 300)
			if tErr == nil && sErr == nil && len(tPages) > 0 && len(sPages) > 0 {
				teacherPNGPages = tPages
				studentPNGPages = sPages
			} else {
				if tErr != nil {
					log.Printf("cảnh báo: không thể render PNG giáo viên (sẽ fallback PDF): %v", tErr)
				}
				if sErr != nil {
					log.Printf("cảnh báo: không thể render PNG học sinh (sẽ fallback PDF): %v", sErr)
				}
				// Fallback sang PDF
				tBytes, ptErr := RenderLessonPDFBytes(a.getContext(), lsn, true)
				if ptErr != nil {
					log.Printf("lỗi render PDF giáo viên: %v", ptErr)
				}
				sBytes, psErr := RenderLessonPDFBytes(a.getContext(), lsn, false)
				if psErr != nil {
					log.Printf("lỗi render PDF học sinh: %v", psErr)
				}

				if ptErr == nil && psErr == nil && len(tBytes) > 0 && len(sBytes) > 0 {
					teacherBytes = tBytes
					studentBytes = sBytes
				}
			}
		}

		if len(teacherPNGPages) == 0 && (len(teacherBytes) == 0 || len(studentBytes) == 0) {
			teacherPath, studentPath := ResolveLessonPDFPaths(request.TeacherPDFPath, request.StudentPDFPath)
			teacherBytes, err = os.ReadFile(teacherPath)
			if err != nil {
				return fmt.Errorf("không thể đọc file PDF Giáo viên %q: %w", teacherPath, err)
			}
			studentBytes, err = os.ReadFile(studentPath)
			if err != nil {
				return fmt.Errorf("không thể đọc file PDF Học sinh %q: %w", studentPath, err)
			}
		}
	}

	studentName := "Hoc-sinh"
	if a.application2 != nil && a.application2.Queries != nil {
		studentView, qErr := a.application2.Queries.GetStudentDetail(a.getContext(), studentID, application2.MeetingFilter{})
		if qErr != nil {
			log.Printf("cảnh báo: không lấy được thông tin chi tiết học sinh %s: %v, sử dụng tên mặc định", studentID, qErr)
		} else if studentView.Student.Name != "" {
			studentName = studentView.Student.Name
		}
	}

	// 1. Tạo Assignment Entity từ Lesson để quản lý bài tập và kết quả chấm
	var asgn *assignment.Assignment
	if lsn != nil {
		materials := lsn.Materials()
		if len(materials) > 0 {
			if mistakeMat, ok := materials[0].(*lesson.MistakeMaterial); ok {
				asgn, err = assignment.NewRemediationAssignmentFromLesson(studentID, mistakeMat.MistakeID(), request.PageName, *lsn)
			}
		}
		if asgn == nil {
			asgn, err = assignment.NewNormalAssignmentFromLesson(studentID, request.PageName, *lsn)
		}
		if err != nil {
			return fmt.Errorf("không thể tạo assignment entity: %w", err)
		}
	}

	// 2. Lưu Assignment vào bảng assignments của CSDL TRƯỚC TIÊN
	// Bắt buộc phải lưu trước để thỏa mãn Foreign Key constraint của bảng assignment_pages
	// khi Microsoft OneNote tạo trang thành công và lưu liên kết page_id.
	if asgn != nil && a.application2 != nil && a.application2.Assignments != nil {
		if saveErr := a.application2.Assignments.Save(a.getContext(), asgn); saveErr != nil {
			return fmt.Errorf("không thể lưu assignment vào CSDL: %w", saveErr)
		}
	}

	// 3. Target ID liên kết với OneNote Pages là Assignment ID (hoặc fallback lessonID)
	targetID := lessonID
	if asgn != nil {
		targetID = asgn.ID()
	}

	if a.oneNoteClient != nil {
		var publishErr error
		if len(teacherPNGPages) > 0 && len(studentPNGPages) > 0 {
			publishErr = a.oneNoteClient.PublishPNGPages(
				a.getContext(),
				targetID,
				studentID,
				studentName,
				teacherPNGPages,
				studentPNGPages,
				request.StudentChapterName,
				request.TeacherChapterName,
				request.PageName,
			)
		} else {
			publishErr = a.oneNoteClient.PublishPDFPages(
				a.getContext(),
				targetID,
				studentID,
				studentName,
				teacherBytes,
				studentBytes,
				request.StudentChapterName,
				request.TeacherChapterName,
				request.PageName,
			)
		}
		if publishErr != nil {
			return publishErr
		}
		if strings.TrimSpace(request.StudentChapterName) != "" {
			if sErr := a.oneNoteClient.SaveStudentLastChapter(a.getContext(), studentID, "HS", strings.TrimSpace(request.StudentChapterName)); sErr != nil {
				log.Printf("cảnh báo: không thể lưu last chapter HS: %v", sErr)
			}
		}
		if strings.TrimSpace(request.TeacherChapterName) != "" {
			if tErr := a.oneNoteClient.SaveStudentLastChapter(a.getContext(), studentID, "GV", strings.TrimSpace(request.TeacherChapterName)); tErr != nil {
				log.Printf("cảnh báo: không thể lưu last chapter GV: %v", tErr)
			}
		}
	}

	return nil
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
			if _, err := fmt.Fprintf(w, `
				<html>
				<head><meta charset="utf-8"><title>Thành công</title></head>
				<body style="font-family: system-ui, sans-serif; text-align: center; padding: 60px 20px; background: #f8faf9;">
					<div style="max-width: 480px; margin: auto; background: #fff; padding: 30px; border-radius: 12px; border: 1px solid #e2e8f0;">
						<h2 style="color: #15803d; margin-top: 0;">Đăng nhập %s thành công!</h2>
						<p style="color: #64748b;">Bạn có thể đóng tab này và quay lại ứng dụng Desktop.</p>
					</div>
				</body>
				</html>
			`, serviceName); err != nil {
				log.Printf("ghi phản hồi oauth html thất bại: %v", err)
			}

			sendResult(nil)
		}),
	}

	defer func() {
		shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 2*time.Second)
		defer shutdownCancel()
		if err := server.Shutdown(shutdownCtx); err != nil && !errors.Is(err, http.ErrServerClosed) {
			log.Printf("tắt server oauth thất bại: %v", err)
		}
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

// OpenExternalURL mở một đường dẫn ngoài (trang web, OneNote, etc.) trong trình duyệt mặc định của hệ thống
func (a *App) OpenExternalURL(rawURL string) error {
	trimmed := strings.TrimSpace(rawURL)
	if trimmed == "" {
		return errors.New("URL không được để trống")
	}
	return openSystemBrowser(a.getContext(), trimmed)
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
	defer func() {
		if closeErr := file.Close(); closeErr != nil {
			log.Printf("đóng file document thất bại: %v", closeErr)
		}
	}()

	info, err := file.Stat()
	if err != nil {
		http.Error(w, "cannot read document metadata", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/pdf")
	w.Header().Set("Accept-Ranges", "bytes")
	http.ServeContent(w, r, doc.FileName, info.ModTime(), file)
}
