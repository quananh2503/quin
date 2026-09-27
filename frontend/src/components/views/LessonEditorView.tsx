import React, { useState, useEffect } from 'react';
import { api } from '../../api';
import { normalizeError } from '../../utils';
import { ArrowLeft, Save, Send, Plus, Trash2 } from 'lucide-react';

interface LessonEditorViewProps {
  draftId: string;
  onBack: () => void;
  onOpenPushOneNote: (draft: any) => void;
  showToast: (msg: string, isError?: boolean) => void;
}

export const LessonEditorView: React.FC<LessonEditorViewProps> = ({ draftId, onBack, onOpenPushOneNote, showToast }) => {
  const [draft, setDraft] = useState<any>(null);
  const [title, setTitle] = useState("");
  const [overview, setOverview] = useState("");
  const [sections, setSections] = useState<any[]>([]);
  const [exercises, setExercises] = useState<any[]>([]);
  const [saving, setSaving] = useState(false);

  // Nạp bản nháp chi tiết
  useEffect(() => {
    (async () => {
      try {
        const res = await api.getLessonDraft(String(draftId));
        setDraft(res);
        setTitle(res.title || "");
        setOverview(res.lesson_data?.overview || "");
        setSections(res.lesson_data?.sections || []);
        setExercises(res.lesson_data?.exercises || []);
      } catch (err) {
        showToast("Lỗi mở bài giảng: " + normalizeError(err), true);
      }
    })();
  }, [draftId]);

  // Lưu cấu trúc bài giảng vào cơ sở dữ liệu
  const handleSave = async () => {
    if (!title.trim()) {
      showToast("Vui lòng nhập tiêu đề bài giảng", true);
      return false;
    }
    setSaving(true);
    const lessonData = {
      title: title.trim(),
      overview: overview.trim(),
      sections,
      exercises
    };
    try {
      await api.saveLessonDraft({
        draft_id: String(draftId),
        lesson: lessonData
      });
      showToast("Đã lưu bản nháp thành công!");
      return true;
    } catch (err) {
      showToast("Lỗi lưu bài: " + normalizeError(err), true);
      return false;
    } finally {
      setSaving(false);
    }
  };

  const addSection = () => {
    setSections([...sections, { section_title: "Mục mới", transition_intro: "", detailed_content: "", key_takeaway: "", student_cloze_notes: [] }]);
  };

  const addExercise = () => {
    setExercises([...exercises, { type: "multiple-choice", topic: "Chủ đề", difficulty: "Thông hiểu", question: "Nội dung câu hỏi...", options: [], answer: "A", explanation: "" }]);
  };

  return (
    <div className="p-8 space-y-6 max-w-5xl mx-auto">
      <div className="flex justify-between items-center">
        <button onClick={onBack} className="flex items-center gap-2 text-sm text-slate-500 hover:text-slate-800 font-medium">
          <ArrowLeft size={16} /> Danh sách bài giảng
        </button>
        <div className="flex items-center gap-3">
          <button
            onClick={handleSave}
            disabled={saving}
            className="flex items-center gap-1.5 px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-800 rounded-lg text-sm font-semibold transition"
          >
            <Save size={16} /> {saving ? "Đang lưu..." : "Lưu bản nháp"}
          </button>
          <button
            onClick={async () => { 
              onOpenPushOneNote({ ...draft, title, lesson_data: { id: draft?.lesson_data?.id, title, overview, sections, exercises } });
            }}
            className="flex items-center gap-1.5 px-4 py-2 bg-purple-700 hover:bg-purple-800 text-white rounded-lg text-sm font-semibold transition shadow-sm"
          >
            <Send size={16} /> Đẩy lên OneNote
          </button>
        </div>
      </div>

      <div className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm space-y-6">
        <div>
          <label className="block text-xs font-semibold text-slate-600 mb-1">Tiêu đề bài giảng</label>
          <input
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            className="w-full text-xl font-bold px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            placeholder="Nhập tiêu đề bài học..."
          />
        </div>

        <div>
          <label className="block text-xs font-semibold text-slate-600 mb-1">Tổng quan bài học</label>
          <textarea
            rows={2}
            value={overview}
            onChange={(e) => setOverview(e.target.value)}
            className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg"
            placeholder="Mục tiêu và kiến thức trọng tâm..."
          />
        </div>

        {/* Danh sách mục nội dung */}
        <div className="space-y-4 pt-4 border-t border-slate-100">
          <div className="flex justify-between items-center">
            <h3 className="font-bold text-slate-800">Nội dung bài học</h3>
            <button onClick={addSection} className="text-xs font-semibold text-emerald-600 hover:underline flex items-center gap-1">
              <Plus size={14} /> Thêm mục
            </button>
          </div>
          {sections.map((s, index) => (
            <div key={index} className="p-4 bg-slate-50 rounded-lg border border-slate-200 space-y-3 relative">
              <button 
                onClick={() => setSections(sections.filter((_, i) => i !== index))}
                className="absolute top-3 right-3 text-slate-400 hover:text-red-500"
              >
                <Trash2 size={16} />
              </button>
              <input
                type="text"
                value={s.section_title}
                onChange={(e) => {
                  const updated = [...sections];
                  updated[index].section_title = e.target.value;
                  setSections(updated);
                }}
                className="font-bold text-slate-800 bg-white px-3 py-1.5 border border-slate-300 rounded text-sm w-3/4"
              />
              <textarea
                rows={3}
                value={s.detailed_content}
                onChange={(e) => {
                  const updated = [...sections];
                  updated[index].detailed_content = e.target.value;
                  setSections(updated);
                }}
                className="w-full text-sm bg-white p-2 border border-slate-300 rounded"
                placeholder="Nội dung chi tiết..."
              />
            </div>
          ))}
        </div>

        {/* Danh sách câu hỏi / bài tập */}
        <div className="space-y-4 pt-4 border-t border-slate-100">
          <div className="flex justify-between items-center">
            <h3 className="font-bold text-slate-800">Bài tập</h3>
            <button onClick={addExercise} className="text-xs font-semibold text-emerald-600 hover:underline flex items-center gap-1">
              <Plus size={14} /> Thêm bài tập
            </button>
          </div>
          {exercises.map((ex, index) => (
            <div key={index} className="p-4 bg-slate-50 rounded-lg border border-slate-200 space-y-3 relative">
              <button 
                onClick={() => setExercises(exercises.filter((_, i) => i !== index))}
                className="absolute top-3 right-3 text-slate-400 hover:text-red-500"
              >
                <Trash2 size={16} />
              </button>
              <div className="flex gap-3">
                <span className="text-xs font-bold text-slate-500 uppercase self-center">Câu {index + 1}</span>
                <input
                  type="text"
                  value={ex.topic}
                  onChange={(e) => {
                    const updated = [...exercises];
                    updated[index].topic = e.target.value;
                    setExercises(updated);
                  }}
                  className="text-xs font-semibold bg-white px-2 py-1 border border-slate-300 rounded"
                  placeholder="Chủ đề..."
                />
              </div>
              <textarea
                rows={2}
                value={ex.question}
                onChange={(e) => {
                  const updated = [...exercises];
                  updated[index].question = e.target.value;
                  setExercises(updated);
                }}
                className="w-full text-sm bg-white p-2 border border-slate-300 rounded"
                placeholder="Nội dung câu hỏi..."
              />
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};