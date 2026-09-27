import React, { useState } from 'react';
import { api } from '../../api';
import { normalizeError } from '../../utils';
import { X, Sparkles } from 'lucide-react';

export const RemediationModal: React.FC<{ mistake: any; onClose: () => void; showToast: any; onGoLessons: any }> = ({ mistake, onClose, showToast, onGoLessons }) => {
  const [prompt, setPrompt] = useState("");
  const [loading, setLoading] = useState(false);

  // Sinh bài giảng khắc phục lỗi bằng AI
  const handleGenerate = async () => {
    setLoading(true);
    try {
      await api.generateRemediation({
        student_id: mistake.student_id,
        mistake_id: mistake.id,
        model: "gemini-3.7-flash",
        prompt: prompt.trim()
      });
      showToast("Đã tạo bản nháp bài khắc phục! Hãy mở xem lại trong mục Soạn bài.");
      onClose();
      onGoLessons();
    } catch (err) {
      showToast("Lỗi tạo bài: " + normalizeError(err), true);
    } finally {
      setLoading(false);
    }
  };

  if (!mistake) return null;

  return (
    <div className="fixed inset-0 bg-slate-900/40 backdrop-blur-xs flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-xl max-w-md w-full p-6 shadow-xl space-y-4">
        <div className="flex justify-between items-center">
          <h3 className="font-bold text-emerald-800">Tạo bài tập từ lỗi sai</h3>
          <button onClick={onClose}><X size={18} /></button>
        </div>
        <p className="p-3 bg-emerald-50 text-emerald-900 rounded-lg text-xs font-medium">
          {mistake.topic}: {mistake.reason}
        </p>
        <div>
          <label className="block text-xs font-semibold text-slate-600 mb-1">Yêu cầu thêm (không bắt buộc)</label>
          <textarea rows={3} placeholder="Ví dụ: tăng dần độ khó, chú trọng vào công thức..." value={prompt} onChange={(e) => setPrompt(e.target.value)} className="w-full px-3 py-2 border rounded-lg text-sm" />
        </div>
        <div className="flex justify-end gap-2">
          <button onClick={onClose} className="px-4 py-2 bg-slate-100 hover:bg-slate-200 rounded-lg text-xs font-semibold">Hủy</button>
          <button onClick={handleGenerate} disabled={loading} className="flex items-center gap-1 px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-xs font-semibold">
            <Sparkles size={14} /> {loading ? "Đang tạo..." : "Tạo bản nháp"}
          </button>
        </div>
      </div>
    </div>
  );
};