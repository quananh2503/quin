import React, { useState, useEffect } from 'react';
import { api } from '../../api';
import { formatDateTime, normalizeError } from '../../utils';
import { CheckSquare, ExternalLink } from 'lucide-react';

interface GradingViewProps {
  onOpenGradingDetail: (assignmentId: string) => void;
  onOpenRemediation: (mistake: any) => void;
  showToast: (msg: string, isError?: boolean) => void;
}

export const GradingView: React.FC<GradingViewProps> = ({ onOpenGradingDetail, onOpenRemediation, showToast }) => {
  const [tab, setTab] = useState<'assignments' | 'mistakes'>('assignments');
  const [assignments, setAssignments] = useState<any[]>([]);
  const [mistakeGroups, setMistakeGroups] = useState<any[]>([]);
  const [search, setSearch] = useState("");

  const loadAssignments = async () => {
    try {
      const res = await api.listAssignments(search);
      setAssignments(res || []);
    } catch (err) {
      showToast("Lỗi tải bài tập: " + normalizeError(err), true);
    }
  };

  const loadMistakes = async () => {
    try {
      const res = await api.listMistakes();
      setMistakeGroups(res || []);
    } catch (err) {
      showToast("Lỗi tải danh sách lỗi: " + normalizeError(err), true);
    }
  };

  useEffect(() => {
    if (tab === 'assignments') loadAssignments();
    else loadMistakes();
  }, [tab]);

  return (
    <div className="p-8 space-y-6 max-w-7xl mx-auto">
      <div>
        <span className="text-xs font-semibold text-emerald-600 uppercase tracking-wider">OneNote & AI</span>
        <h1 className="text-2xl font-bold text-slate-800">Chấm bài</h1>
      </div>

      <div className="flex border-b border-slate-200 gap-6">
        <button
          onClick={() => setTab('assignments')}
          className={`pb-3 text-sm font-semibold border-b-2 transition ${
            tab === 'assignments' ? 'border-emerald-600 text-emerald-600' : 'border-transparent text-slate-500'
          }`}
        >
          Bài đã giao ({assignments.length})
        </button>
        <button
          onClick={() => setTab('mistakes')}
          className={`pb-3 text-sm font-semibold border-b-2 transition ${
            tab === 'mistakes' ? 'border-emerald-600 text-emerald-600' : 'border-transparent text-slate-500'
          }`}
        >
          Lỗi sai học sinh
        </button>
      </div>

      {tab === 'assignments' ? (
        <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
          <table className="w-full text-left text-sm">
            <thead className="bg-slate-50 text-slate-500 font-semibold border-b border-slate-200">
              <tr>
                <th className="py-3 px-5">Học sinh & Bài</th>
                <th className="py-3 px-5">Ngày giao</th>
                <th className="py-3 px-5">Kết quả</th>
                <th className="py-3 px-5 text-right">Thao tác</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {assignments.map((a: any) => (
                <tr key={a.assignment_id} className="hover:bg-slate-50">
                  <td className="py-3.5 px-5">
                    <strong>{a.student_name}</strong>
                    <br /><small className="text-slate-400">{a.title}</small>
                  </td>
                  <td className="py-3.5 px-5 text-slate-500 text-xs">{formatDateTime(a.assigned_at)}</td>
                  <td className="py-3.5 px-5">
                    <span className="px-2.5 py-1 bg-emerald-50 text-emerald-700 rounded-full text-xs font-semibold">
                      {a.correct_count}/{a.total_count} câu đúng
                    </span>
                  </td>
                  <td className="py-3.5 px-5 text-right space-x-2">
                    {a.student_page_web_url && (
                      <button onClick={() => api.openExternalURL(a.student_page_web_url)} className="text-xs font-semibold text-slate-600 hover:text-slate-900">
                        Mở HS
                      </button>
                    )}
                    <button
                      onClick={() => onOpenGradingDetail(a.assignment_id)}
                      className="px-3 py-1 bg-emerald-600 hover:bg-emerald-700 text-white rounded text-xs font-semibold"
                    >
                      Chấm bài
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ) : (
        <div className="space-y-4">
          {mistakeGroups.map((g: any) => (
            <div key={g.student_id} className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm space-y-3">
              <h3 className="font-bold text-slate-800">{g.student_name}</h3>
              <div className="divide-y divide-slate-100">
                {g.mistakes?.map((m: any) => (
                  <div key={m.id} className="py-3 flex justify-between items-center">
                    <div>
                      <strong className="text-slate-800 text-sm">{m.topic}</strong>
                      <p className="text-xs text-slate-500">{m.reason}</p>
                    </div>
                    <button
                      onClick={() => onOpenRemediation({ ...m, student_id: g.student_id })}
                      className="px-3 py-1 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded text-xs font-semibold"
                    >
                      Tạo bài khắc phục
                    </button>
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};