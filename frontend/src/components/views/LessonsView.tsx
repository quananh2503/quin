import React, { useState, useEffect, useRef } from 'react';
import { api } from '../../api';
import { formatDateTime, normalizeError, extractContentText } from '../../utils';
import { wails } from '../../../wailsjs/go/models';
import { 
  Sparkles, 
  Play, 
  FileText, 
  RefreshCw, 
  Paperclip, 
  X, 
  Video, 
  Plus, 
  Image as ImageIcon, 
  BookOpen, 
  Send, 
  Loader2, 
  FileCode,
  FolderOpen
} from 'lucide-react';

interface LessonsViewProps {
  onOpenEditor: (draftId: string) => void;
  onRetryPDF: (draft: any) => void;
  onOpenErrorModal: (draft: any) => void;
  showToast: (msg: string, isError?: boolean) => void;
}

export const LessonsView: React.FC<LessonsViewProps> = ({ 
  onOpenEditor, 
  onRetryPDF: _onRetryPDF, 
  onOpenErrorModal, 
  showToast 
}) => {
  const [drafts, setDrafts] = useState<any[]>([]);
  const [documents, setDocuments] = useState<any[]>([]);
  
  // State Form
  const selectedModel = 'deepseek-flash';
  const [selectedDocIds, setSelectedDocIds] = useState<string[]>([]);
  const [youtubeUrls, setYoutubeUrls] = useState<string[]>([]);
  const [prompt, setPrompt] = useState('');
  
  // UI states
  const [creating, setCreating] = useState(false);
  const [uploadingDoc, setUploadingDoc] = useState(false);
  const [isDragging, setIsDragging] = useState(false);
  const [showYoutubeInput, setShowYoutubeInput] = useState(false);
  const [youtubeInputText, setYoutubeInputText] = useState('');
  const [showLibraryDropdown, setShowLibraryDropdown] = useState(false);

  const fileInputRef = useRef<HTMLInputElement>(null);
  const textareaRef = useRef<HTMLTextAreaElement>(null);
  const libraryDropdownRef = useRef<HTMLDivElement>(null);

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

  // Smart Polling: Khi có ít nhất 1 bài giảng đang xử lý (processing), poll mỗi 3 giây.
  // Khi không có bài giảng nào đang xử lý, poll giãn ra 8 giây để tránh nghẽn IPC/DOM.
  useEffect(() => {
    loadData();
    const hasProcessing = drafts.some((d) => d.status === 'processing');
    const intervalTime = hasProcessing ? 3000 : 8000;
    const interval = setInterval(loadDrafts, intervalTime);
    return () => clearInterval(interval);
  }, [drafts.some((d) => d.status === 'processing')]);

  // Đóng dropdown kho tài liệu khi click ra ngoài
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (libraryDropdownRef.current && !libraryDropdownRef.current.contains(event.target as Node)) {
        setShowLibraryDropdown(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Xử lý nạp danh sách file File[] (từ Paste, Drag-Drop hoặc File Input)
  const processUploadedFiles = async (files: File[]) => {
    if (!files || files.length === 0) return;
    setUploadingDoc(true);
    let successCount = 0;

    for (const file of files) {
      try {
        const base64Data = await readFileAsBase64(file);
        let doc: any = null;
        if (api.saveDocumentData) {
          doc = await api.saveDocumentData(file.name, base64Data);
        }
        if (doc && doc.id) {
          const docIdStr = String(doc.id);
          setSelectedDocIds((prev) => (prev.includes(docIdStr) ? prev : [...prev, docIdStr]));
          setDocuments((prev) => {
            const exists = prev.some((d) => String(d.id) === docIdStr);
            return exists ? prev : [doc, ...prev];
          });
          successCount++;
        }
      } catch (err) {
        console.error('Lỗi lưu file:', file.name, err);
        showToast(`Không thể tải ${file.name}: ` + normalizeError(err), true);
      }
    }

    setUploadingDoc(false);
    if (successCount > 0) {
      showToast(`Đã đính kèm ${successCount} tài liệu/hình ảnh thành công`);
    }
  };

  const readFileAsBase64 = (file: File): Promise<string> => {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = () => resolve(reader.result as string);
      reader.onerror = (err) => reject(err);
      reader.readAsDataURL(file);
    });
  };

  // Mở hộp thoại native chọn file từ máy tính (hỗ trợ nhiều file)
  const handlePickAndUploadDocument = async () => {
    // Nếu chạy trên Web / iPad: kích hoạt input file HTML chuẩn của trình duyệt
    if (typeof window !== 'undefined' && (!(window as any).go?.wails?.App || (window as any).__isWebBridge)) {
      fileInputRef.current?.click();
      return;
    }

    try {
      setUploadingDoc(true);
      const uploadedDocs = await api.uploadDocuments();
      if (!uploadedDocs?.length) return;

      showToast(`Đã nạp ${uploadedDocs.length} tài liệu`);
      await loadDocuments();
      setSelectedDocIds((current) => [
        ...current,
        ...uploadedDocs.filter((doc: any) => doc.id).map((doc: any) => String(doc.id)),
      ]);
    } catch (err) {
      showToast('Lỗi khi tải tài liệu: ' + normalizeError(err), true);
    } finally {
      setUploadingDoc(false);
    }
  };

  // Bắt sự kiện Paste trực tiếp vào khung chat (Ctrl+V)
  const handlePaste = async (e: React.ClipboardEvent<HTMLTextAreaElement>) => {
    // 1. Kiểm tra nếu clipboard có file (ảnh chụp màn hình, file copy từ Explorer...)
    const items = e.clipboardData?.items;
    const filesToUpload: File[] = [];

    if (items && items.length > 0) {
      for (let i = 0; i < items.length; i++) {
        const item = items[i];
        if (item.kind === 'file') {
          const file = item.getAsFile();
          if (file) {
            filesToUpload.push(file);
          }
        }
      }
    } else if (e.clipboardData?.files?.length) {
      filesToUpload.push(...Array.from(e.clipboardData.files));
    }

    if (filesToUpload.length > 0) {
      e.preventDefault();
      await processUploadedFiles(filesToUpload);
      return;
    }

    // 2. Kiểm tra nếu clipboard chứa link YouTube
    const pastedText = e.clipboardData?.getData('text') || '';
    if (pastedText) {
      const ytRegex = /(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:watch\?v=|shorts\/|embed\/)|youtu\.be\/)[a-zA-Z0-9_-]+[^\s]*/gi;
      const matches = pastedText.match(ytRegex);

      if (matches && matches.length > 0) {
        let addedCount = 0;
        matches.forEach((raw) => {
          let cleanUrl = raw.trim();
          if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
            cleanUrl = 'https://' + cleanUrl;
          }
          if (!youtubeUrls.includes(cleanUrl)) {
            setYoutubeUrls((prev) => [...prev, cleanUrl]);
            addedCount++;
          }
        });

        if (addedCount > 0) {
          showToast(`Đã tự động nhận diện ${addedCount} link YouTube!`);
        }

        // Nếu nội dung dán thuần túy là link YouTube, không chèn link thô vào prompt
        const remainingText = pastedText.replace(ytRegex, '').trim();
        if (!remainingText) {
          e.preventDefault();
        } else {
          e.preventDefault();
          const target = e.target as HTMLTextAreaElement;
          const start = target.selectionStart;
          const end = target.selectionEnd;
          const currentVal = prompt;
          const nextVal = currentVal.substring(0, start) + remainingText + currentVal.substring(end);
          setPrompt(nextVal);
        }
      }
    }
  };

  // Kéo thả file trực tiếp vào khung chat
  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(true);
  };

  const handleDragLeave = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
  };

  const handleDrop = async (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
    if (e.dataTransfer.files?.length) {
      await processUploadedFiles(Array.from(e.dataTransfer.files));
    }
  };

  // Thêm link YouTube thủ công từ input popover
  const handleAddYoutubeUrl = () => {
    const trimmed = youtubeInputText.trim();
    if (!trimmed) return;
    if (!trimmed.includes('youtube.com') && !trimmed.includes('youtu.be')) {
      showToast('Chỉ chấp nhận link từ YouTube (youtube.com hoặc youtu.be)', true);
      return;
    }
    if (youtubeUrls.includes(trimmed)) {
      showToast('Link video này đã có trong danh sách', true);
      return;
    }
    setYoutubeUrls((current) => [...current, trimmed]);
    setYoutubeInputText('');
    setShowYoutubeInput(false);
    showToast('Đã thêm video YouTube');
  };

  const handleRemoveYoutubeUrl = (index: number) => {
    setYoutubeUrls((current) => current.filter((_, i) => i !== index));
  };

  const handleRemoveDoc = (docId: string) => {
    setSelectedDocIds((current) => current.filter((id) => id !== docId));
  };

  // Gửi lệnh tạo bài giảng tới Backend
  const handleCreateLesson = async () => {
    if (selectedDocIds.length === 0 && youtubeUrls.length === 0) {
      showToast('Vui lòng đính kèm ít nhất một tài liệu (PDF, Word, Ảnh) hoặc link YouTube', true);
      return;
    }

    setCreating(true);
    try {
      const docNames = selectedDocInfos.map((d) => (d.file_name ? d.file_name.replace(/\.[^/.]+$/, '') : 'Tài liệu'));
      const autoTitle = docNames.length > 0 
        ? docNames.join(', ') 
        : (youtubeUrls.length > 0 ? 'Bài giảng YouTube' : '');

      const request = new wails.GenerateLessonRequest({
        title: autoTitle,
        model: selectedModel,
        prompt: prompt.trim(),
        url: youtubeUrls[0] || '',
        urls: youtubeUrls,
        document_id: selectedDocIds[0] || '',
        document_ids: selectedDocIds,
        pages: [],
      });

      await api.createLesson(request);
      showToast('Đã gửi yêu cầu! AI đang phân tích tài liệu và biên soạn bài giảng...');
      
      // Reset form sau khi gửi thành công
      setSelectedDocIds([]);
      setYoutubeUrls([]);
      setPrompt('');
      loadDrafts();
    } catch (err) {
      showToast('Lỗi tạo bài giảng: ' + normalizeError(err), true);
    } finally {
      setCreating(false);
    }
  };

  // Phím tắt Ctrl+Enter gửi bài
  const handleKeyDown = (e: React.KeyboardEvent<HTMLTextAreaElement>) => {
    if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
      e.preventDefault();
      if (!creating && !uploadingDoc && (selectedDocIds.length > 0 || youtubeUrls.length > 0)) {
        handleCreateLesson();
      }
    }
  };

  // Nạp lại dữ liệu bài cũ
  const handleRetry = (draft: any) => {
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

  // Nhận diện icon và màu badge theo đuôi file (an toàn tuyệt đối với chuỗi rỗng hoặc undefined)
  const getFileBadgeInfo = (fileName?: string) => {
    if (!fileName || typeof fileName !== 'string') {
      return {
        icon: <FileText size={14} className="text-slate-500 shrink-0" />,
        badgeClass: 'bg-slate-50 border-slate-200 text-slate-700',
        typeLabel: 'Tệp',
      };
    }
    const ext = fileName.split('.').pop()?.toLowerCase() || '';
    if (['png', 'jpg', 'jpeg', 'webp', 'bmp', 'gif', 'tiff'].includes(ext)) {
      return {
        icon: <ImageIcon size={14} className="text-emerald-600 shrink-0" />,
        badgeClass: 'bg-emerald-50 border-emerald-200 text-emerald-900',
        typeLabel: 'Ảnh',
      };
    }
    if (['docx', 'doc'].includes(ext)) {
      return {
        icon: <FileCode size={14} className="text-blue-600 shrink-0" />,
        badgeClass: 'bg-blue-50 border-blue-200 text-blue-900',
        typeLabel: 'Word',
      };
    }
    return {
      icon: <FileText size={14} className="text-rose-600 shrink-0" />,
      badgeClass: 'bg-rose-50 border-rose-200 text-rose-900',
      typeLabel: 'PDF',
    };
  };

  // Trích xuất tiêu đề an toàn từ draft (chống lỗi crash khi title là JSON hoặc object)
  const getDraftTitle = (d: any): string => {
    return extractContentText(d?.title) || 'Chưa có tiêu đề';
  };

  const hasAttachments = selectedDocInfos.length > 0 || youtubeUrls.length > 0 || uploadingDoc;

  return (
    <div className="p-6 md:p-8 space-y-6 max-w-6xl mx-auto">
      {/* 1. Header & Engine Switcher */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-slate-800 tracking-tight flex items-center gap-2">
            <Sparkles className="text-emerald-600" size={24} /> Biên soạn Giáo án AI
          </h1>
          <p className="text-xs text-slate-500 mt-0.5">
            Tự động bóc tách lý thuyết, dạng toán, bài tập giàn giáo và xuất bản sang Microsoft OneNote.
          </p>
        </div>

        {/* Trạng thái Động cơ AI */}
        <div className="inline-flex items-center gap-1.5 px-3 py-1.5 bg-emerald-50 rounded-xl border border-emerald-200/70 text-xs font-semibold text-emerald-800 self-start sm:self-auto shadow-xs">
          <Sparkles size={14} className="text-emerald-600" />
          <span>Biên soạn AI</span>
          <span className="text-[10px] px-1.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800 font-medium">
            Đa định dạng
          </span>
        </div>
      </div>

      {/* 2. CHAT / PROMPT BOX (Giao diện đơn giản tối giản phong cách ChatGPT / Gemini) */}
      <div 
        onDragOver={handleDragOver}
        onDragLeave={handleDragLeave}
        onDrop={handleDrop}
        className={`bg-white rounded-2xl border transition-all duration-200 shadow-sm relative ${
          isDragging 
            ? 'border-emerald-500 ring-4 ring-emerald-500/10 bg-emerald-50/20' 
            : 'border-slate-200 hover:border-slate-300 focus-within:border-emerald-500 focus-within:ring-4 focus-within:ring-emerald-500/10'
        }`}
      >
        {/* Overlay khi đang kéo thả file */}
        {isDragging && (
          <div className="absolute inset-0 bg-emerald-50/90 rounded-2xl z-20 flex flex-col items-center justify-center pointer-events-none border-2 border-dashed border-emerald-500">
            <Paperclip className="text-emerald-600 animate-bounce mb-2" size={32} />
            <p className="text-sm font-bold text-emerald-800">Thả file PDF, Word hoặc Ảnh vào đây</p>
            <p className="text-xs text-emerald-600">AI sẽ tự động nhận diện và đính kèm vào bài giảng</p>
          </div>
        )}

        {/* Input file ẩn hỗ trợ kéo thả hoặc chọn từ máy tính */}
        <input
          ref={fileInputRef}
          type="file"
          multiple
          accept=".pdf,.docx,.doc,.png,.jpg,.jpeg,.webp,.bmp,.txt"
          className="hidden"
          onChange={(e) => {
            if (e.target.files?.length) {
              processUploadedFiles(Array.from(e.target.files));
              e.target.value = '';
            }
          }}
        />

        {/* 2.1. Tray danh sách tài liệu & video đã đính kèm (Chips) */}
        {hasAttachments && (
          <div className="p-3.5 pb-1 border-b border-slate-100 flex flex-wrap items-center gap-2">
            {/* File tài liệu (PDF, Ảnh, Word) */}
            {selectedDocInfos.map((doc) => {
              const { icon, badgeClass, typeLabel } = getFileBadgeInfo(doc.file_name);
              return (
                <div
                  key={String(doc.id)}
                  className={`inline-flex items-center gap-2 px-3 py-1.5 rounded-xl border text-xs font-medium shadow-2xs max-w-xs ${badgeClass}`}
                >
                  {icon}
                  <span className="truncate" title={doc.file_name}>
                    {doc.file_name}
                  </span>
                  <span className="text-[10px] opacity-60 font-semibold shrink-0">
                    {typeLabel} {doc.page_count > 1 ? `(${doc.page_count} tr)` : ''}
                  </span>
                  <button
                    type="button"
                    onClick={() => handleRemoveDoc(String(doc.id))}
                    className="p-0.5 hover:bg-black/10 rounded-full transition text-slate-500 hover:text-slate-800"
                    title="Xóa tài liệu"
                  >
                    <X size={13} />
                  </button>
                </div>
              );
            })}

            {/* Video YouTube */}
            {youtubeUrls.map((url, idx) => (
              <div
                key={idx}
                className="inline-flex items-center gap-2 px-3 py-1.5 rounded-xl border bg-red-50/70 border-red-200 text-red-900 text-xs font-medium shadow-2xs max-w-xs"
              >
                <Play size={12} className="text-red-600 fill-red-600 shrink-0" />
                <span className="truncate" title={url}>
                  {url}
                </span>
                <button
                  type="button"
                  onClick={() => handleRemoveYoutubeUrl(idx)}
                  className="p-0.5 hover:bg-black/10 rounded-full transition text-red-400 hover:text-red-700"
                  title="Xóa video YouTube"
                >
                  <X size={13} />
                </button>
              </div>
            ))}

            {/* Loading spinner khi đang upload */}
            {uploadingDoc && (
              <div className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-slate-100 text-slate-600 text-xs animate-pulse">
                <Loader2 size={13} className="animate-spin text-emerald-600" />
                <span>Đang xử lý nạp file...</span>
              </div>
            )}
          </div>
        )}

        {/* 2.2. Khung Textarea nhập Prompt / Paste file */}
        <div className="p-3.5">
          <textarea
            ref={textareaRef}
            rows={3}
            value={prompt}
            onChange={(e) => setPrompt(e.target.value)}
            onPaste={handlePaste}
            onKeyDown={handleKeyDown}
            placeholder="Hỏi AI hoặc mô tả yêu cầu giáo án (VD: Phân dạng chi tiết, bài tập bậc thang từ dễ đến khó...). Dán file hoặc link YouTube trực tiếp (Ctrl+V)..."
            className="w-full bg-transparent resize-none text-sm text-slate-800 placeholder:text-slate-400 focus:outline-none leading-relaxed"
          />
        </div>

        {/* Popover thêm link YouTube thủ công (khi bấm nút Video) */}
        {showYoutubeInput && (
          <div className="px-3.5 pb-3">
            <div className="flex items-center gap-2 p-2 bg-slate-50 border border-slate-200 rounded-xl">
              <Play size={14} className="text-red-600 fill-red-600 ml-1 shrink-0" />
              <input
                type="text"
                autoFocus
                placeholder="Dán link YouTube (VD: https://www.youtube.com/watch?v=...)"
                value={youtubeInputText}
                onChange={(e) => setYoutubeInputText(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter') {
                    e.preventDefault();
                    handleAddYoutubeUrl();
                  }
                  if (e.key === 'Escape') {
                    setShowYoutubeInput(false);
                  }
                }}
                className="flex-1 bg-transparent text-xs text-slate-800 placeholder:text-slate-400 focus:outline-none"
              />
              <button
                type="button"
                onClick={handleAddYoutubeUrl}
                className="px-2.5 py-1 bg-red-600 hover:bg-red-700 text-white rounded-lg text-xs font-semibold flex items-center gap-1 transition shadow-2xs"
              >
                <Plus size={13} /> Thêm
              </button>
              <button
                type="button"
                onClick={() => setShowYoutubeInput(false)}
                className="p-1 text-slate-400 hover:text-slate-600"
              >
                <X size={14} />
              </button>
            </div>
          </div>
        )}

        {/* 2.3. Thanh công cụ phía dưới (Toolbar) */}
        <div className="px-3.5 py-2.5 bg-slate-50/70 border-t border-slate-100 rounded-b-2xl flex items-center justify-between gap-3">
          {/* Nút đính kèm file & link */}
          <div className="flex items-center gap-1.5 relative">
            {/* Nút Nạp file từ máy tính */}
            <button
              type="button"
              onClick={handlePickAndUploadDocument}
              disabled={uploadingDoc || creating}
              className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-medium text-slate-700 hover:text-slate-900 hover:bg-slate-200/60 transition cursor-pointer disabled:opacity-50"
              title="Đính kèm tài liệu PDF, Word hoặc Ảnh từ máy tính"
            >
              <Paperclip size={14} className="text-slate-500" />
              <span className="hidden sm:inline">Tải file lên</span>
            </button>

            {/* Nút Thêm link YouTube */}
            <button
              type="button"
              onClick={() => setShowYoutubeInput(!showYoutubeInput)}
              className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-medium transition cursor-pointer ${
                showYoutubeInput 
                  ? 'bg-red-50 text-red-700 font-semibold' 
                  : 'text-slate-700 hover:text-slate-900 hover:bg-slate-200/60'
              }`}
              title="Thêm link video bài giảng YouTube"
            >
              <Video size={14} className={showYoutubeInput ? 'text-red-600' : 'text-slate-500'} />
              <span className="hidden sm:inline">Link YouTube</span>
            </button>

            {/* Nút Chọn từ Kho tài liệu đã có */}
            <div className="relative" ref={libraryDropdownRef}>
              <button
                type="button"
                onClick={() => setShowLibraryDropdown(!showLibraryDropdown)}
                className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-medium transition cursor-pointer ${
                  showLibraryDropdown 
                    ? 'bg-emerald-50 text-emerald-800 font-semibold' 
                    : 'text-slate-700 hover:text-slate-900 hover:bg-slate-200/60'
                }`}
                title="Chọn lại file từ kho lưu trữ ứng dụng"
              >
                <FolderOpen size={14} className="text-slate-500" />
                <span className="hidden sm:inline">Kho lưu trữ</span>
                {documents.length > 0 && (
                  <span className="text-[10px] bg-slate-200 px-1.5 py-0.2 rounded-full font-bold text-slate-700">
                    {documents.length}
                  </span>
                )}
              </button>

              {/* Menu Dropdown chọn từ kho */}
              {showLibraryDropdown && (
                <div className="absolute left-0 bottom-full mb-2 w-72 max-h-60 overflow-y-auto bg-white border border-slate-200 rounded-xl shadow-lg z-30 p-1.5 space-y-1">
                  <div className="px-2.5 py-1 text-[11px] font-bold text-slate-400 uppercase tracking-wider flex items-center justify-between">
                    <span>Kho tài liệu đã lưu</span>
                    <span className="text-slate-400">{documents.length}</span>
                  </div>
                  {documents.length === 0 ? (
                    <div className="p-3 text-center text-xs text-slate-400">
                      Chưa có tài liệu nào trong kho
                    </div>
                  ) : (
                    documents.map((doc: any) => {
                      const isSelected = selectedDocIds.includes(String(doc.id));
                      const { icon } = getFileBadgeInfo(doc.file_name);
                      return (
                        <button
                          key={String(doc.id)}
                          type="button"
                          onClick={() => {
                            if (isSelected) {
                              handleRemoveDoc(String(doc.id));
                            } else {
                              setSelectedDocIds((prev) => [...prev, String(doc.id)]);
                            }
                          }}
                          className={`w-full flex items-center justify-between px-2.5 py-2 rounded-lg text-left text-xs transition cursor-pointer ${
                            isSelected 
                              ? 'bg-emerald-50 text-emerald-900 font-semibold' 
                              : 'hover:bg-slate-100 text-slate-700'
                          }`}
                        >
                          <div className="flex items-center gap-2 truncate">
                            {icon}
                            <span className="truncate">{doc.file_name}</span>
                          </div>
                          {isSelected && <X size={12} className="text-emerald-700 shrink-0 ml-1" />}
                        </button>
                      );
                    })
                  )}
                </div>
              )}
            </div>
          </div>

          {/* Nút Bắt đầu tạo bài giảng */}
          <div className="flex items-center gap-2">
            <span className="hidden sm:inline text-[11px] text-slate-400">
              Ctrl+Enter để gửi
            </span>
            <button
              type="button"
              onClick={handleCreateLesson}
              disabled={creating || uploadingDoc || (selectedDocIds.length === 0 && youtubeUrls.length === 0)}
              className="inline-flex items-center gap-1.5 px-4 py-2 bg-emerald-600 hover:bg-emerald-700 disabled:bg-slate-200 disabled:text-slate-400 disabled:cursor-not-allowed text-white rounded-xl text-xs font-semibold transition shadow-xs cursor-pointer"
            >
              {creating ? (
                <>
                  <Loader2 size={14} className="animate-spin" />
                  <span>Đang xử lý...</span>
                </>
              ) : (
                <>
                  <Send size={13} />
                  <span>Tạo bài giảng</span>
                </>
              )}
            </button>
          </div>
        </div>
      </div>

      {/* 2.4. Gợi ý mẫu Prompt nhanh */}
      <div className="flex flex-wrap items-center gap-2 text-xs">
        <span className="text-slate-400 font-medium">Gợi ý yêu cầu:</span>
        <button
          type="button"
          onClick={() => setPrompt('Phân dạng chi tiết từng dạng toán, phân tích phương pháp tư duy và mẹo bấm máy Casio nhanh.')}
          className="px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-slate-200/80 text-slate-600 text-[11px] transition cursor-pointer"
        >
          ⚡ Phân dạng + Mẹo Casio
        </button>
        <button
          type="button"
          onClick={() => setPrompt('Thiết kế bài tập tự luyện bậc thang 4 mức độ: Nhận biết, Thông hiểu, Vận dụng, Vận dụng cao kèm lời giải chi tiết.')}
          className="px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-slate-200/80 text-slate-600 text-[11px] transition cursor-pointer"
        >
          📈 Bài tập bậc thang 4 cấp độ
        </button>
        <button
          type="button"
          onClick={() => setPrompt('Trích xuất lý thuyết cốt lõi, công thức then chốt kèm 3 ví dụ mẫu kinh điển có lời giải chi tiết.')}
          className="px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-slate-200/80 text-slate-600 text-[11px] transition cursor-pointer"
        >
          📖 Trọng tâm lý thuyết & Ví dụ mẫu
        </button>
      </div>

      {/* 3. BẢNG LỊCH SỬ BÀI GIẢNG */}
      <div className="bg-white rounded-2xl border border-slate-200 shadow-xs overflow-hidden">
        <div className="px-6 py-4 border-b border-slate-100 flex justify-between items-center">
          <div className="flex items-center gap-2">
            <h3 className="font-bold text-slate-800 text-sm">Lịch sử bài giảng đã biên soạn</h3>
            <span className="text-[11px] px-2 py-0.5 bg-slate-100 text-slate-600 rounded-full font-semibold">
              {drafts.length}
            </span>
          </div>
          <button
            type="button"
            onClick={loadDrafts}
            className="p-1.5 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-lg transition"
            title="Làm mới danh sách"
          >
            <RefreshCw size={14} />
          </button>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full table-fixed min-w-[1020px] text-left text-sm">
            <thead className="bg-slate-50 text-slate-500 font-semibold border-b border-slate-100 text-xs">
              <tr>
                <th className="py-3 px-3.5 w-[30%] min-w-[210px]">Bài giảng</th>
                <th className="py-3 px-3.5 w-[22%] min-w-[170px]">Tài liệu nguồn</th>
                <th className="py-3 px-3.5 w-[15%] min-w-[130px]">Yêu cầu Prompt</th>
                <th className="py-3 px-3.5 w-[135px] min-w-[135px]">Thời gian</th>
                <th className="py-3 px-3.5 w-[130px] min-w-[130px]">Trạng thái</th>
                <th className="py-3 px-3.5 w-[245px] min-w-[245px] text-right">Thao tác</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {drafts.length === 0 ? (
                <tr>
                  <td colSpan={6} className="py-12 text-center text-slate-400 text-xs">
                    Chưa có bài giảng nào được tạo. Hãy đính kèm tài liệu phía trên để bắt đầu!
                  </td>
                </tr>
              ) : (
                drafts.map((d: any) => {
                  const hasMaterials = Array.isArray(d.materials) && d.materials.length > 0;
                  const titleText = getDraftTitle(d);

                  return (
                    <tr key={d.id} className="hover:bg-slate-50/80 transition-colors h-16">
                      {/* Tiêu đề */}
                      <td className="py-2.5 px-3.5 align-middle">
                        <div
                          className="font-semibold text-slate-800 text-xs line-clamp-2 break-words leading-snug cursor-default"
                          title={titleText}
                        >
                          {titleText}
                        </div>
                      </td>

                      {/* Hiển thị Nguồn tài liệu */}
                      <td className="py-2.5 px-3.5 align-middle">
                        {hasMaterials ? (
                          <div className="flex flex-col gap-1 justify-center">
                            {d.materials.slice(0, 2).map((m: any, idx: number) => {
                              const typeUpper = (m.type || '').toUpperCase();
                              const isYt = typeUpper === 'YOUTUBE' || Boolean(m.url);
                              if (isYt) {
                                return (
                                  <span key={idx} className="inline-flex items-center gap-1.5 text-xs text-slate-700 min-w-0" title={m.url}>
                                    <span className="p-1 rounded bg-red-50 text-red-600 shrink-0"><Play size={10} /></span>
                                    <span className="truncate font-mono text-[11px]">{m.url}</span>
                                  </span>
                                );
                              }
                              const fileName = m.pdf_file_name || 'Tài liệu nguồn';
                              const badge = getFileBadgeInfo(fileName);
                              return (
                                <span key={idx} className="inline-flex items-center gap-1.5 text-xs text-slate-700 min-w-0" title={fileName}>
                                  <span className="p-1 rounded bg-slate-100 shrink-0">{badge.icon}</span>
                                  <span className="truncate text-[11px]">{fileName}</span>
                                </span>
                              );
                            })}
                            {d.materials.length > 2 && (
                              <span className="text-[10px] text-slate-400 font-medium pl-1">
                                +{d.materials.length - 2} tài liệu khác
                              </span>
                            )}
                          </div>
                        ) : (
                          <span
                            className="text-slate-400 text-[11px] truncate block"
                            title={d.source_url || (d.source_type?.toUpperCase() === 'PDF' ? d.pdf_file_name : 'Nguồn khác')}
                          >
                            {d.source_url || (d.source_type?.toUpperCase() === 'PDF' ? d.pdf_file_name : 'Nguồn khác')}
                          </span>
                        )}
                      </td>

                      {/* Yêu cầu Prompt */}
                      <td className="py-2.5 px-3.5 align-middle">
                        <div
                          className="text-xs text-slate-600 line-clamp-2 break-words leading-snug cursor-default"
                          title={d.custom_prompt || 'Mặc định'}
                        >
                          {d.custom_prompt || 'Mặc định'}
                        </div>
                      </td>

                      {/* Thời gian */}
                      <td className="py-2.5 px-3.5 align-middle text-xs text-slate-500 whitespace-nowrap">
                        {formatDateTime(d.created_at)}
                      </td>

                      {/* Trạng thái */}
                      <td className="py-2.5 px-3.5 align-middle whitespace-nowrap">
                        {d.status === 'processing' && (
                          <span className="inline-flex items-center gap-1 px-2.5 py-0.5 bg-amber-50 text-amber-700 border border-amber-200/80 rounded-full text-[11px] font-medium animate-pulse">
                            <Loader2 size={11} className="animate-spin text-amber-600" />
                            Đang xử lý...
                          </span>
                        )}
                        {d.status === 'completed' && (
                          <span className="inline-flex items-center px-2.5 py-0.5 bg-emerald-50 text-emerald-700 border border-emerald-200/80 rounded-full text-[11px] font-semibold">
                            Đã hoàn thành
                          </span>
                        )}
                        {d.status === 'failed' && (
                          <span className="inline-flex items-center px-2.5 py-0.5 bg-red-50 text-red-600 border border-red-200 rounded-full text-[11px] font-semibold">
                            Thất bại
                          </span>
                        )}
                      </td>

                      {/* Thao tác */}
                      <td className="py-2.5 px-3.5 align-middle text-right whitespace-nowrap">
                        {d.status === 'completed' && (
                          <div className="flex justify-end items-center gap-1.5">
                            <button
                              type="button"
                              onClick={() => handleRetry(d)}
                              className="inline-flex items-center gap-1 px-2 py-1 border border-slate-200 hover:border-slate-300 text-slate-700 hover:bg-slate-50 rounded-lg text-xs font-medium transition cursor-pointer shrink-0 shadow-2xs"
                              title="Nạp lại vào ô nhập"
                            >
                              <RefreshCw size={11} /> Nạp lại
                            </button>
                            <button
                              type="button"
                              onClick={() => onOpenEditor(d.id)}
                              className="inline-flex items-center gap-1 px-2.5 py-1 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-xs font-semibold transition cursor-pointer shadow-2xs shrink-0 whitespace-nowrap"
                            >
                              Sửa & Đẩy OneNote
                            </button>
                          </div>
                        )}
                        {d.status === 'failed' && (
                          <div className="flex justify-end items-center gap-1.5">
                            <button
                              type="button"
                              onClick={() => onOpenErrorModal(d)}
                              className="inline-flex items-center gap-1 px-2 py-1 border border-red-200 text-red-600 hover:bg-red-50 hover:border-red-300 rounded-lg text-xs font-medium transition cursor-pointer shrink-0 shadow-2xs"
                            >
                              Xem lỗi
                            </button>
                            <button
                              type="button"
                              onClick={() => handleRetry(d)}
                              className="inline-flex items-center gap-1 px-2 py-1 border border-slate-200 hover:border-slate-300 text-slate-700 hover:bg-slate-50 rounded-lg text-xs font-medium transition cursor-pointer shrink-0 shadow-2xs"
                              title="Nạp lại vào ô nhập"
                            >
                              <RefreshCw size={11} /> Nạp lại
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
