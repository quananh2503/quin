// src/components/views/GradingDetailView.tsx
import React, { useState, useEffect } from 'react';
import { api } from '../../api';
import { normalizeError } from '../../utils';
import { ArrowLeft, Sparkles, Send } from 'lucide-react';

interface GradingDetailViewProps {
  assignmentId: string;
  onBack: () => void;
  showToast: (msg: string, isError?: boolean) => void;
}

export const GradingDetailView: React.FC<GradingDetailViewProps> = ({ assignmentId, onBack, showToast }) => {
  const [data, setData] = useState<any>(null);
  const [selectedItems, setSelectedItems] = useState<Set<string>>(new Set());
  const [grading, setGrading] = useState(false);
  const [pushing, setPushing] = useState(false);

  const loadAssignment = async () => {
    try {
      const res = await api.getAssignment(String(assignmentId));
      setData(res);
      setSelectedItems(new Set(res?.items?.map((it: any) => String(it.id)) || []));
    } catch (err) {
      showToast("Lỗi mở bài: " + normalizeError(err), true);
    }
  };

  useEffect(() => {
    loadAssignment();
  }, [assignmentId]);

  // Kích hoạt AI chấm bài các câu đã chọn
  const handleGrade = async () => {
    if (selectedItems.size === 0) return;
    setGrading(true);
    try {
      await api.gradeAssignment({
        assignment_id: String(assignmentId),
        item_ids: Array.from(selectedItems),
        model: "gemini-3.7-flash",
        prompt: ""
      });
      showToast("Đã chấm và ghi nhận xét vào OneNote");
      loadAssignment();
    } catch (err) {
      showToast("Lỗi chấm bài: " + normalizeError(err), true);
    } finally {
      setGrading(false);
    }
  };

  // Đẩy nhận xét lại lên sổ OneNote
  const handlePushFeedback = async () => {
    setPushing(true);
    try {
      await api.pushAssignmentFeedback(String(assignmentId));
      showToast("Đã đẩy lại nhận xét lên OneNote");
    } catch (err) {
      showToast("Lỗi đẩy nhận xét: " + normalizeError(err), true);
    } finally {
      setPushing(false);
    }
  };

  return (
    <div className="p-8 space-y-6 max-w-5xl mx-auto">
      <button onClick={onBack} className="flex items-center gap-2 text-sm text-slate-500 hover:text-slate-800 font-medium">
        <ArrowLeft size={16} /> Danh sách bài tập
      </button>

      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-slate-800">{data?.title}</h1>
          <p className="text-slate-500 text-sm">Học sinh: {data?.student_name}</p>
        </div>
        <div className="flex gap-2">
          <button
            onClick={handlePushFeedback}
            disabled={pushing}
            className="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg text-sm font-semibold"
          >
            {pushing ? "Đang đẩy..." : "Đẩy lại nhận xét"}
          </button>
          <button
            onClick={handleGrade}
            disabled={grading || selectedItems.size === 0}
            className="flex items-center gap-1.5 px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-sm font-semibold transition"
          >
            <Sparkles size={16} /> {grading ? "Đang chấm..." : "Chấm các câu đã chọn"}
          </button>
        </div>
      </div>

      <div className="bg-white rounded-xl border border-slate-200 shadow-sm divide-y divide-slate-100">
        {data?.items?.map((item: any) => (
          <div key={item.id} className="p-4 flex gap-3 items-start">
            <input
              type="checkbox"
              checked={selectedItems.has(String(item.id))}
              onChange={(e) => {
                const s = new Set(selectedItems);
                if (e.target.checked) s.add(String(item.id)); else s.delete(String(item.id));
                setSelectedItems(s);
              }}
              className="mt-1"
            />
            <div className="space-y-1 flex-1">
              <div className="flex justify-between">
                <strong className="text-sm text-slate-800">{item.exercise?.topic || "Câu hỏi"}</strong>
                <span className={`text-xs px-2 py-0.5 rounded font-semibold ${
                  item.outcome === "correct" ? "bg-emerald-50 text-emerald-700" : "bg-red-50 text-red-700"
                }`}>
                  {item.outcome === "correct" ? "Đúng" : "Sai / Chưa chấm"}
                </span>
              </div>
              <p className="text-sm text-slate-600">{item.exercise?.question}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};