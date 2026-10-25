import React, { useState, useEffect } from 'react';
import { api } from '../../api';
import { formatDateTime, normalizeError } from '../../utils';
import { V2CreateLesson, V2UploadDocuments } from '../../../wailsjs/go/wails/App';
import { wails } from '../../../wailsjs/go/models';
import { 
  Sparkles, 
  Play, 
  FileText, 
  RefreshCw, 
  UploadCloud, 
  X, 
  CheckCircle2,
  Video,
  Plus
} from 'lucide-react';

interface LessonsViewProps {
  onOpenEditor: (draftId: string) => void;
  onRetryPDF: (draft: any) => void;
  onOpenErrorModal: (draft: any) => void;
  showToast: (msg: string, isError?: boolean) => void;
}

const DEFAULT_PIPELINE_MODEL = 'gemma-4-31b';

export const LessonsView: React.FC<LessonsViewProps> = ({ 
  onOpenEditor, 
  onRetryPDF: _onRetryPDF, 
  onOpenErrorModal, 
  showToast 
}) => {
  const [drafts, setDrafts] = useState<any[]>([]);
  const [documents, setDocuments] = useState<any[]>([]);
  
  // State Form
  const [title, setTitle] = useState('');
  const [selectedDocIds, setSelectedDocIds] = useState<string[]>([]);
  const [youtubeUrls, setYoutubeUrls] = useState<string[]>([]);
  const [currentUrl, setCurrentUrl] = useState('');
  const [prompt, setPrompt] = useState('');
  
  const [creating, setCreating] = useState(false);
  const [uploadingDoc, setUploadingDoc] = useState(false);

  // Tải danh sách lịch sử bài giảng và kho tài liệu PDF
  const loadData = async () => {
    loadDrafts();
    loadDocuments();
  };

  const loadDrafts = async () => {
    try {
      const dList = await api.listLessonDrafts();
      setDrafts(dList || []);
    } catch (err) {
      console.error('Lỗi tải danh sách drafts:', err);
    }
  };

  const loadDocuments = async () => {
    try {
      if (api.listDocuments) {
        const docs = await api.listDocuments();
        setDocuments(docs || []);
      }
    } catch (err) {
      console.error('Lỗi tải danh sách documents:', err);
    }
  };

  useEffect(() => {
    loadData();
    const interval = setInterval(loadDrafts, 3000);
    return () => clearInterval(interval);
  }, []);

  // Mở hộp thoại native chọn file PDF từ máy tính
  const handlePickAndUploadDocument = async () => {
    try {
      setUploadingDoc(true);
      const uploadedDocs = await V2UploadDocuments();
      if (!uploadedDocs?.length) return;

      showToast(`Đã nạp ${uploadedDocs.length} file PDF`);
      await loadDocuments();
      setSelectedDocIds((current) => [
        ...current,
        ...uploadedDocs.filter((doc) => doc.id).map((doc) => String(doc.id)),
      ]);
    } catch (err) {
      showToast('Lỗi khi tải tài liệu: ' + normalizeError(err), true);
    } finally {
      setUploadingDoc(false);
    }
  };

  // Thêm / bớt link YouTube
  const handleAddYoutubeUrl = () => {
    const trimmed = currentUrl.trim();
    if (!trimmed) return;
    if (!trimmed.includes('youtube.com') && !trimmed.includes('youtu.be')) {
      showToast('Chỉ chấp nhận link từ YouTube (youtube.com hoặc youtu.be)', true);
      return;
    }
    if (youtubeUrls.includes(trimmed)) {
      showToast('Link video này đã được thêm trong danh sách', true);
      return;
    }
    setYoutubeUrls((current) => [...current, trimmed]);
    setCurrentUrl('');
  };

  const handleRemoveYoutubeUrl = (index: number) => {
    setYoutubeUrls((current) => current.filter((_, i) => i !== index));
  };

  // Gửi lệnh tạo bài giảng tới Backend
  const handleCreateLesson = async () => {
    if (!title.trim()) {
      showToast('Vui lòng nhập tiêu đề bài giảng', true);
      return;
    }

    if (selectedDocIds.length === 0 && youtubeUrls.length === 0) {
      showToast('Vui lòng chọn ít nhất một file PDF hoặc thêm link video YouTube', true);
      return;
    }

    setCreating(true);
    try {
      const request = new wails.GenerateLessonRequest({
        title: title.trim(),
        model: DEFAULT_PIPELINE_MODEL,
        prompt: prompt.trim(),
        url: youtubeUrls[0] || '', // Fallback link đầu tiên cho code cũ
        urls: youtubeUrls,         // Danh sách đầy đủ nhiều video YouTube
        document_id: selectedDocIds[0] || '',
        document_ids: selectedDocIds,
        pages: [], // Rỗng quy ước lấy trọn vẹn file PDF
      });

      await V2CreateLesson(request);
      showToast('Đã gửi yêu cầu! AI Pipeline đang phân tích tài liệu và biên soạn bài giảng...');
      
      // Reset form sau khi gửi thành công
      setTitle('');
      setSelectedDocIds([]);
      setYoutubeUrls([]);
      setCurrentUrl('');
      setPrompt('');
      loadDrafts();
    } catch (err) {
      showToast('Lỗi tạo bài giảng: ' + normalizeError(err), true);
    } finally {
      setCreating(false);
    }
  };

  // Nạp lại dữ liệu bài cũ
  const handleRetry = (draft: any) => {
    setTitle(draft.title || '');
    setPrompt(draft.custom_prompt || '');

    if (Array.isArray(draft.materials) && draft.materials.length > 0) {
      const pdfMats = draft.materials.filter((m: any) => m.type === 'pdf');
      const pdfIds = pdfMats.flatMap((material: any) => {
        const ids = Array.isArray(material.pdf_document_id) ? material.pdf_document_id : [material.pdf_document_id];
        return ids.filter(Boolean).map(String);
      });
      setSelectedDocIds(pdfIds);

      const ytMats = draft.materials.filter((m: any) => m.type === 'youtube');
      const urls = ytMats.map((m: any) => m.source_url).filter(Boolean);
      setYoutubeUrls(urls);
    } else {
      if (draft.source_type?.toLowerCase() === 'pdf') {
        setSelectedDocIds(draft.pdf_document_id ? [String(draft.pdf_document_id)] : []);
        setYoutubeUrls([]);
      } else if (draft.source_type?.toLowerCase() === 'youtube' && draft.source_url) {
        setSelectedDocIds([]);
        setYoutubeUrls([draft.source_url]);
      } else {
        setSelectedDocIds([]);
        setYoutubeUrls([]);
      }
    }

    showToast('Đã nạp lại thông tin bài giảng.');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const selectedDocInfos = documents.filter((d) => selectedDocIds.includes(String(d.id)));

  return (
    <div className="p-8 space-y-8 max-w-7xl mx-auto">
      <div>
        <span className="text-xs font-semibold text-emerald-600 uppercase tracking-wider">Trợ lý Sư phạm AI</span>
        <h1 className="text-2xl font-bold text-slate-800">Biên soạn Giáo án & Bài tập từ PDF</h1>
      </div>

      {/* Form tạo bài mới */}
      <div className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm space-y-6">
        <div>
          <h3 className="text-lg font-bold text-slate-800 flex items-center gap-2">
            <Sparkles className="text-emerald-600" size={20} /> Tạo bài giảng mới
          </h3>
          <p className="text-sm text-slate-500 mt-1">
            Cung cấp <strong>Tài liệu PDF</strong> (sách giáo khoa, chuyên đề, đề thi) để AI tự động phân tích cấu trúc, thiết lập mục tiêu học tập và biên tập giáo án kèm bài tập giàn giáo.
          </p>
        </div>

        {/* 1. Tiêu đề bài giảng */}
        <div>
          <label className="block text-xs font-semibold text-slate-700 mb-1">
            Tiêu đề bài giảng <span className="text-red-500">*</span>
          </label>
          <input
            type="text"
            placeholder="Ví dụ: Chuyên đề Hệ trục tọa độ Oxyz và các phép toán Vectơ..."
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            className="w-full px-3.5 py-2.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500 shadow-xs"
          />
        </div>

        {/* 2. KHU VỰC TÀI LIỆU PDF ĐẦU VÀO */}
        <div className="border border-slate-200 rounded-xl p-5 bg-slate-50/50 space-y-3">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-slate-700 uppercase tracking-wider flex items-center gap-1.5">
              <FileText size={15} className="text-blue-600" /> Tài liệu PDF nguồn <span className="text-red-500">*</span>
            </span>
            <span className="text-[11px] text-slate-500 italic">
              * Tối thiểu 1 file PDF tham khảo
            </span>
          </div>

          <div className={`p-4 rounded-lg border transition ${
            selectedDocIds.length > 0 ? 'bg-blue-50/40 border-blue-200' : 'bg-white border-slate-200'
          }`}>
            <div className="flex flex-col sm:flex-row gap-3">
              <select
                value=""
                onChange={(e) => {
                  if (e.target.value && !selectedDocIds.includes(e.target.value)) {
                    setSelectedDocIds((current) => [...current, e.target.value]);
                  }
                }}
                className="flex-1 px-3 py-2 text-sm border border-slate-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-blue-400"
              >
                <option value="">-- Chọn file PDF từ kho lưu trữ --</option>
                {documents.map((doc: any) => (
                  <option key={String(doc.id)} value={String(doc.id)}>
                    {doc.file_name} ({doc.page_count} trang)
                  </option>
                ))}
              </select>

              <button
                type="button"
                onClick={handlePickAndUploadDocument}
                disabled={uploadingDoc}
                className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-xs font-semibold whitespace-nowrap flex items-center justify-center gap-1.5 transition shadow-xs disabled:opacity-50"
              >
                <UploadCloud size={15} /> {uploadingDoc ? 'Đang đọc...' : 'Nạp file PDF từ máy tính'}
              </button>
            </div>

            {/* Danh sách các file PDF đã chọn */}
            {selectedDocInfos.length > 0 ? (
              <div className="mt-3 pt-3 border-t border-blue-100 flex flex-wrap gap-2">
                {selectedDocInfos.map((doc) => (
                  <span
                    key={String(doc.id)}
                    className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md bg-blue-100/70 border border-blue-200 text-blue-900 text-xs font-medium"
                  >
                    <CheckCircle2 size={13} className="text-blue-600" />
                    <span>{doc.file_name} ({doc.page_count} trang)</span>
                    <button
                      type="button"
                      onClick={() => setSelectedDocIds((current) => current.filter((id) => id !== String(doc.id)))}
                      className="ml-0.5 text-blue-400 hover:text-red-600"
                      aria-label={`Bỏ ${doc.file_name}`}
                    >
                      <X size={13} />
                    </button>
                  </span>
                ))}
              </div>
            ) : (
              <p className="text-[11px] text-slate-500 mt-2">
                AI sẽ trích xuất lý thuyết, phân tích các dạng toán và ví dụ mẫu trực tiếp từ file PDF này.
              </p>
            )}
          </div>
        </div>

        {/* 2.2. KHU VỰC VIDEO BÀI GIẢNG YOUTUBE */}
        <div className="border border-slate-200 rounded-xl p-5 bg-slate-50/50 space-y-3">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-slate-700 uppercase tracking-wider flex items-center gap-1.5">
              <Video size={15} className="text-red-600" /> Video Bài giảng YouTube (Đa nguồn / Mẹo giải nhanh)
            </span>
            <span className="text-[11px] text-slate-500 italic">
              * Tùy chọn (kết hợp với PDF hoặc chạy độc lập)
            </span>
          </div>

          <div className={`p-4 rounded-lg border transition ${
            youtubeUrls.length > 0 ? 'bg-red-50/40 border-red-200' : 'bg-white border-slate-200'
          }`}>
            <div className="flex flex-col sm:flex-row gap-2">
              <input
                type="text"
                placeholder="Dán link YouTube (VD: https://www.youtube.com/watch?v=... hoặc https://youtu.be/...)"
                value={currentUrl}
                onChange={(e) => setCurrentUrl(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter') {
                    e.preventDefault();
                    handleAddYoutubeUrl();
                  }
                }}
                className="flex-1 px-3 py-2 text-sm border border-slate-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-red-400"
              />
              <button
                type="button"
                onClick={handleAddYoutubeUrl}
                className="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg text-xs font-semibold whitespace-nowrap flex items-center justify-center gap-1.5 transition shadow-xs"
              >
                <Plus size={15} /> Thêm Video
              </button>
            </div>

            {/* Danh sách các video YouTube đã thêm */}
            {youtubeUrls.length > 0 ? (
              <div className="mt-3 pt-3 border-t border-red-100 flex flex-wrap gap-2">
                {youtubeUrls.map((url, idx) => (
                  <span
                    key={idx}
                    className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md bg-red-100/70 border border-red-200 text-red-900 text-xs font-medium max-w-full"
                  >
                    <Play size={12} className="text-red-600 fill-red-600 shrink-0" />
                    <span className="truncate max-w-xs">{url}</span>
                    <button
                      type="button"
                      onClick={() => handleRemoveYoutubeUrl(idx)}
                      className="ml-1 text-red-400 hover:text-red-700"
                      aria-label={`Xóa video ${url}`}
                    >
                      <X size={13} />
                    </button>
                  </span>
                ))}
              </div>
            ) : (
              <p className="text-[11px] text-slate-500 mt-2">
                AI sẽ tự động cào bản chép lời (transcript), trích xuất các mẹo giải nhanh, phương pháp Casio và tự động nén thành tài liệu học tập chuẩn N-Up 4.
              </p>
            )}
          </div>
        </div>

        {/* 3. Yêu cầu Prompt riêng */}
        <div>
          <label className="block text-xs font-semibold text-slate-700 mb-1">
            Yêu cầu sư phạm tùy chỉnh (Prompt riêng)
          </label>
          <textarea
            rows={2}
            placeholder="Ví dụ: Tập trung phân dạng chi tiết, sinh 4 bài tập tự luyện bậc thang từ dễ đến vận dụng cho mỗi dạng..."
            value={prompt}
            onChange={(e) => setPrompt(e.target.value)}
            className="w-full px-3.5 py-2 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500 shadow-xs"
          />
        </div>

        {/* Nút Submit */}
        <button
          onClick={handleCreateLesson}
          disabled={creating || uploadingDoc}
          className="flex items-center gap-2 px-6 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg font-semibold text-sm shadow-sm transition disabled:opacity-50"
        >
          <Sparkles size={16} /> {creating ? 'Đang gửi yêu cầu...' : 'Bắt đầu tạo bài giảng'}
        </button>
      </div>

      {/* Bảng lịch sử bài giảng */}
      <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div className="px-6 py-4 border-b border-slate-100 flex justify-between items-center">
          <h3 className="font-bold text-slate-800">Lịch sử bài giảng đã biên soạn</h3>
          <span className="text-xs px-2.5 py-1 bg-slate-100 text-slate-600 rounded-full font-semibold">
            {drafts.length} bài
          </span>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="bg-slate-50 text-slate-500 font-semibold border-b border-slate-200">
              <tr>
                <th className="py-3 px-5">Bài giảng</th>
                <th className="py-3 px-5">Tài liệu nguồn</th>
                <th className="py-3 px-5">Yêu cầu Prompt</th>
                <th className="py-3 px-5">Thời gian</th>
                <th className="py-3 px-5">Trạng thái</th>
                <th className="py-3 px-5 text-right">Thao tác</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {drafts.length === 0 ? (
                <tr>
                  <td colSpan={6} className="py-8 text-center text-slate-400">
                    Chưa có bài giảng nào được tạo
                  </td>
                </tr>
              ) : (
                drafts.map((d: any) => {
                  const hasMaterials = Array.isArray(d.materials) && d.materials.length > 0;

                  return (
                    <tr key={d.id} className="hover:bg-slate-50">
                      {/* Tiêu đề */}
                      <td className="py-3.5 px-5 font-semibold text-slate-800">
                        {d.title || 'Chưa có tiêu đề'}
                      </td>

                      {/* Hiển thị Nguồn tài liệu */}
                      <td className="py-3.5 px-5">
                        {hasMaterials ? (
                          <div className="flex flex-col gap-1.5">
                            {d.materials.map((m: any, idx: number) => (
                              <span 
                                key={idx} 
                                className="inline-flex items-center gap-1.5 text-xs text-slate-700 font-mono"
                              >
                                {m.type === 'youtube' && (
                                  <>
                                    <span className="p-1 rounded bg-red-50 text-red-600"><Play size={10} /></span>
                                    <span className="truncate max-w-[180px]">{m.url}</span>
                                  </>
                                )}
                                {m.type === 'pdf' && (
                                  <>
                                    <span className="p-1 rounded bg-blue-50 text-blue-600"><FileText size={10} /></span>
                                    <span className="truncate max-w-[180px]">{m.pdf_file_name || 'Tài liệu PDF'}</span>
                                  </>
                                )}
                              </span>
                            ))}
                          </div>
                        ) : (
                          <small className="text-slate-400 font-mono text-xs">
                            {d.source_url || (d.source_type?.toUpperCase() === 'PDF' ? d.pdf_file_name : 'Nguồn khác')}
                          </small>
                        )}
                      </td>

                      <td className="py-3.5 px-5 text-xs text-slate-600 max-w-xs truncate">
                        {d.custom_prompt || 'Mặc định'}
                      </td>
                      <td className="py-3.5 px-5 text-xs text-slate-500">
                        {formatDateTime(d.created_at)}
                      </td>

                      {/* Trạng thái */}
                      <td className="py-3.5 px-5">
                        {d.status === 'processing' && (
                          <span className="px-2 py-0.5 bg-amber-50 text-amber-600 border border-amber-200 rounded text-xs font-medium">
                            Đang phân tích...
                          </span>
                        )}
                        {d.status === 'completed' && (
                          <span className="px-2 py-0.5 bg-emerald-50 text-emerald-600 border border-emerald-200 rounded text-xs font-medium">
                            Đã hoàn thành
                          </span>
                        )}
                        {d.status === 'failed' && (
                          <div className="flex items-center gap-1.5 text-red-600 text-xs">
                            <span>Thất bại</span>
                            <button onClick={() => onOpenErrorModal(d)} className="underline text-[11px]">
                              Xem lỗi
                            </button>
                            <button
                              onClick={() => handleRetry(d)}
                              className="inline-flex items-center gap-1 text-emerald-700 hover:text-emerald-800 font-semibold"
                            >
                              <RefreshCw size={12} /> Nạp lại
                            </button>
                          </div>
                        )}
                      </td>

                      {/* Thao tác */}
                      <td className="py-3.5 px-5 text-right">
                        {d.status === 'completed' && (
                          <div className="flex justify-end items-center gap-2">
                            <button
                              onClick={() => handleRetry(d)}
                              className="inline-flex items-center gap-1 px-3 py-1 border border-emerald-200 text-emerald-700 hover:bg-emerald-50 rounded text-xs font-semibold"
                            >
                              <RefreshCw size={12} /> Nạp lại
                            </button>
                            <button
                              onClick={() => onOpenEditor(d.id)}
                              className="px-3 py-1 bg-emerald-600 hover:bg-emerald-700 text-white rounded text-xs font-semibold"
                            >
                              Sửa bài & Đẩy OneNote
                            </button>
                          </div>
                        )}
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};
