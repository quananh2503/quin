import React, { useEffect, useState } from 'react';
import { api } from '../api';
import { normalizeError } from '../utils';
import { BookOpen, Sparkles, FileText, CheckSquare } from 'lucide-react';

interface SidebarProps {
  currentView: string;
  onNavigate: (view: string) => void;
  showToast: (msg: string, isError?: boolean) => void;
}

export const Sidebar: React.FC<SidebarProps> = ({ currentView, onNavigate, showToast }) => {
  const [googleConnected, setGoogleConnected] = useState<boolean | null>(null);
  const [oneNoteConnected, setOneNoteConnected] = useState<boolean | null>(null);

  // Kiểm tra trạng thái đăng nhập tài khoản của Google và OneNote
  const checkStatus = async () => {
    try {
      setGoogleConnected(await api.isGoogleConnected());
      setOneNoteConnected(await api.isOneNoteConnected());
    } catch (e) {
      console.error(e);
    }
  };

  useEffect(() => {
    checkStatus();
  }, []);

  const handleConnectGoogle = async () => {
    showToast("Đang mở trình duyệt để kết nối Google...");
    try {
      await api.connectGoogleMeet();
      showToast("Kết nối Google Meet thành công!");
      checkStatus();
    } catch (err) {
      showToast("Lỗi đăng nhập Google: " + normalizeError(err), true);
    }
  };

  const handleConnectOneNote = async () => {
    showToast("Đang mở trình duyệt để kết nối OneNote...");
    try {
      await api.connectOneNote();
      showToast("Kết nối Microsoft OneNote thành công!");
      checkStatus();
    } catch (err) {
      showToast("Lỗi đăng nhập OneNote: " + normalizeError(err), true);
    }
  };

  const navItems = [
    { id: 'dashboard', label: 'Thống kê buổi học', icon: BookOpen },
    { id: 'lessons', label: 'Soạn bài với AI', icon: Sparkles },
    { id: 'documents', label: 'Tài liệu', icon: FileText },
    { id: 'grading', label: 'Chấm bài', icon: CheckSquare },
  ];

  return (
    <aside className="w-64 bg-slate-900 text-white flex flex-col justify-between p-4 shrink-0 h-screen overflow-y-auto">
      <div>
        <div className="mb-6 px-2">
          <h2 className="text-xl font-bold tracking-tight text-emerald-400">Lớp học 1–1</h2>
          <small className="text-slate-400 text-xs">Sổ làm việc giáo viên</small>
        </div>

        {/* Khối tài khoản liên kết */}
        <div className="bg-slate-800/60 rounded-xl p-3 border border-slate-700/50 mb-6 space-y-3">
          <span className="text-[11px] font-bold text-slate-400 uppercase tracking-wider block">Liên kết tài khoản</span>

          {/* Google */}
          <div className="text-xs space-y-1">
            <div className="flex justify-between items-center">
              <span className="font-semibold text-slate-200">Google Meet</span>
              <span className="flex items-center gap-1 text-[11px]">
                <span className={`w-2 h-2 rounded-full ${googleConnected ? 'bg-emerald-500' : 'bg-slate-500'}`} />
                {googleConnected ? 'Đã kết nối' : 'Chưa kết nối'}
              </span>
            </div>
            <button 
              onClick={handleConnectGoogle} 
              className="w-full text-center py-1 bg-slate-700 hover:bg-slate-600 rounded text-[11px] text-slate-200 transition"
            >
              Kết nối Google Meet
            </button>
          </div>

          {/* OneNote */}
          <div className="text-xs space-y-1 pt-1 border-t border-slate-700/40">
            <div className="flex justify-between items-center">
              <span className="font-semibold text-slate-200">OneNote</span>
              <span className="flex items-center gap-1 text-[11px]">
                <span className={`w-2 h-2 rounded-full ${oneNoteConnected ? 'bg-purple-500' : 'bg-slate-500'}`} />
                {oneNoteConnected ? 'Đã kết nối' : 'Chưa kết nối'}
              </span>
            </div>
            <button 
              onClick={handleConnectOneNote} 
              className="w-full text-center py-1 bg-slate-700 hover:bg-slate-600 rounded text-[11px] text-slate-200 transition"
            >
              Kết nối OneNote
            </button>
          </div>
        </div>

        {/* Danh sách Tab chuyển hướng */}
        <nav className="space-y-1">
          {navItems.map((item) => {
            const Icon = item.icon;
            const active = currentView === item.id;
            return (
              <button
                key={item.id}
                onClick={() => onNavigate(item.id)}
                className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition ${
                  active ? 'bg-emerald-600 text-white shadow-sm' : 'text-slate-300 hover:bg-slate-800 hover:text-white'
                }`}
              >
                <Icon size={18} />
                {item.label}
              </button>
            );
          })}
        </nav>
      </div>

      <div className="text-[11px] text-slate-500 text-center py-2">
        QUIN • Teacher Assistant 2026
      </div>
    </aside>
  );
};