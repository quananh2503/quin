import React, { useState, useEffect } from 'react';
import { api } from '../../api';
import { normalizeError, extractContentText } from '../../utils';
import {
  ArrowLeft,
  Save,
  Send,
  GraduationCap,
  School,
  Download,
  ChevronDown,
  FolderDown,
  Loader2,
} from 'lucide-react';
import { A4PaperLessonView } from '../paper/A4PaperLessonView';

interface LessonEditorViewProps {
  draftId: string;
  onBack: () => void;
  onOpenPushOneNote: (draft: any) => void;
  showToast: (msg: string, isError?: boolean) => void;
}

export const LessonEditorView: React.FC<LessonEditorViewProps> = ({
  draftId,
  onBack,
  onOpenPushOneNote,
  showToast,
}) => {
  const [draft, setDraft] = useState<any>(null);
  const [title, setTitle] = useState('');
  const [overview, setOverview] = useState('');
  const [sections, setSections] = useState<any[]>([]);
  const [exercises, setExercises] = useState<any[]>([]);
  const [saving, setSaving] = useState(false);
  const [exportingPDF, setExportingPDF] = useState(false);
  const [showDownloadMenu, setShowDownloadMenu] = useState(false);
  const [isTeacherMode, setIsTeacherMode] = useState(true);

  // Nạp bản nháp chi tiết từ Backend
  useEffect(() => {
    (async () => {
      try {
        const res = await api.getLessonDraft(String(draftId));
        setDraft(res);
        setTitle(extractContentText(res.title || res.lesson_data?.title || ''));
        setOverview(extractContentText(res.lesson_data?.overview || ''));
        setSections(res.lesson_data?.sections || []);
        setExercises(res.lesson_data?.exercises || []);
      } catch (err) {
        showToast('Lỗi mở bài giảng: ' + normalizeError(err), true);
      }
    })();
  }, [draftId]);

  // Lưu nội dung bài giảng
  const handleSave = async () => {
    if (!title.trim()) {
      showToast('Vui lòng nhập tiêu đề bài giảng', true);
      return false;
    }
    setSaving(true);
    const lessonData = {
      id: draft?.lesson_data?.id,
      title: title.trim(),
      overview: overview.trim(),
      sections,
      exercises,
    };
    try {
      if (api.saveLessonDraft) {
        await api.saveLessonDraft({
          draft_id: String(draftId),
          lesson: lessonData,
        });
      }
      showToast('Đã lưu bài giảng thành công!');
      return true;
    } catch (err) {
      showToast('Lỗi lưu bài: ' + normalizeError(err), true);
      return false;
    } finally {
      setSaving(false);
    }
  };

  const triggerBrowserDownload = (url: string) => {
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', '');
    link.target = '_blank';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  // Xuất 1 file PDF (GV hoặc HS)
  const handleExportSinglePDF = async (isTeacher: boolean) => {
    setShowDownloadMenu(false);
    setExportingPDF(true);
    try {
      // Lưu lại thay đổi trước khi render
      await handleSave();
      const lessonId = draft?.lesson_data?.id || draftId;
      const savedPath = await api.exportLessonPDF({
        lesson_id: String(lessonId),
        is_teacher: isTeacher,
      });
      if (savedPath) {
        if (savedPath.startsWith('/api/') || savedPath.startsWith('http')) {
          triggerBrowserDownload(savedPath);
          showToast('Đang tải file PDF về máy...');
        } else {
          showToast(`Đã xuất PDF thành công: ${savedPath}`);
        }
      }
    } catch (err) {
      showToast('Lỗi xuất PDF: ' + normalizeError(err), true);
    } finally {
      setExportingPDF(false);
    }
  };

  // Xuất cả 2 file PDF (GV & HS) vào thư mục
  const handleExportBothPDFs = async () => {
    setShowDownloadMenu(false);
    setExportingPDF(true);
    try {
      await handleSave();
      const lessonId = draft?.lesson_data?.id || draftId;
      const paths = await api.exportBothLessonPDFs(String(lessonId));
      if (paths && paths.length > 0) {
        let isWeb = false;
        paths.forEach((p: string, idx: number) => {
          if (p.startsWith('/api/') || p.startsWith('http')) {
            isWeb = true;
            setTimeout(() => {
              triggerBrowserDownload(p);
            }, idx * 400);
          }
        });
        if (isWeb) {
          showToast('Đang tải cả 2 file PDF về máy...');
        } else {
          showToast(`Đã xuất thành công 2 file PDF vào thư mục!`);
        }
      }
    } catch (err) {
      showToast('Lỗi xuất 2 file PDF: ' + normalizeError(err), true);
    } finally {
      setExportingPDF(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-100 flex flex-col">
      {/* THANH ĐIỀU KHIỂN CỐ ĐỊNH Ở TRÊN (STICKY HEADER) */}
      <div className="sticky top-0 z-30 bg-white/95 backdrop-blur-md border-b border-slate-200 px-6 py-3 shadow-xs">
        <div className="max-w-6xl mx-auto flex items-center justify-between gap-4">
          {/* Nút quay lại */}
          <button
            onClick={onBack}
            className="flex items-center gap-1.5 text-xs font-semibold text-slate-600 hover:text-slate-900 transition"
          >
            <ArrowLeft size={16} /> Danh sách bài giảng
          </button>

          {/* CHUYỂN ĐỔI CHẾ ĐỘ XEM: GIÁO VIÊN / HỌC SINH */}
          <div className="flex items-center bg-slate-100 p-0.5 rounded-lg border border-slate-200">
            <button
              onClick={() => setIsTeacherMode(true)}
              className={`flex items-center gap-1.5 px-3 py-1 text-xs font-bold rounded-md transition ${
                isTeacherMode
                  ? 'bg-blue-600 text-white shadow-xs'
                  : 'text-slate-600 hover:text-slate-900'
              }`}
            >
              <GraduationCap size={15} /> Bản Giáo viên
            </button>
            <button
              onClick={() => setIsTeacherMode(false)}
              className={`flex items-center gap-1.5 px-3 py-1 text-xs font-bold rounded-md transition ${
                !isTeacherMode
                  ? 'bg-teal-600 text-white shadow-xs'
                  : 'text-slate-600 hover:text-slate-900'
              }`}
            >
              <School size={15} /> Bản Học sinh
            </button>
          </div>

          {/* CÁC NÚT THAO TÁC */}
          <div className="flex items-center gap-2.5">
            <button
              onClick={handleSave}
              disabled={saving}
              className="flex items-center gap-1.5 px-3.5 py-1.5 bg-slate-100 hover:bg-slate-200 text-slate-800 rounded-lg text-xs font-semibold transition"
            >
              <Save size={15} /> {saving ? 'Đang lưu...' : 'Lưu bản nháp'}
            </button>

            {/* CỤM NÚT TẢI PDF */}
            <div className="relative">
              <button
                onClick={() => setShowDownloadMenu(!showDownloadMenu)}
                disabled={exportingPDF}
                className="flex items-center gap-1.5 px-3 py-1.5 bg-blue-50 hover:bg-blue-100 text-blue-700 border border-blue-200 rounded-lg text-xs font-semibold transition shadow-2xs"
                title="Tải bài giảng dưới dạng file PDF"
              >
                {exportingPDF ? (
                  <Loader2 size={15} className="animate-spin text-blue-600" />
                ) : (
                  <Download size={15} />
                )}
                <span>{exportingPDF ? 'Đang tạo PDF...' : 'Tải PDF'}</span>
                <ChevronDown size={13} className="text-blue-500" />
              </button>

              {showDownloadMenu && (
                <>
                  <div
                    className="fixed inset-0 z-20"
                    onClick={() => setShowDownloadMenu(false)}
                  />
                  <div className="absolute right-0 mt-1.5 w-64 bg-white rounded-xl shadow-xl border border-slate-200 py-1.5 z-30 text-xs animate-in fade-in duration-100">
                    <div className="px-3 py-1.5 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-100">
                      Xuất file in PDF (Typst Vector)
                    </div>

                    <button
                      onClick={handleExportBothPDFs}
                      className="w-full flex items-start gap-2.5 px-3 py-2 text-left hover:bg-blue-50 text-slate-700 hover:text-blue-700 transition"
                    >
                      <FolderDown size={16} className="text-blue-600 mt-0.5 shrink-0" />
                      <div>
                        <div className="font-semibold text-slate-800">Tải cả 2 bản (GV & HS)</div>
                        <div className="text-[11px] text-slate-400 font-normal">Lưu cùng lúc 2 file PDF vào một thư mục</div>
                      </div>
                    </button>

                    <div className="my-1 border-t border-slate-100" />

                    <button
                      onClick={() => handleExportSinglePDF(true)}
                      className="w-full flex items-start gap-2.5 px-3 py-2 text-left hover:bg-blue-50 text-slate-700 hover:text-blue-700 transition"
                    >
                      <GraduationCap size={16} className="text-blue-600 mt-0.5 shrink-0" />
                      <div>
                        <div className="font-semibold text-slate-800">Bản Giáo viên (.pdf)</div>
                        <div className="text-[11px] text-slate-400 font-normal">Kèm đầy đủ lời giải chi tiết & đáp án</div>
                      </div>
                    </button>

                    <button
                      onClick={() => handleExportSinglePDF(false)}
                      className="w-full flex items-start gap-2.5 px-3 py-2 text-left hover:bg-teal-50 text-slate-700 hover:text-teal-700 transition"
                    >
                      <School size={16} className="text-teal-600 mt-0.5 shrink-0" />
                      <div>
                        <div className="font-semibold text-slate-800">Bản Học sinh (.pdf)</div>
                        <div className="text-[11px] text-slate-400 font-normal">Chừa ô kẻ nét đứt để học sinh làm bài</div>
                      </div>
                    </button>
                  </div>
                </>
              )}
            </div>

            {/* NÚT ĐẨY LÊN ONENOTE */}
            <button
              onClick={async () => {
                onOpenPushOneNote({
                  ...draft,
                  title,
                  lesson_data: {
                    id: draft?.lesson_data?.id,
                    title,
                    overview,
                    sections,
                    exercises,
                  },
                });
              }}
              className="flex items-center gap-1.5 px-3.5 py-1.5 bg-purple-700 hover:bg-purple-800 text-white rounded-lg text-xs font-semibold transition shadow-xs"
            >
              <Send size={15} /> Đẩy lên OneNote
            </button>
          </div>
        </div>
      </div>

      {/* VÙNG CHỨA TỜ GIẤY IN A4 (CLICK TO EDIT TRỰC TIẾP) */}
      <div className="flex-1 overflow-y-auto">
        <A4PaperLessonView
          title={title}
          onTitleChange={setTitle}
          overview={overview}
          onOverviewChange={setOverview}
          sections={sections}
          onSectionsChange={setSections}
          exercises={exercises}
          onExercisesChange={setExercises}
          isTeacherMode={isTeacherMode}
        />
      </div>
    </div>
  );
};
