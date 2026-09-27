import React, { useState, useEffect } from 'react';
import { api } from '../../api';
import { cleanYouTubeURL, formatDateTime, normalizeError } from '../../utils';
import { V2CreateLesson } from '../../../wailsjs/go/wails/App';
import { wails } from '../../../wailsjs/go/models';
import { Sparkles, Play, Search, AlertCircle, RefreshCw } from 'lucide-react';

interface LessonsViewProps {
  onOpenEditor: (draftId: string) => void;
  onOpenErrorModal: (draft: any) => void;
  showToast: (msg: string, isError?: boolean) => void;
}

export const LessonsView: React.FC<LessonsViewProps> = ({ onOpenEditor, onOpenErrorModal, showToast }) => {
  const [drafts, setDrafts] = useState<any[]>([]);
  const [models, setModels] = useState<any[]>([]);
  const [selectedModel, setSelectedModel] = useState("gemini-3.7-flash");
  const [url, setUrl] = useState("");
  const [prompt, setPrompt] = useState("");
  const [creating, setCreating] = useState(false);

  // Tải danh sách model AI và lịch sử bài giảng
  const loadData = async () => {
    try {
      const mList = await api.listAIModels();
      if (mList && mList.length > 0) setModels(mList);
    } catch (_) {}

    loadDrafts();
  };

  const loadDrafts = async () => {
    try {
      const dList = await api.listLessonDrafts();
      setDrafts(dList || []);
    } catch (err) {
      console.error(err);
    }
  };

  // Khởi động chu kỳ Polling cập nhật trạng thái nếu có bài đang xử lý
  useEffect(() => {
    loadData();
    const interval = setInterval(() => {
      loadDrafts();
    }, 3000);
    return () => clearInterval(interval);
  }, []);

  // Gửi lệnh cho AI phân tích video YouTube và tạo bài giảng
  const handleCreateLesson = async () => {
    if (!url.trim()) {
      showToast("Vui lòng dán link YouTube", true);
      return;
    }
    const cleanUrl = cleanYouTubeURL(url.trim());
    setCreating(true);
    try {
      const request = new wails.GenerateLessonRequest({
        title: "",
        model: selectedModel,
        prompt: prompt.trim(),
      });
      request.url = cleanUrl;
      request.material = 'youtube';
      request.document_id = '';
      request.pages = [];
      await V2CreateLesson(request);
      showToast("Đã gửi yêu cầu! AI đang phân tích video...");
      setUrl("");
      setPrompt("");
      loadDrafts();
    } catch (err) {
      showToast("Lỗi tạo bài giảng: " + normalizeError(err), true);
    } finally {
      setCreating(false);
    }
  };

  return (
    <div className="p-8 space-y-8 max-w-7xl mx-auto">
      <div>
        <span className="text-xs font-semibold text-emerald-600 uppercase tracking-wider">Trợ lý AI</span>
        <h1 className="text-2xl font-bold text-slate-800">Soạn bài từ Video YouTube</h1>
      </div>

      {/* Form tạo bài mới */}
      <div className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm space-y-4">
        <h3 className="text-lg font-bold text-slate-800">Tạo bài giảng mới</h3>
        <p className="text-sm text-slate-500">AI sẽ tự động nghe video, tổng hợp nội dung chi tiết và sinh phiếu bài tập đục lỗ cho học sinh.</p>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1">Model AI</label>
            <select
              value={selectedModel}
              onChange={(e) => setSelectedModel(e.target.value)}
              className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg"
            >
              {models.length > 0 ? (
                models.map((m: any) => <option key={m.id} value={m.id}>{m.display_name || m.id}</option>)
              ) : (
                <option value="gemini-3.7-flash">gemini-3.7 Flash (Mặc định)</option>
              )}
            </select>
          </div>
          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1">Đường dẫn Video YouTube <span className="text-red-500">*</span></label>
            <input
              type="url"
              placeholder="https://www.youtube.com/watch?v=..."
              value={url}
              onChange={(e) => setUrl(e.target.value)}
              className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg"
            />
          </div>
          <div className="md:col-span-2">
            <label className="block text-xs font-semibold text-slate-600 mb-1">Yêu cầu tùy chỉnh (Prompt riêng)</label>
            <textarea
              rows={2}
              placeholder="Ví dụ: Tập trung vào giải các bài toán hình học không gian, giải thích dễ hiểu..."
              value={prompt}
              onChange={(e) => setPrompt(e.target.value)}
              className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg"
            />
          </div>
        </div>

        <button
          onClick={handleCreateLesson}
          disabled={creating}
          className="flex items-center gap-2 px-5 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg font-semibold text-sm shadow-sm transition disabled:opacity-50"
        >
          <Sparkles size={16} /> {creating ? "Đang gửi yêu cầu..." : "Bắt đầu tạo bài giảng"}
        </button>
      </div>

      {/* Bảng lịch sử */}
      <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div className="px-6 py-4 border-b border-slate-100 flex justify-between items-center">
          <h3 className="font-bold text-slate-800">Lịch sử tạo bài & Trạng thái Prompt</h3>
          <span className="text-xs px-2.5 py-1 bg-slate-100 text-slate-600 rounded-full font-semibold">{drafts.length} bài</span>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="bg-slate-50 text-slate-500 font-semibold border-b border-slate-200">
              <tr>
                <th className="py-3 px-5">Bài giảng / Video</th>
                <th className="py-3 px-5">Prompt</th>
                <th className="py-3 px-5">Model</th>
                <th className="py-3 px-5">Thời gian</th>
                <th className="py-3 px-5">Trạng thái</th>
                <th className="py-3 px-5 text-right">Thao tác</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {drafts.length === 0 ? (
                <tr>
                  <td colSpan={6} className="py-8 text-center text-slate-400">Chưa có bài giảng nào được tạo</td>
                </tr>
              ) : (
                drafts.map((d: any) => (
                  <tr key={d.id} className="hover:bg-slate-50">
                    <td className="py-3.5 px-5">
                      <strong className="text-slate-800">{d.title || "Chưa có tiêu đề"}</strong>
                      <br />
                      <small className="text-slate-400 font-mono text-xs">{d.source_url || "Nguồn khác"}</small>
                    </td>
                    <td className="py-3.5 px-5 text-xs text-slate-600 max-w-xs truncate">{d.custom_prompt || "Mặc định"}</td>
                    <td className="py-3.5 px-5 font-mono text-xs text-slate-500">{d.model}</td>
                    <td className="py-3.5 px-5 text-xs text-slate-500">{formatDateTime(d.created_at)}</td>
                    <td className="py-3.5 px-5">
                      {d.status === "processing" && <span className="px-2 py-0.5 bg-amber-50 text-amber-600 border border-amber-200 rounded text-xs">Đang phân tích...</span>}
                      {d.status === "completed" && <span className="px-2 py-0.5 bg-emerald-50 text-emerald-600 border border-emerald-200 rounded text-xs">Đã hoàn thành</span>}
                      {d.status === "failed" && (
                        <div className="flex items-center gap-1.5 text-red-600 text-xs">
                          <span>Thất bại</span>
                          <button onClick={() => onOpenErrorModal(d)} className="underline text-[11px]">Xem lỗi</button>
                        </div>
                      )}
                    </td>
                    <td className="py-3.5 px-5 text-right">
                      {d.status === "completed" && (
                        <button
                          onClick={() => onOpenEditor(d.id)}
                          className="px-3 py-1 bg-emerald-600 hover:bg-emerald-700 text-white rounded text-xs font-semibold"
                        >
                          Sửa bài & Đẩy OneNote
                        </button>
                      )}
                    </td>
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