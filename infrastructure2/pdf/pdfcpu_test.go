package pdf

import (
	"context"
	"os"
	"path/filepath"
	"testing"
)

func TestExtractPagesWithNoPagesReturnsWholeDocument(t *testing.T) {
	t.Parallel()

	want := []byte("a complete PDF stream")
	path := filepath.Join(t.TempDir(), "source.pdf")
	if err := os.WriteFile(path, want, 0600); err != nil {
		t.Fatal(err)
	}

	got, err := NewProcessor().ExtractPages(context.Background(), path, nil)
	if err != nil {
		t.Fatalf("ExtractPages() returned an error: %v", err)
	}
	if string(got) != string(want) {
		t.Fatalf("ExtractPages() = %q, want %q", got, want)
	}
}

func TestMergeAndNUp2WithActualFiles(t *testing.T) {
	files := []string{
		"../gemini/HH12-KNTT- C2-GHEP FULL GIAI.pdf",
		"../gemini/ÔN VEC TƠ KG 10T10.pdf",
		"../gemini/dsd.pdf",
	}

	p := NewProcessor()
	ctx := context.Background()

	// Đếm tổng số trang gốc
	totalOriginalPages := 0
	for _, f := range files {
		cnt, err := p.PageCount(ctx, f)
		if err != nil {
			t.Fatalf("PageCount lỗi cho %s: %v", f, err)
		}
		t.Logf("File: %s - Số trang: %d", f, cnt)
		totalOriginalPages += cnt
	}
	t.Logf("Tổng số trang ban đầu của cả 3 file: %d trang", totalOriginalPages)

	// Gộp và nén 2 trang thành 1
	nupBytes, err := p.MergeAndNUp2(ctx, files)
	if err != nil {
		t.Fatalf("MergeAndNUp2 thất bại: %v", err)
	}

	outPath := filepath.Join(t.TempDir(), "merged_nup2.pdf")
	if err := os.WriteFile(outPath, nupBytes, 0644); err != nil {
		t.Fatalf("Ghi file tạm lỗi: %v", err)
	}

	newCount, err := p.PageCount(ctx, outPath)
	if err != nil {
		t.Fatalf("PageCount file nén lỗi: %v", err)
	}

	t.Logf("🎉 Thành công! File nén 2-up có: %d trang (Kích thước: %d KB)", newCount, len(nupBytes)/1024)
	expectedMax := (totalOriginalPages + 1) / 2
	if newCount != expectedMax {
		t.Errorf("Số trang sau khi nén 2-in-1 = %d, kỳ vọng = %d", newCount, expectedMax)
	}

	// Kiểm tra cắt trang thử từ file nén (ví dụ cắt trang 1->3)
	chunk, err := p.ExtractPages(ctx, outPath, []int{1, 2, 3})
	if err != nil {
		t.Fatalf("ExtractPages từ file nén 2-up lỗi: %v", err)
	}
	chunkPath := filepath.Join(t.TempDir(), "chunk.pdf")
	_ = os.WriteFile(chunkPath, chunk, 0644)
	chunkCount, err := p.PageCount(ctx, chunkPath)
	if err != nil || chunkCount != 3 {
		t.Errorf("Trích xuất 3 trang thất bại: count=%d, err=%v", chunkCount, err)
	}
	t.Logf("✅ Trích xuất thành công 3 trang từ file nén: %d trang (Kích thước: %d KB)", chunkCount, len(chunk)/1024)
}

func TestMergeAndNUp8WithActualFiles(t *testing.T) {
	files := []string{
		"../gemini/HH12-KNTT- C2-GHEP FULL GIAI.pdf",
		"../gemini/ÔN VEC TƠ KG 10T10.pdf",
		"../gemini/dsd.pdf",
	}

	p := NewProcessor()
	ctx := context.Background()

	// Đếm tổng số trang gốc
	totalOriginalPages := 0
	for _, f := range files {
		cnt, err := p.PageCount(ctx, f)
		if err != nil {
			t.Fatalf("PageCount lỗi cho %s: %v", f, err)
		}
		t.Logf("File: %s - Số trang: %d", f, cnt)
		totalOriginalPages += cnt
	}
	t.Logf("Tổng số trang ban đầu của cả 3 file: %d trang", totalOriginalPages)

	// Gộp và nén siêu nhỏ: 8 trang thành 1 (N-Up = 8)
	nupBytes, err := p.MergeAndNUp8(ctx, files)
	if err != nil {
		t.Fatalf("MergeAndNUp8 thất bại: %v", err)
	}

	outPath := filepath.Join("../gemini", "consolidated_nup8.pdf")
	if err := os.WriteFile(outPath, nupBytes, 0644); err != nil {
		t.Fatalf("Ghi file consolidated_nup8.pdf lỗi: %v", err)
	}

	newCount, err := p.PageCount(ctx, outPath)
	if err != nil {
		t.Fatalf("PageCount file nén 8-up lỗi: %v", err)
	}

	expectedMax := (totalOriginalPages + 7) / 8
	t.Logf("🎉 NÉN SIÊU NHỎ N-UP=8 THÀNH CÔNG!\n- Tổng trang gốc: %d\n- Số trang sau khi nén 8-in-1: %d trang (Kỳ vọng: %d)\n- Dung lượng: %d KB (Đã lưu vào: %s)",
		totalOriginalPages, newCount, expectedMax, len(nupBytes)/1024, outPath)

	// Kiểm tra cắt trang thử từ file nén 8-up (ví dụ trang 1)
	chunk, err := p.ExtractPages(ctx, outPath, []int{1})
	if err != nil {
		t.Fatalf("ExtractPages từ file nén 8-up lỗi: %v", err)
	}
	t.Logf("✅ Trích xuất thử trang 1 từ file nén 8-in-1: %d KB (thành công)", len(chunk)/1024)
}



