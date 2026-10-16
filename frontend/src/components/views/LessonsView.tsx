import React, { useState, useEffect } from 'react';
import { api } from '../../api';
import { cleanYouTubeURL, formatDateTime, normalizeError } from '../../utils';
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
  Layers,
  HelpCircle
} from 'lucide-react';

interface LessonsViewProps {
  onOpenEditor: (draftId: string) => void;
  onRetryPDF: (draft: any) => void;
  onOpenErrorModal: (draft: any) => void;
  showToast: (msg: string, isError?: boolean) => void;
}

export const LessonsView: React.FC<LessonsViewProps> = ({ 
  onOpenEditor, 
  onRetryPDF, 
  onOpenErrorModal, 
  showToast 
}) => {
  const [drafts, setDrafts] = useState<any[]>([]);
  const [models, setModels] = useState<any[]>([]);
  const [documents, setDocuments] = useState<any[]>([]);
  const [selectedModel, setSelectedModel] = useState("gemini-3.7-flash");
  
  // State Form
  const [title, setTitle] = useState("");
  const [url, setUrl] = useState("");
  const [selectedDocIds, setSelectedDocIds] = useState<string[]>([]);
  const [prompt, setPrompt] = useState("");
  
  const [creating, setCreating] = useState(false);
  const [uploadingDoc, setUploadingDoc] = useState(false);

  // Tải danh sách model AI, lịch sử bài giảng và kho tài liệu PDF
  const loadData = async () => {
    try {
      const mList = await api.listAIModels();
      if (mList && mList.length > 0) setModels(mList);
    } catch (_) {}

    loadDrafts();
    loadDocuments();
  };

  const loadDrafts = async () => {
    try {
      const dList = await api.listLessonDrafts();
      setDrafts(dList || []);
    } catch (err) {
      console.error(err);
    }
  };

  const loadDocuments = async () => {
    try {
      if (api.listDocuments) {
        const docs = await api.listDocuments();
        setDocuments(docs || []);
      }
    } catch (err) {
      console.error("Lỗi tải danh sách documents:", err);
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
      showToast("Lỗi khi tải tài liệu: " + normalizeError(err), true);
    } finally {
      setUploadingDoc(false);
    }
  };

  // Gửi lệnh tạo bài giảng tới Backend
  const handleCreateLesson = async () => {
    if (!title.trim()) {
      showToast("Vui lòng nhập tiêu đề bài giảng", true);
      return;
    }

    const hasYouTube = !!url.trim();
    const hasPDF = selectedDocIds.length > 0;

    // Bắt buộc phải có ít nhất 1 nguồn tài liệu
    if (!hasYouTube && !hasPDF) {
      showToast("Vui lòng cung cấp ít nhất một tài liệu (dán link YouTube hoặc chọn file PDF)", true);
      return;
    }

    setCreating(true);
    try {
      const request = new wails.GenerateLessonRequest({
        title: title.trim(),
        model: selectedModel,
        prompt: prompt.trim(),
        url: hasYouTube ? cleanYouTubeURL(url.trim()) : '',
        document_id: selectedDocIds[0] || '',
        document_ids: selectedDocIds,
        pages: [], // Rỗng quy ước lấy trọn vẹn file PDF
      });

      await V2CreateLesson(request);

      if (hasYouTube && hasPDF) {
        showToast("Đã gửi yêu cầu! AI đang kết hợp phân tích cả Video và file PDF...");
      } else {
        showToast("Đã gửi yêu cầu! AI đang phân tích tài liệu và soạn bài...");
      }
      
      // Reset form sau khi gửi thành công
      setTitle("");
      setUrl("");
      setSelectedDocIds([]);
      setPrompt("");
      loadDrafts();
    } catch (err) {
      showToast("Lỗi tạo bài giảng: " + normalizeError(err), true);
    } finally {
      setCreating(false);
    }
  };

  // Nạp lại dữ liệu bài cũ (Hỗ trợ nạp lại cả 2 nguồn nếu bài cũ có cả 2)
  const handleRetry = (draft: any) => {
    setTitle(draft.title || '');
    setPrompt(draft.custom_prompt || '');
    setSelectedModel(draft.model || selectedModel);

    let loadedSources = 0;

    // Kiểm tra danh sách materials mới
    if (Array.isArray(draft.materials) && draft.materials.length > 0) {
      const ytMat = draft.materials.find((m: any) => m.type === 'youtube');
      const pdfMats = draft.materials.filter((m: any) => m.type === 'pdf');

      if (ytMat?.url) {
        setUrl(ytMat.url);
        loadedSources++;
      } else {
        setUrl('');
      }

      const pdfIds = pdfMats.flatMap((material: any) => {
        const ids = Array.isArray(material.pdf_document_id) ? material.pdf_document_id : [material.pdf_document_id];
        return ids.filter(Boolean).map(String);
      });
      if (pdfIds.length > 0) {
        setSelectedDocIds(pdfIds);
        loadedSources++;
      } else {
        setSelectedDocIds([]);
      }
    } else {
      // Fallback cho định dạng bài cũ
      if (draft.source_type?.toLowerCase() === 'pdf') {
        setSelectedDocIds(draft.pdf_document_id ? [String(draft.pdf_document_id)] : []);
        setUrl('');
      } else {
        setUrl(draft.source_url || '');
        setSelectedDocIds([]);
      }
    }

    showToast('Đã nạp lại thông tin bài giảng.');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const selectedDocInfos = documents.filter(d => selectedDocIds.includes(String(d.id)));

  return (
    <div className="p-8 space-y-8 max-w-7xl mx-auto">
      <div>
        <span className="text-xs font-semibold text-emerald-600 uppercase tracking-wider">Trợ lý Sư phạm AI</span>
        <h1 className="text-2xl font-bold text-slate-800">Biên soạn Giáo án & Bài tập</h1>
      </div>

      {/* Form tạo bài mới */}
      <div className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm space-y-6">
        <div>
          <h3 className="text-lg font-bold text-slate-800 flex items-center gap-2">
            <Sparkles className="text-emerald-600" size={20} /> Tạo bài giảng mới
          </h3>
          <p className="text-sm text-slate-500 mt-1">
            Bạn có thể cung cấp <strong>Video YouTube</strong>, <strong>File PDF</strong> hoặc <strong>kết hợp cả hai</strong> để AI tổng hợp lý thuyết, mẹo Casio và hệ thống bài tập giàn giáo.
          </p>
        </div>

        {/* 1. Tiêu đề & Model */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="md:col-span-2">
            <label className="block text-xs font-semibold text-slate-700 mb-1">
              Tiêu đề bài giảng <span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              placeholder="Ví dụ: Chuyên đề Khảo sát hàm số và Kỹ thuật bấm máy Casio..."
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              className="w-full px-3.5 py-2 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500"
            />
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-700 mb-1">Model AI xử lý</label>
            <select
              value={selectedModel}
              onChange={(e) => setSelectedModel(e.target.value)}
              className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500"
            >
              {models.length > 0 ? (
                models.map((m: any) => (
                  <option key={m.id} value={m.id}>{m.display_name || m.id}</option>
                ))
              ) : (
                <option value="gemini-3.7-flash">gemini-3.7 Flash (Mặc định)</option>
              )}
            </select>
          </div>
        </div>

        {/* 2. KHU VỰC TÀI LIỆU ĐẦU VÀO (CHO PHÉP CẢ HAI) */}
        <div className="border border-slate-200 rounded-xl p-4 bg-slate-50/50 space-y-4">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-slate-700 uppercase tracking-wider flex items-center gap-1.5">
              <Layers size={14} className="text-slate-500" /> Nguồn tài liệu cung cấp (Có thể kết hợp cả hai)
            </span>
            <span className="text-[11px] text-slate-500 italic">
              * Tối thiểu 1 nguồn tài liệu
            </span>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {/* NGUỒN 1: VIDEO YOUTUBE */}
            <div className={`p-4 rounded-lg border transition ${
              url.trim() ? 'bg-red-50/40 border-red-200' : 'bg-white border-slate-200'
            }`}>
              <div className="flex items-center justify-between mb-2">
                <span className="flex items-center gap-1.5 text-xs font-bold text-red-600">
                  <Play size={14} /> Nguồn 1: Video YouTube
                </span>
                {url.trim() && (
                  <button 
                    type="button" 
                    onClick={() => setUrl('')}
                    className="text-slate-400 hover:text-red-500 text-xs flex items-center gap-0.5"
                  >
                    <X size={12} /> Bỏ chọn
                  </button>
                )}
              </div>
              <input
                type="url"
                placeholder="Dán link video YouTube (https://...)"
                value={url}
                onChange={(e) => setUrl(e.target.value)}
                className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-red-400"
              />
              <p className="text-[11px] text-slate-500 mt-1.5">
                AI sẽ trích xuất phương pháp giải, mẹo bấm máy tính Casio từ video.
              </p>
            </div>

            {/* NGUỒN 2: FILE PDF */}
            <div className={`p-4 rounded-lg border transition ${
              selectedDocIds.length > 0 ? 'bg-blue-50/40 border-blue-200' : 'bg-white border-slate-200'
            }`}>
              <div className="flex items-center justify-between mb-2">
                <span className="flex items-center gap-1.5 text-xs font-bold text-blue-600">
                  <FileText size={14} /> Nguồn 2: Tài liệu PDF (Toàn bộ)
                </span>
                {selectedDocIds.length > 0 && (
                  <button 
                    type="button" 
                    onClick={() => setSelectedDocIds([])}
                    className="text-slate-400 hover:text-blue-500 text-xs flex items-center gap-0.5"
                  >
                    <X size={12} /> Bỏ chọn
                  </button>
                )}
              </div>

              <div className="space-y-2">
                <div className="flex gap-2">
                  <select
                    value=""
                    onChange={(e) => {
                      if (e.target.value && !selectedDocIds.includes(e.target.value)) {
                        setSelectedDocIds((current) => [...current, e.target.value]);
                      }
                    }}
                    className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-blue-400"
                  >
                    <option value="">-- Chọn file PDF đã có --</option>
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
                    className="px-3 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-xs font-semibold whitespace-nowrap flex items-center gap-1.5 transition disabled:opacity-50"
                  >
                    <UploadCloud size={14} /> {uploadingDoc ? "Đang đọc..." : "Chọn file máy tính"}
                  </button>
                </div>

                {selectedDocInfos.length > 0 ? (
                  <div className="space-y-1">
                    {selectedDocInfos.map((doc) => (
                      <p key={String(doc.id)} className="text-[11px] text-blue-700 flex items-center gap-1 font-medium">
                        <CheckCircle2 size={12} /> {doc.file_name} ({doc.page_count} trang)
                        <button type="button" onClick={() => setSelectedDocIds((current) => current.filter((id) => id !== String(doc.id)))} className="ml-1 text-blue-400 hover:text-red-500" aria-label={`Bỏ ${doc.file_name}`}>
                          <X size={12} />
                        </button>
                      </p>
                    ))}
                  </div>
                ) : (
                  <p className="text-[11px] text-slate-500">
                    AI sẽ dùng file PDF này làm khung kiến thức và ngân hàng dạng bài.
                  </p>
                )}
              </div>
            </div>
          </div>
        </div>

        {/* 3. Yêu cầu Prompt riêng */}
        <div>
          <label className="block text-xs font-semibold text-slate-700 mb-1">
            Yêu cầu sư phạm tùy chỉnh (Prompt riêng)
          </label>
          <textarea
            rows={2}
            placeholder="Ví dụ: Ưu tiên trích xuất mẹo Casio từ video, tập trung sinh 3 câu tự luận phân rã bước và 5 câu trắc nghiệm nhanh..."
            value={prompt}
            onChange={(e) => setPrompt(e.target.value)}
            className="w-full px-3.5 py-2 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500"
          />
        </div>

        {/* Nút Submit */}
        <button
          onClick={handleCreateLesson}
          disabled={creating || uploadingDoc}
          className="flex items-center gap-2 px-6 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg font-semibold text-sm shadow-sm transition disabled:opacity-50"
        >
          <Sparkles size={16} /> {creating ? "Đang gửi yêu cầu..." : "Bắt đầu tạo bài giảng"}
        </button>
      </div>

      {/* Bảng lịch sử */}
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
                <th className="py-3 px-5">Nguồn tài liệu</th>
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
                  <td colSpan={7} className="py-8 text-center text-slate-400">
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
                        {d.title || "Chưa có tiêu đề"}
                      </td>

                      {/* Hiển thị Nguồn (YouTube + PDF cùng lúc nếu có) */}
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
                            {d.source_url || (d.source_type?.toUpperCase() === 'PDF' ? d.pdf_file_name : "Nguồn khác")}
                          </small>
                        )}
                      </td>

                      <td className="py-3.5 px-5 text-xs text-slate-600 max-w-xs truncate">
                        {d.custom_prompt || "Mặc định"}
                      </td>
                      <td className="py-3.5 px-5 font-mono text-xs text-slate-500">
                        {d.model}
                      </td>
                      <td className="py-3.5 px-5 text-xs text-slate-500">
                        {formatDateTime(d.created_at)}
                      </td>

                      {/* Trạng thái */}
                      <td className="py-3.5 px-5">
                        {d.status === "processing" && (
                          <span className="px-2 py-0.5 bg-amber-50 text-amber-600 border border-amber-200 rounded text-xs font-medium">
                            Đang phân tích...
                          </span>
                        )}
                        {d.status === "completed" && (
                          <span className="px-2 py-0.5 bg-emerald-50 text-emerald-600 border border-emerald-200 rounded text-xs font-medium">
                            Đã hoàn thành
                          </span>
                        )}
                        {d.status === "failed" && (
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
                        {d.status === "completed" && (
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