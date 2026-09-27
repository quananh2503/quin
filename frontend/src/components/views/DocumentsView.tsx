import React, {
  useState,
  useEffect,
  useCallback,
  useMemo,
  useRef,
} from 'react';

import { Document, Page, pdfjs } from 'react-pdf';

import { api } from '../../api';
import { normalizeError } from '../../utils';
import { V2CreateLessonFromPDF } from '../../../wailsjs/go/wails/App';
import { wails  } from '../../../wailsjs/go/models';

import {
  FileUp,
  BookOpen,
  ZoomIn,
  ZoomOut,
  RotateCcw,
  CheckCircle2,
  Circle,
  ArrowLeft,
  Sparkles,
  Loader2,
  Calendar,
  Layers,
} from 'lucide-react';

import 'react-pdf/dist/Page/AnnotationLayer.css';
import 'react-pdf/dist/Page/TextLayer.css';

// Worker chạy offline local 100%
import PDFWorker from 'pdfjs-dist/build/pdf.worker.min.mjs?worker';

pdfjs.GlobalWorkerOptions.workerPort = new PDFWorker();

interface DocumentsViewProps {
  onNavigateLessons: () => void;
  showToast: (msg: string, isError?: boolean) => void;
}

// ============================================================================
// PDF CONFIG
// ============================================================================

const PDF_BASE_WIDTH = 640;
const PDF_RATIO = 1.414;

// Khoảng trống trên + dưới mỗi page.
// Tương đương my-6 cũ: 24px + 24px.
const PAGE_VERTICAL_GAP = 48;

// Chỉ giữ page hiện tại +/- 2 trang.
// Tổng cộng tối đa khoảng 5 canvas PDF trong WebKit.
const PAGE_OVERSCAN = 2;

// ============================================================================
// COMPONENT: Từng trang PDF
// QUAN TRỌNG:
// Component này chỉ tồn tại nếu page nằm trong virtual window.
// Khi ra khỏi window => unmount hoàn toàn => canvas được giải phóng.
// ============================================================================

interface VirtualPDFPageProps {
  pageNumber: number;
  scale: number;
  isSelected: boolean;
  onToggle: (page: number) => void;
}
const VirtualPDFPage = React.memo(
  ({
    pageNumber,
    scale,
    isSelected,
    onToggle,
  }: VirtualPDFPageProps) => {
    const pageWidth = Math.round(PDF_BASE_WIDTH * scale);
    const pageHeight = Math.round(pageWidth * PDF_RATIO);

    // CHỐNG TRÀN RAM
    const [isReadyToDraw, setIsReadyToDraw] = useState(false);
    const pageContainerRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
      const timer = setTimeout(() => setIsReadyToDraw(true), 150);

      return () => {
        clearTimeout(timer);

        if (pageContainerRef.current) {
          const canvas =
            pageContainerRef.current.querySelector('canvas');

          if (canvas) {
            const context = canvas.getContext('2d');
            context?.clearRect(0, 0, canvas.width, canvas.height);
            canvas.width = 0;
            canvas.height = 0;
          }
        }
      };
    }, []);

    return (
      <div
        ref={pageContainerRef}
        id={`page-node-${pageNumber}`}
        style={{
          width: `${pageWidth}px`,
          height: `${pageHeight}px`,
          contain: 'layout paint size',
        }}
        className={`relative rounded-xl select-none bg-white flex items-center justify-center overflow-hidden ${
          isSelected
            ? 'ring-4 ring-emerald-500 shadow-lg'
            : 'shadow-md border border-slate-200'
        }`}
      >
        {/* Chọn trang */}
        <button
          type="button"
          onClick={(e) => {
            e.stopPropagation();
            onToggle(pageNumber);
          }}
          className={`absolute top-4 right-4 z-20 flex items-center gap-2 px-3.5 py-1.5 rounded-full text-xs font-bold transition shadow-md cursor-pointer ${
            isSelected
              ? 'bg-emerald-600 text-white hover:bg-emerald-500'
              : 'bg-white hover:bg-slate-50 text-slate-700 border border-slate-200'
          }`}
        >
          {isSelected ? (
            <CheckCircle2 size={16} />
          ) : (
            <Circle size={16} className="text-slate-400" />
          )}
          <span>
            {isSelected
              ? `Trang ${pageNumber} (Đã chọn)`
              : `Chọn trang ${pageNumber}`}
          </span>
        </button>

        {/* Số trang */}
        <div className="absolute top-4 left-4 z-20 bg-white px-3.5 py-1.5 rounded-lg text-xs font-mono font-black text-slate-700 border border-slate-300 shadow-md flex items-center gap-1">
          <span className="text-emerald-600 font-bold">Trang</span>
          {pageNumber}
        </div>

        {/* PDF page */}
        <div className="w-full h-full flex justify-center items-center overflow-hidden">
          {isReadyToDraw ? (
            <Page
              pageNumber={pageNumber}
              width={pageWidth}
              renderTextLayer={false}
              renderAnnotationLayer={false}
              devicePixelRatio={1}
              loading={
                <div className="w-full h-full bg-slate-50 flex flex-col items-center justify-center text-slate-400 gap-2 font-mono text-xs">
                  <Loader2
                    size={24}
                    className="animate-spin text-emerald-500"
                  />
                  <span>Đang nạp trang {pageNumber}...</span>
                </div>
              }
            />
          ) : (
            <div className="w-full h-full bg-slate-50 flex flex-col items-center justify-center text-slate-300 font-mono text-xs">
              <span>Đang lướt qua...</span>
            </div>
          )}
        </div>
      </div>
    );
  },
  (prev, next) => {
    return (
      prev.pageNumber === next.pageNumber &&
      prev.scale === next.scale &&
      prev.isSelected === next.isSelected &&
      prev.onToggle === next.onToggle
    );
  },
);

VirtualPDFPage.displayName = 'VirtualPDFPage';
// ============================================================================
// MAIN COMPONENT
// ============================================================================

export const DocumentsView: React.FC<DocumentsViewProps> = ({
  onNavigateLessons,
  showToast,
}) => {
  const [documents, setDocuments] = useState<any[]>([]);
  const [currentDoc, setCurrentDoc] = useState<any>(null);

  const [numPages, setNumPages] = useState<number>(0);
  const [activePage, setActivePage] = useState<number>(1);

  const [scale, setScale] = useState<number>(1.2);

  const [selectedPages, setSelectedPages] = useState<Set<number>>(
    new Set(),
  );

  // Form
  const [uploading, setUploading] = useState(false);
  const [creating, setCreating] = useState(false);

  const [title, setTitle] = useState('');
  const [prompt, setPrompt] = useState('');

  const [selectedModel, setSelectedModel] = useState(
    'gemini-3.7-flash',
  );
  const [models, setModels] = useState<any[]>([]);
  const promptRef = useRef<HTMLTextAreaElement>(null);

  // Scroll container
  const scrollContainerRef = useRef<HTMLDivElement>(null);
  const pdfDocRef = useRef<any>(null);

  const pdfOptions = useMemo(
    () => ({
      disableAutoFetch: true,
      disableStream: true,
    }),
    [],
  );

  // requestAnimationFrame dùng throttle scroll.
  const scrollRAFRef = useRef<number | null>(null);

  // ==========================================================================
  // PAGE DIMENSIONS
  // ==========================================================================

  const pageWidth = useMemo(() => {
    return Math.round(PDF_BASE_WIDTH * scale);
  }, [scale]);

  const pageHeight = useMemo(() => {
    return Math.round(pageWidth * PDF_RATIO);
  }, [pageWidth]);

  const itemHeight = pageHeight + PAGE_VERTICAL_GAP;

  // ==========================================================================
  // VIRTUAL WINDOW
  // ==========================================================================

  const virtualRange = useMemo(() => {
    if (numPages <= 0) {
      return {
        start: 1,
        end: 0,
      };
    }

    const start = Math.max(
      1,
      activePage - PAGE_OVERSCAN,
    );

    const end = Math.min(
      numPages,
      activePage + PAGE_OVERSCAN,
    );

    return {
      start,
      end,
    };
  }, [activePage, numPages]);

  const visiblePages = useMemo(() => {
    const pages: number[] = [];

    for (
      let page = virtualRange.start;
      page <= virtualRange.end;
      page++
    ) {
      pages.push(page);
    }

    return pages;
  }, [virtualRange]);

  // Những trang không render phía trên được thay bằng spacer.
  const topSpacerHeight =
    Math.max(0, virtualRange.start - 1) * itemHeight;

  // Những trang không render phía dưới.
  const bottomSpacerHeight =
    Math.max(0, numPages - virtualRange.end) * itemHeight;

  // ==========================================================================
  // LOAD DOCUMENTS
  // ==========================================================================

  const loadDocuments = async () => {
    try {
      const res = await api.listDocuments();

      setDocuments(res || []);
    } catch (err) {
      showToast(
        'Lỗi tải tài liệu: ' + normalizeError(err),
        true,
      );
    }
  };

  useEffect(() => {
    loadDocuments();

    api.listAIModels()
      .then((result: any[]) => {
        const availableModels = result || [];
        setModels(availableModels);
        if (availableModels.length > 0 && !availableModels.some((model: any) => model.id === selectedModel)) {
          setSelectedModel(availableModels[0].id);
        }
      })
      .catch(() => {
        setModels([]);
      });
  }, []);

  useEffect(() => {
    if (
      pdfDocRef.current &&
      typeof pdfDocRef.current.cleanup === 'function'
    ) {
      pdfDocRef.current.cleanup();
    }
  }, [activePage]);

  // Cleanup RAF khi component bị unmount.
  useEffect(() => {
    return () => {
      if (scrollRAFRef.current !== null) {
        cancelAnimationFrame(scrollRAFRef.current);
      }
    };
  }, []);

  // ==========================================================================
  // UPLOAD
  // ==========================================================================

  const handleUpload = async () => {
    setUploading(true);

    try {
      const doc = await api.uploadDocument();

      if (!doc) {
        return;
      }

      showToast(`Đã tải lên: ${doc.file_name}`);

      await loadDocuments();

      await handleSelectDocument(doc.id);
    } catch (err) {
      if (
        !String(normalizeError(err)).includes('chưa chọn')
      ) {
        showToast(
          'Lỗi tải lên: ' + normalizeError(err),
          true,
        );
      }
    } finally {
      setUploading(false);
    }
  };

  // ==========================================================================
  // SELECT DOCUMENT
  // ==========================================================================

  const handleSelectDocument = async (id: string) => {
    try {
      const doc = await api.getDocument(String(id));

      setCurrentDoc(doc);

      setNumPages(0);
      setSelectedPages(new Set());

      setActivePage(1);
      setScale(1.2);

      setTitle(
        doc.file_name.replace(/\.[^/.]+$/, ''),
      );

      setPrompt('');
      if (promptRef.current) {
        promptRef.current.value = '';
      }

      // Reset scroll.
      requestAnimationFrame(() => {
        if (scrollContainerRef.current) {
          scrollContainerRef.current.scrollTop = 0;
        }
      });
    } catch (err) {
      showToast(
        'Không thể mở tài liệu: ' +
          normalizeError(err),
        true,
      );
    }
  };

  // ==========================================================================
  // SELECT PAGE
  // ==========================================================================

  const togglePage = useCallback((p: number) => {
    setSelectedPages((prev) => {
      const next = new Set(prev);

      if (next.has(p)) {
        next.delete(p);
      } else {
        next.add(p);
      }

      return next;
    });
  }, []);

  // ==========================================================================
  // SCROLL TO PAGE
  // Không còn document.getElementById() vì target page có thể chưa mounted.
  // Scroll trực tiếp bằng virtual offset.
  // ==========================================================================

  const scrollToPage = useCallback(
    (page: number) => {
      if (!scrollContainerRef.current) {
        return;
      }

      const targetPage = Math.max(
        1,
        Math.min(page, numPages),
      );

      setActivePage(targetPage);

      const top =
        (targetPage - 1) * itemHeight;

      scrollContainerRef.current.scrollTo({
        top,
        behavior: 'smooth',
      });
    },
    [itemHeight, numPages],
  );

  // ==========================================================================
  // CREATE LESSON
  // ==========================================================================

  const handleCreateFromPDF = async () => {
    if (
      !currentDoc ||
      selectedPages.size === 0
    ) {
      return;
    }

    setCreating(true);

    try {
      const request = new wails.GenerateLessonRequest({
        material: 'pdf',
        document_id: String(currentDoc.id),
        pages: Array.from(selectedPages).sort(
          (a, b) => a - b,
        ),
        title:
          title.trim() ||
          currentDoc.file_name.replace(
            /\.[^/.]+$/,
            '',
          ),
        model: selectedModel,
        prompt: prompt.trim(),
      });
      request.url = '';
      await V2CreateLessonFromPDF(request);

      showToast(
        `Đã gửi ${selectedPages.size} trang tài liệu cho AI xử lý`,
      );

      onNavigateLessons();
    } catch (err) {
      showToast(
        'Lỗi tạo bài: ' +
          normalizeError(err),
        true,
      );
    } finally {
      setCreating(false);
    }
  };

  // ==========================================================================
  // SCROLL HANDLER
  // Dùng RAF để không setState hàng trăm lần / giây.
  // ==========================================================================

  const handleScroll = useCallback(
    (
      e: React.UIEvent<HTMLDivElement>,
    ) => {
      const target = e.currentTarget;

      const scrollTop = target.scrollTop;
      const clientHeight = target.clientHeight;

      if (scrollRAFRef.current !== null) {
        cancelAnimationFrame(
          scrollRAFRef.current,
        );
      }

      scrollRAFRef.current =
        requestAnimationFrame(() => {
          const centerScroll =
            scrollTop + clientHeight / 2;

          let page =
            Math.floor(
              centerScroll / itemHeight,
            ) + 1;

          page = Math.max(1, page);

          if (numPages > 0) {
            page = Math.min(
              page,
              numPages,
            );
          }

          setActivePage((previous) => {
            if (previous === page) {
              return previous;
            }

            return page;
          });
        });
    },
    [itemHeight, numPages],
  );

  // ==========================================================================
  // ZOOM
  // Giữ nguyên vị trí page hiện tại sau khi zoom.
  // ==========================================================================

  const changeScale = useCallback(
    (nextScale: number) => {
      const clampedScale = Math.max(
        0.6,
        Math.min(2.5, nextScale),
      );

      const currentPage = activePage;

      setScale(clampedScale);

      // Chờ React cập nhật dimensions.
      requestAnimationFrame(() => {
        requestAnimationFrame(() => {
          const container =
            scrollContainerRef.current;

          if (!container) {
            return;
          }

          const nextWidth = Math.round(
            PDF_BASE_WIDTH *
              clampedScale,
          );

          const nextHeight = Math.round(
            nextWidth * PDF_RATIO,
          );

          const nextItemHeight =
            nextHeight +
            PAGE_VERTICAL_GAP;

          container.scrollTop =
            (currentPage - 1) *
            nextItemHeight;
        });
      });
    },
    [activePage],
  );

  // ==========================================================================
  // VIEW 1: DOCUMENT LIST
  // ==========================================================================

  if (!currentDoc) {
    return (
      <div className="p-8 space-y-6 max-w-6xl mx-auto">
        <div className="flex justify-between items-center">
          <div>
            <span className="text-xs font-bold text-emerald-600 uppercase tracking-wider">
              Kho Giáo Trình
            </span>

            <h1 className="text-2xl font-black text-slate-800 tracking-tight">
              Tài liệu PDF & Sách Giáo Khoa
            </h1>

            <p className="text-sm text-slate-500 mt-1">
              Lướt xem tài liệu, chọn trang
              bài tập và tạo giáo án bằng AI
            </p>
          </div>

          <button
            onClick={handleUpload}
            disabled={uploading}
            className="flex items-center gap-2 px-5 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-sm font-bold shadow-sm transition disabled:opacity-50 cursor-pointer"
          >
            <FileUp size={18} />

            {uploading
              ? 'Đang xử lý...'
              : 'Chọn tài liệu mới'}
          </button>
        </div>

        <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 space-y-4">
          <div className="flex justify-between items-center pb-3 border-b border-slate-100">
            <h3 className="font-bold text-slate-800 text-sm flex items-center gap-2">
              <BookOpen
                size={18}
                className="text-emerald-600"
              />

              Tài liệu đã lưu trên máy (
              {documents.length})
            </h3>
          </div>

          {documents.length === 0 ? (
            <div className="py-16 text-center text-slate-400 space-y-3">
              <BookOpen
                size={48}
                className="mx-auto text-slate-200 stroke-[1.5]"
              />

              <p className="text-sm">
                Chưa có tài liệu nào. Hãy
                bấm "Chọn tài liệu mới" để
                bắt đầu.
              </p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {documents.map((doc) => (
                <div
                  key={doc.id}
                  onClick={() =>
                    handleSelectDocument(
                      doc.id,
                    )
                  }
                  className="p-5 border border-slate-200 hover:border-emerald-500 rounded-xl hover:shadow-md cursor-pointer transition flex items-center justify-between group bg-slate-50/50 hover:bg-white"
                >
                  <div className="space-y-1.5 overflow-hidden pr-3">
                    <strong className="text-slate-800 text-sm block truncate group-hover:text-emerald-600 transition">
                      {doc.file_name}
                    </strong>

                    <div className="flex items-center gap-3 text-xs text-slate-500">
                      <span className="flex items-center gap-1">
                        <Layers size={13} />
                        {doc.page_count} trang
                      </span>

                      {doc.created_at && (
                        <span className="flex items-center gap-1">
                          <Calendar
                            size={13}
                          />

                          {new Date(
                            doc.created_at,
                          ).toLocaleDateString(
                            'vi-VN',
                          )}
                        </span>
                      )}
                    </div>
                  </div>

                  <button className="px-3.5 py-1.5 bg-emerald-50 text-emerald-700 group-hover:bg-emerald-600 group-hover:text-white rounded-lg text-xs font-bold transition whitespace-nowrap">
                    Mở đọc & lướt
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    );
  }

  // ==========================================================================
  // VIEW 2: PDF VIEWER
  // ==========================================================================

  return (
    <div className="flex flex-col h-full w-full bg-slate-100/60 text-slate-800 select-none overflow-hidden">
      {/* HEADER */}
      <div className="h-16 bg-white border-b border-slate-200 px-6 flex items-center justify-between z-30 shadow-sm shrink-0">
        {/* LEFT */}
        <div className="flex items-center gap-3">
          <button
            onClick={() => {
              setCurrentDoc(null);
              setNumPages(0);
            }}
            className="flex items-center gap-2 px-3.5 py-2 rounded-xl bg-slate-100 hover:bg-slate-200 text-xs font-bold text-slate-700 hover:text-slate-900 border border-slate-200 shadow-sm transition cursor-pointer"
          >
            <ArrowLeft
              size={16}
              className="text-slate-600"
            />

            Danh sách
          </button>

          <span className="text-slate-300">
            |
          </span>

          <span className="text-sm font-black text-slate-800 truncate max-w-sm sm:max-w-md">
            {currentDoc.file_name}
          </span>
        </div>

        {/* ACTIVE PAGE */}
        <div className="bg-slate-50 px-4 py-1.5 rounded-full border border-slate-200 text-xs font-mono shadow-inner flex items-center gap-1.5">
          <span className="text-slate-500 font-medium">
            Đang lướt:
          </span>

          <span className="text-emerald-600 font-extrabold text-sm">
            {activePage}
          </span>

          <span className="text-slate-400">
            /{' '}
            {numPages ||
              currentDoc.page_count}
          </span>
        </div>

        {/* ZOOM */}
        <div className="flex items-center gap-1.5 bg-slate-50 p-1 rounded-xl border border-slate-200 shadow-inner">
          <button
            onClick={() =>
              changeScale(scale - 0.15)
            }
            className="p-1.5 hover:bg-white rounded-lg text-slate-600 hover:text-slate-900 hover:shadow-sm transition cursor-pointer"
            title="Thu nhỏ"
          >
            <ZoomOut size={16} />
          </button>

          <span className="font-mono font-bold text-xs text-emerald-600 w-12 text-center select-none">
            {Math.round(scale * 100)}%
          </span>

          <button
            onClick={() =>
              changeScale(scale + 0.15)
            }
            className="p-1.5 hover:bg-white rounded-lg text-slate-600 hover:text-slate-900 hover:shadow-sm transition cursor-pointer"
            title="Phóng to"
          >
            <ZoomIn size={16} />
          </button>

          <button
            onClick={() =>
              changeScale(1.2)
            }
            className="p-1.5 hover:bg-white rounded-lg text-slate-400 hover:text-slate-800 hover:shadow-sm transition cursor-pointer"
            title="Kích thước chuẩn"
          >
            <RotateCcw size={14} />
          </button>
        </div>
      </div>

      {/* ============================================================= */}
      {/* PDF SCROLLER */}
      {/* ============================================================= */}

      <div
        ref={scrollContainerRef}
        onScroll={handleScroll}
        className="flex-1 overflow-y-auto overflow-x-hidden bg-slate-100/50"
      >
        <Document
          file={`http://127.0.0.1:8765/pdf-stream?id=${encodeURIComponent(
            currentDoc.id,
          )}`}
          options={pdfOptions}
          onLoadError={(error) =>
            showToast(
              'Không thể đọc PDF: ' +
                error.message,
              true,
            )
          }
          onLoadSuccess={(pdf) => {
            pdfDocRef.current = pdf;

            setNumPages(
              pdf.numPages,
            );

            setActivePage(1);

            if (
              scrollContainerRef.current
            ) {
              scrollContainerRef.current.scrollTop =
                0;
            }
          }}
          loading={
            <div className="flex flex-col items-center justify-center mt-36 space-y-3 text-slate-500">
              <Loader2
                size={36}
                className="animate-spin text-emerald-500"
              />

              <span className="text-sm font-semibold">
                Đang nạp luồng đọc tài
                liệu...
              </span>
            </div>
          }
        >
          {numPages > 0 && (
            <div className="w-full">
              {/* ======================================================= */}
              {/* TOP VIRTUAL SPACER */}
              {/* ======================================================= */}

              {topSpacerHeight > 0 && (
                <div
                  aria-hidden="true"
                  style={{
                    height: `${topSpacerHeight}px`,
                  }}
                />
              )}

              {/* ======================================================= */}
              {/* CHỈ 5 PAGE THẬT SỰ TỒN TẠI */}
              {/* ======================================================= */}

              {visiblePages.map(
                (pageNum) => (
                  <div
                    key={pageNum}
                    style={{
                      height: `${itemHeight}px`,
                    }}
                    className="w-full flex justify-center items-center"
                  >
                    <VirtualPDFPage
                      pageNumber={
                        pageNum
                      }
                      scale={scale}
                      isSelected={selectedPages.has(
                        pageNum,
                      )}
                      onToggle={
                        togglePage
                      }
                    />
                  </div>
                ),
              )}

              {/* ======================================================= */}
              {/* BOTTOM VIRTUAL SPACER */}
              {/* ======================================================= */}

              {bottomSpacerHeight > 0 && (
                <div
                  aria-hidden="true"
                  style={{
                    height: `${bottomSpacerHeight}px`,
                  }}
                />
              )}
            </div>
          )}
        </Document>
      </div>

      {/* ============================================================= */}
      {/* AI CONFIG */}
      {/* ============================================================= */}

      <div className="bg-white border-t border-slate-200 px-6 py-3.5 shadow-[0_-4px_25px_-5px_rgba(0,0,0,0.08)] z-30 shrink-0 space-y-2.5">
        {/* Hàng 1 */}
        <div className="flex flex-wrap items-center justify-between gap-3 pb-2 border-b border-slate-100">
          {/* Selected pages */}
          <div className="flex items-center gap-2">
            <span className="text-xs font-bold text-slate-500 uppercase tracking-wider">
              Đã chọn:
            </span>

            <span className="text-emerald-600 font-black font-mono text-sm px-2 py-0.5 bg-emerald-50 border border-emerald-200 rounded-md">
              {selectedPages.size} trang
            </span>

            <div className="flex gap-1.5 max-w-sm sm:max-w-md overflow-x-auto py-0.5">
              {Array.from(
                selectedPages,
              )
                .sort(
                  (a, b) => a - b,
                )
                .map((p) => (
                  <button
                    key={p}
                    onClick={() =>
                      scrollToPage(p)
                    }
                    className="px-2 py-0.5 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 border border-emerald-200 rounded text-xs font-mono font-bold transition cursor-pointer"
                    title={`Cuộn đến trang ${p}`}
                  >
                    P.{p}
                  </button>
                ))}
            </div>
          </div>

          {/* MODEL */}
          <div className="flex items-center gap-2">
            <label className="text-xs font-bold text-slate-600 whitespace-nowrap">
              Model AI:
            </label>

            <select
              value={selectedModel}
              onChange={(e) =>
                setSelectedModel(
                  e.target.value,
                )
              }
              className="bg-slate-50 border border-slate-300 rounded-lg px-3 py-1.5 text-xs font-bold text-slate-800 focus:bg-white focus:outline-none focus:border-emerald-500 transition cursor-pointer shadow-sm"
            >
              {models.length > 0 ? (
                models.map((model: any) => (
                  <option key={model.id} value={model.id}>
                    {model.display_name || model.id}
                  </option>
                ))
              ) : (
                <option value={selectedModel}>{selectedModel}</option>
              )}
            </select>
          </div>
        </div>

        {/* Hàng 2 */}
        <div className="flex flex-col md:flex-row items-end gap-3">
          <div className="flex-1 w-full space-y-2">
            <input
              type="text"
              value={title}
              onChange={(e) =>
                setTitle(e.target.value)
              }
              placeholder="Tiêu đề bài giảng (VD: Chuyên đề căn bậc hai lớp 9)..."
              className="w-full bg-slate-50 border border-slate-300 rounded-lg px-3 py-1.5 text-xs font-semibold text-slate-800 placeholder:text-slate-400 focus:bg-white focus:outline-none focus:border-emerald-500 transition shadow-sm"
            />

            <textarea
              ref={promptRef}
              rows={2}
              defaultValue={prompt}
              onInput={(event) => setPrompt(event.currentTarget.value)}
              placeholder="Yêu cầu tùy chỉnh (Prompt riêng) - Ví dụ: Tập trung vào giải các bài toán rút gọn biểu thức, giải thích chi tiết, tạo 5 câu trắc nghiệm tự luyện..."
              className="w-full bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-xs text-slate-800 placeholder:text-slate-400 focus:bg-white focus:outline-none focus:border-emerald-500 resize-none transition shadow-sm leading-relaxed"
            />
          </div>

          <button
            disabled={
              creating ||
              selectedPages.size === 0
            }
            onClick={
              handleCreateFromPDF
            }
            className="w-full md:w-auto h-[74px] px-6 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl font-bold text-xs shadow-lg shadow-emerald-600/30 transition disabled:opacity-40 disabled:cursor-not-allowed flex flex-col items-center justify-center gap-1 whitespace-nowrap cursor-pointer shrink-0"
          >
            <div className="flex items-center gap-1.5 text-sm">
              <Sparkles size={16} />

              <span>
                {creating
                  ? 'Đang gửi...'
                  : 'Tạo bài giảng'}
              </span>
            </div>

            <span className="text-[10px] font-normal opacity-90">
              ({selectedPages.size}{' '}
              trang đã chọn)
            </span>
          </button>
        </div>
      </div>
    </div>
  );
};