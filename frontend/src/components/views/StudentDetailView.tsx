import React, { useState, useEffect } from 'react';
import { api } from '../../api';
import { formatDuration, formatDateTime, calculateMinutes, vietnamDayBoundaryISO, normalizeError, formatDateToInput } from '../../utils';
import { ArrowLeft, Save } from 'lucide-react';

interface StudentDetailViewProps {
  studentId: string;
  fromDate: Date;
  toDate: Date;
  onBack: () => void;
  showToast: (msg: string, isError?: boolean) => void;
}

export const StudentDetailView: React.FC<StudentDetailViewProps> = ({ studentId, fromDate, toDate, onBack, showToast }) => {
  const [data, setData] = useState<any>(null);
  const [loading, setLoading] = useState(false);

  // Form edit
  const [name, setName] = useState("");
  const [space, setSpace] = useState("");
  const [cycleDay, setCycleDay] = useState(1);

  // Bộ lọc mặc định nhận từ Dashboard: đầu tháng đến hiện tại.
  const [filterFrom, setFilterFrom] = useState(() => new Date(fromDate));
  const [filterTo, setFilterTo] = useState(() => new Date(toDate));
  const [minDuration, setMinDuration] = useState(30);

  const loadDetail = async () => {
    setLoading(true);
    try {
      const res = await api.getStudentDetail({
        student_id: String(studentId),
        from_date: vietnamDayBoundaryISO(filterFrom, false),
        to_date: vietnamDayBoundaryISO(filterTo, true),
        min_duration_minutes: minDuration
      });
      setData(res);
      setName(res?.student?.name || "");
      setSpace(res?.student?.class || "");
      setCycleDay(res?.student?.cycle_start_day || 1);
    } catch (err) {
      showToast("Lỗi tải chi tiết: " + normalizeError(err), true);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadDetail();
  }, [studentId]);

  // Cập nhật thông tin học sinh
  const handleUpdate = async () => {
    try {
      await api.updateStudent({
        student_id: String(studentId),
        name: name.trim(),
        start_cycle_day: Number(cycleDay)
      });
      showToast("Đã lưu thông tin học sinh!");
      loadDetail();
    } catch (err) {
      showToast("Lỗi lưu thông tin: " + normalizeError(err), true);
    }
  };

  return (
    <div className="p-8 space-y-6 max-w-7xl mx-auto">
      <button onClick={onBack} className="flex items-center gap-2 text-sm text-slate-500 hover:text-slate-800 font-medium transition">
        <ArrowLeft size={16} /> Quay lại danh sách
      </button>

      <div>
        <span className="text-xs font-semibold text-emerald-600 uppercase tracking-wider">Chi tiết học sinh</span>
        <h1 className="text-3xl font-extrabold text-slate-900">{data?.student?.name || "Đang tải..."}</h1>
        <p className="text-slate-500 text-sm font-mono mt-0.5">{data?.student?.space_name || data?.student?.meeting_code || data?.student?.class}</p>
      </div>

      <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
        <div>
          <label className="block text-xs font-semibold text-slate-600 mb-1">Từ ngày</label>
          <input
            type="date"
            value={formatDateToInput(filterFrom)}
            onChange={(e) => {
              if (!e.target.value) return;
              const [y, m, d] = e.target.value.split("-").map(Number);
              setFilterFrom(new Date(y, m - 1, d, 0, 0, 0));
            }}
            className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg"
          />
        </div>
        <div>
          <label className="block text-xs font-semibold text-slate-600 mb-1">Đến ngày</label>
          <input
            type="date"
            value={formatDateToInput(filterTo)}
            onChange={(e) => {
              if (!e.target.value) return;
              const [y, m, d] = e.target.value.split("-").map(Number);
              setFilterTo(new Date(y, m - 1, d, 23, 59, 59));
            }}
            className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg"
          />
        </div>
        <div>
          <label className="block text-xs font-semibold text-slate-600 mb-1">Tối thiểu (phút)</label>
          <input
            type="number"
            min={0}
            value={minDuration}
            onChange={(e) => setMinDuration(Math.max(0, Number(e.target.value) || 0))}
            className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg"
          />
        </div>
        <button
          onClick={loadDetail}
          disabled={loading}
          className="w-full py-2 bg-emerald-600 hover:bg-emerald-700 text-white text-sm font-semibold rounded-lg shadow-sm transition disabled:opacity-50"
        >
          {loading ? "Đang tải..." : "Lọc buổi học"}
        </button>
      </div>

      {/* Thẻ thống kê */}
      <div className="grid grid-cols-2 gap-4">
        <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm">
          <span className="text-xs font-semibold text-slate-500">Số buổi học</span>
          <p className="text-2xl font-bold text-slate-800 mt-1">{data?.total_sessions ?? 0} buổi</p>
        </div>
        <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm">
          <span className="text-xs font-semibold text-slate-500">Tổng thời gian</span>
          <p className="text-2xl font-bold text-emerald-600 mt-1">{formatDuration(data?.total_duration_minutes ?? 0)}</p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Bảng danh sách buổi học */}
        <div className="lg:col-span-2 bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
          <div className="px-5 py-3.5 border-b border-slate-100 font-bold text-slate-800">Các buổi học</div>
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead className="bg-slate-50 text-slate-500 font-semibold border-b border-slate-200">
                <tr>
                  <th className="py-2.5 px-4">Thời gian học</th>
                  <th className="py-2.5 px-4">Thời lượng</th>
                  <th className="py-2.5 px-4">Người tham gia</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {(!data?.meetings || data.meetings.length === 0) ? (
                  <tr>
                    <td colSpan={3} className="py-6 text-center text-slate-400">Chưa có buổi học nào</td>
                  </tr>
                ) : (
                  data.meetings.map((m: any, idx: number) => (
                    <tr key={idx} className="hover:bg-slate-50">
                      <td className="py-3 px-4">
                        <div className="font-semibold text-slate-800">{formatDateTime(m.started_at)}</div>
                        <small className="text-slate-400">Đến {formatDateTime(m.ended_at)}</small>
                      </td>
                      <td className="py-3 px-4 font-semibold text-slate-700">
                        {formatDuration(calculateMinutes(m.started_at, m.ended_at))}
                      </td>
                      <td className="py-3 px-4 text-xs text-slate-600">
                        {m.participants?.map((p: any, i: number) => (
                          <div key={i}>{p.name} ({formatDuration(p.duration)})</div>
                        )) || "—"}
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Form Cài đặt học sinh */}
        <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm space-y-4 h-fit">
          <h3 className="font-bold text-slate-800">Cài đặt học sinh</h3>
          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1">Tên học sinh</label>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg"
            />
          </div>
          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1">Google Space ID</label>
            <input
              type="text"
              value={space}
              readOnly
              className="w-full px-3 py-2 text-sm border border-slate-200 bg-slate-50 text-slate-500 rounded-lg font-mono text-xs"
            />
          </div>
          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1">Ngày bắt đầu chu kỳ (1 - 31)</label>
            <input
              type="number"
              min={1}
              max={31}
              value={cycleDay}
              onChange={(e) => setCycleDay(Number(e.target.value))}
              className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg"
            />
          </div>
          <button
            onClick={handleUpdate}
            className="w-full flex items-center justify-center gap-2 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-sm font-semibold transition"
          >
            <Save size={16} /> Lưu thay đổi
          </button>
        </div>
      </div>
    </div>
  );
};