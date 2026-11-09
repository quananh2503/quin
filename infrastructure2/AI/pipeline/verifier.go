package pipeline

import (
	"context"
	"meet-attendance-clean/infrastructure2/AI"
)

// DefaultVerifier triển khai Verifier interface (thay thế cho verifycobithieuko.go).
// Nhiệm vụ: Rà soát, kiểm định xem có câu hỏi, dạng toán hoặc yêu cầu nào từ userPrompt
// và tài liệu gốc bị bỏ sót không.
type DefaultVerifier struct {
	provider ai.Provider
	model    string
}

// NewVerifier khởi tạo DefaultVerifier.
func NewVerifier(provider ai.Provider, model string) *DefaultVerifier {
	return &DefaultVerifier{
		provider: provider,
		model:    model,
	}
}

// VerifyPlan đối chiếu danh mục câu hỏi đã chia dạng so với tài liệu đầu vào và userPrompt để phát hiện câu sót.
// Stub rỗng chờ duyệt pattern.
func (v *DefaultVerifier) VerifyPlan(ctx context.Context, plan *LessonPlan, docs []ai.Document, userPrompt string) (*AuditReport, error) {
	// TODO: Sau khi được duyệt, sẽ rà soát QuestionCatalog và AssignedQuestionIDs để tìm unassigned questions
	// và kiểm tra các yêu cầu đặc thù trong userPrompt đã được đáp ứng chưa.
	return nil, nil
}

// VerifyContent kiểm tra chất lượng và độ đầy đủ của từng dạng toán sau khi biên soạn.
// Stub rỗng chờ duyệt pattern.
func (v *DefaultVerifier) VerifyContent(ctx context.Context, contents []TopicContent, plan *LessonPlan, userPrompt string) (*AuditReport, error) {
	// TODO: Sau khi được duyệt, sẽ kiểm tra số lượng ví dụ, bài tập rèn luyện theo đúng chuẩn sư phạm.
	return nil, nil
}
