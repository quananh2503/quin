import React, { useState, useEffect } from 'react';
import { api } from '../../api';
import { normalizeError } from '../../utils';
import { ArrowLeft, Save, Send, GraduationCap, School } from 'lucide-react';
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
  const [isTeacherMode, setIsTeacherMode] = useState(true);

  // Nạp bản nháp chi tiết từ Backend
  useEffect(() => {
    (async () => {
      try {
        const res = await api.getLessonDraft(String(draftId));
        setDraft(res);
        setTitle(res.title || res.lesson_data?.title || '');
        setOverview(res.lesson_data?.overview || '');
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
