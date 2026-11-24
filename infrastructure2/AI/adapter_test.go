package ai_test

import (
	"context"
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"testing"

	"meet-attendance-clean/application2"
	"meet-attendance-clean/application2/porttest"
	sharekernel "meet-attendance-clean/domain2/kernel"
	"meet-attendance-clean/domain2/lesson"
	ai "meet-attendance-clean/infrastructure2/AI"
)

func makeLoopbackServer(t *testing.T, phaseLog *[]string, mu *sync.Mutex) *httptest.Server {
	t.Helper()
	return httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		bodyBytes, _ := io.ReadAll(r.Body)
		bodyStr := string(bodyBytes)

		var contentJSON string
		switch {
		case strings.Contains(bodyStr, "CHUYÊN GIA BÓC TÁCH") || strings.Contains(bodyStr, "BẢN KIỂM KÊ VÉT CẠN") && strings.Contains(bodyStr, "DOC1_B1_HD1"):
			// Phase 1A Harvester
			if phaseLog != nil {
				mu.Lock()
				*phaseLog = append(*phaseLog, "phase1a_harvester")
				mu.Unlock()
			}
			if !strings.Contains(bodyStr, "data:image/jpeg;base64,") {
				http.Error(w, "missing multimodal image_url", http.StatusBadRequest)
				return
			}
			contentJSON = `{"total_items":2,"items":[{"id":"DOC1_HD1","source_name":"SGK","source_label":"HĐ 1","item_type":"hoat_dong","snippet":"Vectơ lực"},{"id":"DOC1_BT1","source_name":"SGK","source_label":"BT 1","item_type":"bai_tap","snippet":"Độ dài vectơ"}]}`

		case strings.Contains(bodyStr, "BẢN KIỂM KÊ VÉT CẠN gồm"):
			// Phase 1B Curriculum Planner
			if phaseLog != nil {
				mu.Lock()
				*phaseLog = append(*phaseLog, "phase1b_planner")
				mu.Unlock()
			}
			contentJSON = `{"lesson_title":"Vectơ trong không gian","overview":"Tổng hợp dạng toán cơ bản","topics":[{"topic_id":"T1","title":"Định nghĩa vectơ","difficulty":"NhanBiet","target_output":"Nhận diện","core_concept":"Đoạn thẳng có hướng","assigned_question_ids":["DOC1_HD1"]},{"topic_id":"T2","title":"Độ dài vectơ","difficulty":"ThongHieu","target_output":"Tính độ dài","core_concept":"Công thức độ dài","assigned_question_ids":["DOC1_BT1"]}]}`

		case strings.Contains(bodyStr, "DANH SÁCH CÁC MỤC BỊ LỖI CÚ PHÁP"):
			// Phase 3 Repairer
			if phaseLog != nil {
				mu.Lock()
				*phaseLog = append(*phaseLog, "phase3_repairer")
				mu.Unlock()
			}
			contentJSON = `{"repaired_items":[{"target_id":"T1|theory|0","fixed_content":"Vectơ là đoạn thẳng có hướng $\\vec{a}$."}]}`

		default:
			// Phase 2 Parallel Topic Generator
			if phaseLog != nil {
				mu.Lock()
				*phaseLog = append(*phaseLog, "phase2_generator")
				mu.Unlock()
			}
			if strings.Contains(bodyStr, "[T1]") {
				// Return intentionally broken naked \vec{a} to verify Phase 3 RepairMath fires!
				contentJSON = `{"topic_id":"T1","title":"Định nghĩa vectơ","theory_points":["Vectơ là đoạn thẳng có hướng \\vec{a}."],"variants":[{"variant_id":"V1","variant_name":"Nhận diện vectơ","recognition":"Hình chóp","action_steps":["Bước 1: Chọn gốc"],"drills":[{"title":"Bài 1","level":"NhanBiet","prompt":"Tìm vectơ đối của $\\vec{AB}$.","solution":"$-\\vec{AB}$.","answer":"-AB"}]}]}`
			} else {
				contentJSON = `{"topic_id":"T2","title":"Độ dài vectơ","theory_points":["Độ dài $|\\vec{AB}| = AB$."],"variants":[{"variant_id":"V1","variant_name":"Tính độ dài","recognition":"Lập phương","action_steps":["Bước 1: Tính cạnh"],"drills":[{"title":"Bài 2","level":"ThongHieu","prompt":"Tính $|\\vec{AD}|$ cạnh $2$.","solution":"$2$.","answer":"2"}]}]}`
			}
		}

		respPayload, _ := json.Marshal(map[string]any{
			"id": "chatcmpl-e2e",
			"choices": []map[string]any{
				{
					"index":         0,
					"message":       map[string]any{"role": "assistant", "content": contentJSON},
					"finish_reason": "stop",
				},
			},
			"usage": map[string]any{
				"prompt_tokens":          100,
				"completion_tokens":      50,
				"total_tokens":           150,
				"prompt_cache_hit_tokens": 80,
			},
		})
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write(respPayload)
	}))
}

func TestLessonGenerator_PortContract(t *testing.T) {
	porttest.VerifyLessonGeneratorContract(t, func(t *testing.T) (application2.LessonGenerator, []lesson.StudyMaterial) {
		t.Helper()
		ts := makeLoopbackServer(t, nil, nil)
		t.Cleanup(ts.Close)

		tmpDir := t.TempDir()
		pdfPath := filepath.Join(tmpDir, "doc.pdf")
		if err := os.WriteFile(pdfPath, []byte("%PDF-1.4 sample"), 0o644); err != nil {
			t.Fatalf("write pdf: %v", err)
		}
		mat, err := lesson.NewFullPDFMaterial(pdfPath)
		if err != nil {
			t.Fatalf("NewFullPDFMaterial: %v", err)
		}

		gen, err := ai.NewLessonGenerator(
			[]string{"sk-contract-key"},
			ts.URL,
			"deepseek-flash",
			2,
			func(ctx context.Context, data []byte, fileType string, fileName string) ([][]byte, error) {
				return [][]byte{{0xFF, 0xD8, 0xFF, 0xD9}}, nil
			},
		)
		if err != nil {
			t.Fatalf("NewLessonGenerator: %v", err)
		}
		return gen, []lesson.StudyMaterial{mat}
	})
}

func TestLessonGenerator_E2E_FullPipelineLoopback(t *testing.T) {
	var mu sync.Mutex
	var phases []string
	ts := makeLoopbackServer(t, &phases, &mu)
	defer ts.Close()

	tmpDir := t.TempDir()
	pdfPath := filepath.Join(tmpDir, "sgk.pdf")
	if err := os.WriteFile(pdfPath, []byte("%PDF-1.4 sample"), 0o644); err != nil {
		t.Fatalf("write pdf: %v", err)
	}
	mat, err := lesson.NewFullPDFMaterial(pdfPath)
	if err != nil {
		t.Fatalf("NewFullPDFMaterial: %v", err)
	}
	outDir := filepath.Join(tmpDir, "output")

	var mediaConverted bool
	gen, err := ai.NewLessonGenerator(
		[]string{"sk-e2e-1", "sk-e2e-2"},
		ts.URL,
		"deepseek-flash",
		2,
		func(ctx context.Context, data []byte, fileType string, fileName string) ([][]byte, error) {
			mediaConverted = true
			return [][]byte{{0xFF, 0xD8, 0xFF, 0xD9}}, nil
		},
	)
	if err != nil {
		t.Fatalf("NewLessonGenerator failed: %v", err)
	}
	gen.WithOutputDir(outDir)

	lsn, err := gen.Generate(context.Background(), "Fallback", []lesson.StudyMaterial{mat}, "deepseek-flash", "Biên soạn cho học sinh yếu")
	if err != nil {
		t.Fatalf("E2E Generate failed: %v", err)
	}

	if !mediaConverted {
		t.Error("Phase 0 media converter was not invoked")
	}
	if len(phases) < 5 {
		t.Fatalf("expected all phases to execute (>=5 LLM calls), got phases=%v", phases)
	}
	if phases[0] != "phase1a_harvester" || phases[1] != "phase1b_planner" {
		t.Errorf("unexpected phase order start: %v", phases)
	}
	if phases[len(phases)-1] != "phase3_repairer" {
		t.Errorf("expected phase3_repairer after parallel generation, got %v", phases)
	}

	if lsn.Title().String() != "Vectơ trong không gian" {
		t.Errorf("Title = %q, want Vectơ trong không gian", lsn.Title().String())
	}
	topics := lsn.Sections()[0].Topics()
	if len(topics) != 2 {
		t.Fatalf("Topics len = %d, want 2", len(topics))
	}
	firstPara, ok := topics[0].Blocks()[0].(lesson.ParagraphBlock)
	if !ok || !strings.Contains(firstPara.Body().String(), `$`+`\vec{a}`+`$`) {
		t.Errorf("expected Phase 3 repaired math in Topic 1 ParagraphBlock, got %+v", topics[0].Blocks()[0])
	}
	if len(lsn.Exercises()) != 2 {
		t.Errorf("Exercises len = %d, want 2", len(lsn.Exercises()))
	}

	for _, rel := range []string{"raw_data/plan_output.json", "raw_data/topics_content.json", "raw_data/lesson.typ"} {
		if _, errStat := os.Stat(filepath.Join(outDir, rel)); errStat != nil {
			t.Errorf("expected artifact %s: %v", rel, errStat)
		}
	}
}

func TestDualLessonGenerator_RoutingAndErrors(t *testing.T) {
	mkLesson := func(title string) *lesson.Lesson {
		mat, _ := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=12345")
		tTitle := sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: "Topic"})
		top, _ := lesson.NewTopic(tTitle, nil, nil)
		sec, _ := lesson.NewSection(tTitle, []lesson.Topic{top})
		lTitle := sharekernel.NewContent(sharekernel.InlinePart{Type: sharekernel.InlineText, Value: title})
		lsn, _ := lesson.NewLesson(lTitle, lTitle, []lesson.Section{sec}, []lesson.StudyMaterial{mat})
		return lsn
	}

	mat, _ := lesson.NewYouTubeMaterial("https://youtube.com/watch?v=12345")
	materials := []lesson.StudyMaterial{mat}

	router := ai.NewDualLessonGenerator(
		func(ctx context.Context, title string, mats []lesson.StudyMaterial, model, prompt string) (*lesson.Lesson, error) {
			return mkLesson("Gemini: " + model), nil
		},
		func(ctx context.Context, title string, mats []lesson.StudyMaterial, model, prompt string) (*lesson.Lesson, error) {
			return mkLesson("DeepSeek: " + model), nil
		},
	)

	resDS, err := router.Generate(context.Background(), "T", materials, "deepseek-flash", "")
	if err != nil || resDS.Title().String() != "DeepSeek: deepseek-flash" {
		t.Errorf("DeepSeek route failed: res=%v err=%v", resDS, err)
	}
	resGem, err := router.Generate(context.Background(), "T", materials, "gemini-3.8-flash", "")
	if err != nil || resGem.Title().String() != "Gemini: gemini-3.8-flash" {
		t.Errorf("Gemini route failed: res=%v err=%v", resGem, err)
	}
	resDef, err := router.Generate(context.Background(), "T", materials, "", "")
	if err != nil || resDef.Title().String() != "Gemini: " {
		t.Errorf("Default route failed: res=%v err=%v", resDef, err)
	}

	noDS := ai.NewDualLessonGenerator(func(context.Context, string, []lesson.StudyMaterial, string, string) (*lesson.Lesson, error) {
		return mkLesson("Gem"), nil
	}, nil)
	if _, err := noDS.Generate(context.Background(), "T", materials, "deepseek-flash", ""); err == nil {
		t.Fatal("expected error when deepseekFn is nil")
	}

	noGem := ai.NewDualLessonGenerator(nil, func(context.Context, string, []lesson.StudyMaterial, string, string) (*lesson.Lesson, error) {
		return mkLesson("DS"), nil
	})
	if _, err := noGem.Generate(context.Background(), "T", materials, "gemini-3.8-flash", ""); err == nil {
		t.Fatal("expected error when geminiFn is nil")
	}

	wantErr := errors.New("boom")
	errRouter := ai.NewDualLessonGenerator(
		func(context.Context, string, []lesson.StudyMaterial, string, string) (*lesson.Lesson, error) {
			return nil, wantErr
		},
		func(context.Context, string, []lesson.StudyMaterial, string, string) (*lesson.Lesson, error) {
			return nil, wantErr
		},
	)
	if _, err := errRouter.Generate(context.Background(), "T", materials, "deepseek-flash", ""); !errors.Is(err, wantErr) {
		t.Errorf("expected propagated error %v, got %v", wantErr, err)
	}
}
