import React, { useState, useEffect } from 'react';
import { api } from '../../api';
import { formatDuration, vietnamDayBoundaryISO, normalizeError, getCurrentMonthRange } from '../../utils';
import { RotateCw, Search } from 'lucide-react';

interface DashboardViewProps {
  onSelectStudent: (id: string, fromDate: Date, toDate: Date) => void;
  showToast: (msg: string, isError?: boolean) => void;
}

// Helper: chuyển Date thành chuỗi "YYYY-MM-DD" để gắn vào <input type="date">
const formatDateToInput = (d: Date): string => {
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

export const DashboardView: React.FC<DashboardViewProps> = ({ onSelectStudent, showToast }) => {
  const [loading, setLoading] = useState(false);
  const [syncing, setSyncing] = useState(false);
  const [data, setData] = useState<any>(null);
  const [statusMsg, setStatusMsg] = useState("Sẵn sàng xem thống kê.");

  // Bộ lọc
  const [search, setSearch] = useState("");
  const [month, setMonth] = useState("");
  const [selectedRange, setSelectedRange] = useState<{ from: Date; to: Date } | null>(null);
  const [minDuration, setMinDuration] = useState(30);

  // Khởi tạo ngày mặc định (Đầu tháng đến ngày hiện tại)
  useEffect(() => {
    const range = getCurrentMonthRange();
    // Đảm bảo là đối tượng Date
    const from = new Date(range.from);
    const to = new Date(range.to);

    setSelectedRange({ from, to });

    const now = new Date();
    setMonth(`${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`);

    // Tải dữ liệu ban đầu
    loadDashboard(from, to, minDuration, "");
  }, []);

  // Tải dữ liệu thống kê từ Backend nhận Date
  const loadDashboard = async (
    customFrom?: Date,
    customTo?: Date,
    min = minDuration,
    sName = search
  ) => {
    const finalFrom = customFrom || selectedRange?.from;
    const finalTo = customTo || selectedRange?.to;

    if (!finalFrom || !finalTo) return;

    setLoading(true);
    setStatusMsg(`Đang tải thống kê từ hệ thống (${formatDateToInput(finalFrom)} đến ${formatDateToInput(finalTo)})...`);
    
    try {
      const res = await api.getDashboard({
        from_date: vietnamDayBoundaryISO(finalFrom, false),
        to_date: vietnamDayBoundaryISO(finalTo, true),
        min_duration_minutes: Number(min) || 0,
        search_name: sName.trim()
      });
      setData(res || {});
      setStatusMsg(`Đã tải thành công: ${res?.total_students || 0} học sinh, ${res?.total_sessions || 0} buổi.`);
    } catch (err) {
      const msg = normalizeError(err);
      setStatusMsg(`Lỗi tải thống kê: ${msg}`);
      showToast("Lỗi tải danh sách: " + msg, true);
    } finally {
      setLoading(false);
    }
  };

  // Đồng bộ lịch dạy từ Google Meet
  const handleSyncMeet = async () => {
    setSyncing(true);
    try {
      await api.syncMeetings();
      showToast("Đồng bộ Google Meet thành công!");
      if (selectedRange) {
        await loadDashboard(selectedRange.from, selectedRange.to);
      }
    } catch (err) {
      showToast("Đồng bộ thất bại: " + normalizeError(err), true);
    } finally {
      setSyncing(false);
    }
  };

  // Khi chọn input type="month"
  const handleMonthChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value;
    setMonth(val);
    if (!val) return;

    const [y, m] = val.split("-").map(Number);
    const newFrom = new Date(y, m - 1, 1, 0, 0, 0);
    const newTo = new Date(y, m, 0, 23, 59, 59); // Ngày cuối cùng của tháng

    setSelectedRange({ from: newFrom, to: newTo });
    loadDashboard(newFrom, newTo, minDuration, search);
  };

  return (
    <div className="p-8 space-y-6 max-w-7xl mx-auto">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <span className="text-xs font-semibold text-emerald-600 uppercase tracking-wider">Quản lý lớp</span>
          <h1 className="text-2xl font-bold text-slate-800">Sổ buổi học</h1>
        </div>
        <button
          onClick={handleSyncMeet}
          disabled={syncing}
          className="flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium shadow-sm transition disabled:opacity-50"
        >
          <RotateCw size={16} className={syncing ? "animate-spin" : ""} />
          <span>{syncing ? "Đang đồng bộ..." : "Đồng bộ Google Meet"}</span>
        </button>
      </div>

      {/* Bộ lọc */}
      <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm grid grid-cols-1 md:grid-cols-6 gap-4 items-end">
        <div className="md:col-span-2">
          <label className="block text-xs font-semibold text-slate-600 mb-1">Tìm học sinh</label>
          <div className="relative">
            <input
              type="text"
              placeholder="Nhập tên học sinh..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && loadDashboard()}
              className="w-full pl-9 pr-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            />
            <Search size={16} className="absolute left-3 top-2.5 text-slate-400" />
          </div>
        </div>
        <div>
          <label className="block text-xs font-semibold text-slate-600 mb-1">Tháng</label>
          <input
            type="month"
            value={month}
            onChange={handleMonthChange}
            className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:outline-none"
          />
        </div>
        <div>
          <label className="block text-xs font-semibold text-slate-600 mb-1">Từ ngày</label>
          <input
            type="date"
            value={selectedRange?.from ? formatDateToInput(selectedRange.from) : ""}
            onChange={(e) => {
              if (!e.target.value) return;
              const [y, m, d] = e.target.value.split("-").map(Number);
              const newFrom = new Date(y, m - 1, d, 0, 0, 0);
              const newRange = { from: newFrom, to: selectedRange?.to || newFrom };
              setSelectedRange(newRange);
            }}
            className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg"
          />
        </div>
        <div>
          <label className="block text-xs font-semibold text-slate-600 mb-1">Đến ngày</label>
          <input
            type="date"
            value={selectedRange?.to ? formatDateToInput(selectedRange.to) : ""}
            onChange={(e) => {
              if (!e.target.value) return;
              const [y, m, d] = e.target.value.split("-").map(Number);
              const newTo = new Date(y, m - 1, d, 23, 59, 59);
              const newRange = { from: selectedRange?.from || newTo, to: newTo };
              setSelectedRange(newRange);
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
        <div>
          <button
            onClick={() => loadDashboard()}
            disabled={loading}
            className="w-full py-2 bg-emerald-600 hover:bg-emerald-700 text-white text-sm font-semibold rounded-lg shadow-sm transition disabled:opacity-50"
          >
            {loading ? "Đang tải..." : "Xem thống kê"}
          </button>
        </div>
      </div>

      {/* Banner trạng thái */}
      <div className={`p-3 text-sm rounded-lg border ${
        statusMsg.includes("Lỗi") ? "bg-red-50 text-red-700 border-red-200" : "bg-blue-50 text-blue-700 border-blue-200"
      }`}>
        {statusMsg}
      </div>

      {/* Các thẻ tổng kết số liệu */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
        <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm">
          <span className="text-xs font-semibold text-slate-500 uppercase">Học sinh</span>
          <p className="text-3xl font-extrabold text-slate-800 mt-1">{data?.total_students ?? 0}</p>
        </div>
        <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm">
          <span className="text-xs font-semibold text-slate-500 uppercase">Tổng số buổi hợp lệ</span>
          <p className="text-3xl font-extrabold text-slate-800 mt-1">{data?.total_sessions ?? 0}</p>
        </div>
        <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm">
          <span className="text-xs font-semibold text-slate-500 uppercase">Tổng thời lượng dạy</span>
          <p className="text-3xl font-extrabold text-emerald-600 mt-1">{formatDuration(data?.total_duration_minutes ?? 0)}</p>
        </div>
      </div>

      {/* Bảng danh sách học sinh */}
      <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div className="px-6 py-4 border-b border-slate-100 flex justify-between items-center">
          <h3 className="font-bold text-slate-800">Danh sách học sinh</h3>
          <span className="text-xs px-2.5 py-1 bg-slate-100 text-slate-600 rounded-full font-semibold">
            {data?.students?.length ?? 0} học sinh
          </span>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="bg-slate-50 text-slate-500 font-semibold border-b border-slate-200">
              <tr>
                <th className="py-3 px-6">Học sinh</th>
                <th className="py-3 px-6">Lịch / Mã Meet</th>
                <th className="py-3 px-6">Ngày bắt đầu chu kỳ</th>
                <th className="py-3 px-6">Số buổi</th>
                <th className="py-3 px-6">Tổng thời lượng</th>
                <th className="py-3 px-6"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {(!data?.students || data.students.length === 0) ? (
                <tr>
                  <td colSpan={6} className="py-8 text-center text-slate-400">Không tìm thấy dữ liệu phù hợp</td>
                </tr>
              ) : (
                data.students.map((s: any) => (
                  <tr
                    key={s.id}
                    // Truyền đủ id, fromDate, toDate dạng Date vào prop onSelectStudent
                    onClick={() => {
                      if (selectedRange) {
                        onSelectStudent(s.id, selectedRange.from, selectedRange.to);
                      }
                    }}
                    className="hover:bg-slate-50/80 cursor-pointer transition"
                  >
                    <td className="py-3.5 px-6 font-semibold text-slate-800">{s.name}</td>
                    <td className="py-3.5 px-6 text-slate-600 font-mono text-xs">{s.space_name || s.meeting_code || s.class}</td>
                    <td className="py-3.5 px-6 text-slate-600">Ngày {s.cycle_start_day} hàng tháng</td>
                    <td className="py-3.5 px-6 font-semibold text-emerald-600">{s.total_sessions} buổi</td>
                    <td className="py-3.5 px-6 text-slate-600">{formatDuration(s.total_duration_minutes)}</td>
                    <td className="py-3.5 px-6 text-emerald-600 font-bold">→</td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};
