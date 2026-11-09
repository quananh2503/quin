package pipeline

import (
	"context"
	"meet-attendance-clean/domain2/document"
	"meet-attendance-clean/domain2/lesson"
	"meet-attendance-clean/infrastructure2/AI"
)

// =============================================================================
// CONTRACT INTERFACES: PHÂN TÁCH TRÁCH NHIỆM TỪNG GIAI ĐOẠN (STAGES)
// Phục vụ Mock 100% khi Unit Test mà không cần gọi API thật hoặc tiêu tốn token.
// =============================================================================

// Preprocessor đại diện cho Bước tiền xử lý: Chuyển đổi domain2.document sang ai.Document qua media.Converter.
type Preprocessor interface {
	Preprocess(ctx context.Context, doc *document.SourceDocument) (ai.Document, error)
	PreprocessBatch(ctx context.Context, docs []*document.SourceDocument) ([]ai.Document, error)
}

// Harvester đại diện cho Bước 1A: Bóc tách vét cạn mọi câu hỏi, bài tập, hoạt động từ tài liệu nguồn thành DocumentInventory.
type Harvester interface {
	Harvest(ctx context.Context, docs []ai.Document) (*DocumentInventory, *ai.Response, error)
}

// Planner đại diện cho Stage 1: Phân tích tài liệu nguồn và chia nhỏ thành các dạng toán ("chiaracacdoancon.go").
// userPrompt là bộ chỉ dẫn tùy biến của người dùng (style, phong cách giảng dạy, yêu cầu trọng tâm...).
// Trả về cả *ai.Response để caller có toàn bộ thông tin token, cache và raw output ngay cả khi unmarshal lỗi.
type Planner interface {
	Plan(ctx context.Context, docs []ai.Document, userPrompt string) (*LessonPlan, *ai.Response, error)
}

// Generator đại diện cho Stage 2: Biên soạn nội dung chi tiết cho từng dạng toán ("generatetungdang.go").
// Áp dụng userPrompt vào từng dạng để đồng nhất phong cách giảng dạy.
type Generator interface {
	// GenerateTopic biên soạn 1 dạng toán đơn lẻ theo chỉ dẫn của người dùng.
	GenerateTopic(ctx context.Context, topic TopicPlan, docs []ai.Document, globalPlan *LessonPlan, userPrompt string) (*TopicContent, error)

	// GenerateAll biên soạn toàn bộ các dạng toán trong kế hoạch (hỗ trợ worker pool chạy song song).
	GenerateAll(ctx context.Context, plan *LessonPlan, docs []ai.Document, userPrompt string, maxWorkers int) ([]TopicContent, error)
}

// Verifier đại diện cho Stage 2.5: Kiểm định độ bao phủ và rà soát câu hỏi/dạng toán bị thiếu ("verifycobithieuko.go").
type Verifier interface {
	// VerifyPlan kiểm tra kế hoạch ban đầu so với tài liệu đầu vào và chỉ dẫn người dùng để phát hiện câu sót.
	VerifyPlan(ctx context.Context, plan *LessonPlan, docs []ai.Document, userPrompt string) (*AuditReport, error)

	// VerifyContent kiểm tra nội dung sau khi biên soạn xem có thiếu ý lý thuyết hay bài tập nào không.
	VerifyContent(ctx context.Context, contents []TopicContent, plan *LessonPlan, userPrompt string) (*AuditReport, error)
}

// Repairer đại diện cho Stage 3: Phát hiện và sửa lỗi cú pháp LaTeX/Typst hoặc JSON ("sualoi.go").
type Repairer interface {
	// RepairMath sửa các lỗi cú pháp công thức toán hoặc dấu dollar bị thiếu.
	RepairMath(ctx context.Context, tasks []RepairTask) ([]RepairTask, error)

	// RepairSyntax sửa lại nội dung tài liệu khi gặp lỗi biên dịch.
	RepairSyntax(ctx context.Context, rawContent string, syntaxErrors []string) (string, error)
}

// Assembler đại diện cho Stage 4: Ghép nối các dạng toán thành Lesson Domain Entity và mã dàn trang ("gheplai.go").
type Assembler interface {
	// AssembleToLesson chuyển đổi LessonPlan và các TopicContent thành Lesson Aggregate Root của domain.
	AssembleToLesson(plan *LessonPlan, contents []TopicContent, materials []lesson.StudyMaterial) (*lesson.Lesson, error)

	// AssembleToTypst tạo mã nguồn tài liệu Typst cho bản Giáo viên và Học sinh.
	AssembleToTypst(plan *LessonPlan, contents []TopicContent) (teacherTypst string, studentTypst string, err error)
}

// Orchestrator đại diện cho Bộ điều phối tổng thể kết nối các Stage tuần tự ("tonghop.go").
type Orchestrator interface {
	Execute(ctx context.Context, req PipelineRequest) (*PipelineResult, error)
}
