import React from 'react';
import { X, Copy } from 'lucide-react';

export const ErrorModal: React.FC<{ draft: any; onClose: () => void; showToast: any }> = ({ draft, onClose, showToast }) => {
  if (!draft) return null;
  const copyLog = () => {
    navigator.clipboard.writeText(draft.error_message || "Không có lỗi");
    showToast("Đã sao chép nội dung lỗi!");
  };

  return (
    <div className="fixed inset-0 bg-slate-900/40 backdrop-blur-xs flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-xl max-w-lg w-full p-6 shadow-xl space-y-4">
        <div className="flex justify-between items-center">
          <h3 className="font-bold text-slate-800">Chi tiết lỗi xử lý AI</h3>
          <button onClick={onClose}><X size={18} /></button>
        </div>
        <pre className="p-3 bg-slate-900 text-red-400 rounded-lg text-xs font-mono overflow-x-auto max-h-60">
          {draft.error_message || "Không tìm thấy dữ liệu lỗi"}
        </pre>
        <div className="flex justify-end gap-2">
          <button onClick={copyLog} className="flex items-center gap-1 px-3 py-1.5 bg-slate-100 hover:bg-slate-200 rounded text-xs font-semibold">
            <Copy size={14} /> Sao chép
          </button>
          <button onClick={onClose} className="px-3 py-1.5 bg-slate-800 text-white rounded text-xs font-semibold">Đóng</button>
        </div>
      </div>
    </div>
  );
};