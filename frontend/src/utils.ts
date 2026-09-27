// Chuyển đổi phút sang dạng "X giờ Y phút"
export function formatDuration(minutes: number): string {
  if (!minutes || minutes <= 0) return "0 phút";
  const h = Math.floor(minutes / 60);
  const m = minutes % 60;
  if (h === 0) return `${m} phút`;
  if (m === 0) return `${h} giờ`;
  return `${h} giờ ${m} phút`;
}

// Định dạng thời gian theo chuẩn giờ Việt Nam (dd/mm/yyyy hh:mm)
export function formatDateTime(dateStr: string): string {
  if (!dateStr) return "";
  const d = new Date(dateStr);
  return d.toLocaleString("vi-VN", {
    timeZone: "Asia/Ho_Chi_Minh",
    hour: "2-digit", minute: "2-digit",
    day: "2-digit", month: "2-digit", year: "numeric",
    hour12: false
  });
}

// Lấy mốc thời gian ISO cho ngày bắt đầu / kết thúc tại Việt Nam (+07:00)
export function vietnamDayBoundaryISO(
  date: Date | string,
  endOfDay: boolean
): string {
  const dateStr = typeof date === "string"
    ? date
    : formatDateToInput(date);

  return `${dateStr}T${endOfDay ? "23:59:59" : "00:00:00"}+07:00`;
}

// Tính khoảng cách phút giữa hai mốc thời gian
export function calculateMinutes(startStr: string, endStr: string): number {
  if (!startStr || !endStr) return 0;
  return Math.max(0, Math.round((new Date(endStr).getTime() - new Date(startStr).getTime()) / 60000));
}

// Làm sạch link YouTube (loại bỏ tham số list, timestamp)
export function cleanYouTubeURL(urlStr: string): string {
  try {
    const u = new URL(urlStr);
    if (u.hostname.includes("youtube.com") && u.searchParams.has("v")) {
      return `https://www.youtube.com/watch?v=${u.searchParams.get("v")}`;
    }
  } catch (_) {}
  return urlStr;
}

export function normalizeError(err: any): string {
  if (!err) return "Không rõ lỗi";
  if (typeof err === "string") return err;
  return err.message || JSON.stringify(err);
}
// 1. Hàm định dạng Date object thành chuỗi "YYYY-MM-DD" cho thẻ <input type="date">
export function formatDateToInput(d: Date): string {
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

// 2. Hàm tự động tính: "Từ ngày (hôm nay - 30 ngày)" và "Đến ngày (hôm nay)"
export function getCurrentMonthRange(): { from: Date; to: Date } {
  const now = new Date();

  const from = new Date(
    now.getFullYear(),
    now.getMonth(),
    1,
    0, 0, 0, 0
  );

  const to = new Date(now);

  return { from, to };
}