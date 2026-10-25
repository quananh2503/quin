import React, { useState, useEffect } from 'react';
import { api } from '../../api';
import { normalizeError } from '../../utils';
import { X, Send, FileText, BookOpen, GraduationCap, Link2, RefreshCw, FolderOpen, Check } from 'lucide-react';

export const OneNoteModal: React.FC<{ draft: any; onClose: () => void; showToast: any; onGoGrading: any }> = ({ draft, onClose, showToast, onGoGrading }) => {
  const [students, setStudents] = useState<any[]>([]);
  const [studentId, setStudentId] = useState("");
  const [studentChapter, setStudentChapter] = useState("");
  const [teacherChapter, setTeacherChapter] = useState("");
  const [pageTitle, setPageTitle] = useState("");
  const [pushing, setPushing] = useState(false);

  // HS Notebook binding states (Audience: HS)
  const [hsNotebook, setHsNotebook] = useState<{
    notebook_id: string;
    notebook_name: string;
    is_bound: boolean;
    last_chapter_name?: string;
  } | null>(null);
  const [loadingHsNotebook, setLoadingHsNotebook] = useState(false);
  const [showHsSelector, setShowHsSelector] = useState(false);
  const [selectedHsNotebookId, setSelectedHsNotebookId] = useState("");
  const [bindingHsNotebook, setBindingHsNotebook] = useState(false);

  // GV Notebook binding states (Audience: GV)
  const [gvNotebook, setGvNotebook] = useState<{
    notebook_id: string;
    notebook_name: string;
    is_bound: boolean;
    last_chapter_name?: string;
  } | null>(null);
  const [loadingGvNotebook, setLoadingGvNotebook] = useState(false);
  const [showGvSelector, setShowGvSelector] = useState(false);
  const [selectedGvNotebookId, setSelectedGvNotebookId] = useState("");
  const [bindingGvNotebook, setBindingGvNotebook] = useState(false);

  // Shared notebooks list from OneNote
  const [availableNotebooks, setAvailableNotebooks] = useState<any[]>([]);
  const [loadingNotebooksList, setLoadingNotebooksList] = useState(false);

  // HS Sections (Chương trong sổ tay HS)
  const [hsSections, setHsSections] = useState<any[]>([]);
  const [loadingHsSections, setLoadingHsSections] = useState(false);
  const [showHsSections, setShowHsSections] = useState(false);

  // GV Sections (Chương trong sổ tay GV)
  const [gvSections, setGvSections] = useState<any[]>([]);
  const [loadingGvSections, setLoadingGvSections] = useState(false);
  const [showGvSections, setShowGvSections] = useState(false);

  useEffect(() => {
    api.listStudentChoices().then((list: any) => {
      setStudents(list || []);
      if (list?.length > 0) setStudentId(String(list[0].id));
    });
    setPageTitle(draft?.title || "Buổi học mới");
  }, [draft]);

  // Tự động load 2 notebook (HS & GV) và chương gần nhất đang lưu trong SQLite cho học sinh được chọn
  useEffect(() => {
    if (!studentId) {
      setHsNotebook(null);
      setGvNotebook(null);
      setStudentChapter("");
      setTeacherChapter("");
      setHsSections([]);
      setGvSections([]);
      return;
    }

    setLoadingHsNotebook(true);
    setLoadingGvNotebook(true);
    setShowHsSelector(false);
    setShowGvSelector(false);
    setShowHsSections(false);
    setShowGvSections(false);
    setHsSections([]);
    setGvSections([]);

    // Lấy thông tin sổ tay Học sinh (HS) kèm chương được chọn gần nhất
    api.getStudentNotebook({ student_id: studentId, audience: "HS" })
      .then((info: any) => {
        setHsNotebook(info);
        if (info?.notebook_id) {
          setSelectedHsNotebookId(info.notebook_id);
        }
        if (info?.last_chapter_name) {
          setStudentChapter(info.last_chapter_name);
        } else {
          setStudentChapter("");
        }
      })
      .catch((err: any) => {
        console.error("Lỗi lấy thông tin sổ tay HS:", err);
      })
      .finally(() => {
        setLoadingHsNotebook(false);
      });

    // Lấy thông tin sổ tay Giáo viên (GV) kèm chương được chọn gần nhất
    api.getStudentNotebook({ student_id: studentId, audience: "GV" })
      .then((info: any) => {
        setGvNotebook(info);
        if (info?.notebook_id) {
          setSelectedGvNotebookId(info.notebook_id);
        }
        if (info?.last_chapter_name) {
          setTeacherChapter(info.last_chapter_name);
        } else {
          setTeacherChapter("");
        }
      })
      .catch((err: any) => {
        console.error("Lỗi lấy thông tin sổ tay GV:", err);
      })
      .finally(() => {
        setLoadingGvNotebook(false);
      });
  }, [studentId]);

  // Tải danh sách tất cả các notebook từ Microsoft OneNote (dùng chung cho cả HS và GV)
  const fetchAvailableNotebooks = async () => {
    if (availableNotebooks.length > 0) return availableNotebooks;
    setLoadingNotebooksList(true);
    try {
      const list = await api.listOneNoteNotebooks();
      setAvailableNotebooks(list || []);
      return list || [];
    } catch (err) {
      showToast("Không thể tải danh sách sổ tay từ OneNote: " + normalizeError(err), true);
      return [];
    } finally {
      setLoadingNotebooksList(false);
    }
  };

  // Toggle mở selector đổi liên kết cho Học sinh (HS)
  const handleToggleHsSelector = async () => {
    if (showHsSelector) {
      setShowHsSelector(false);
      return;
    }
    setShowHsSelector(true);
    setShowGvSelector(false);
    const list = await fetchAvailableNotebooks();
    if (list && list.length > 0 && !selectedHsNotebookId) {
      // Ưu tiên tìm sổ tay có đuôi HS hoặc chứa tên học sinh
      const match = list.find((nb: any) => (nb.displayName || nb.name || "").endsWith("-HS")) || list[0];
      setSelectedHsNotebookId(match.id);
    }
  };

  // Toggle mở selector đổi liên kết cho Giáo viên (GV)
  const handleToggleGvSelector = async () => {
    if (showGvSelector) {
      setShowGvSelector(false);
      return;
    }
    setShowGvSelector(true);
    setShowHsSelector(false);
    const list = await fetchAvailableNotebooks();
    if (list && list.length > 0 && !selectedGvNotebookId) {
      // Ưu tiên tìm sổ tay có đuôi GV
      const match = list.find((nb: any) => (nb.displayName || nb.name || "").endsWith("-GV")) || list[0];
      setSelectedGvNotebookId(match.id);
    }
  };

  // Lưu đổi liên kết sổ tay Học sinh (HS) vào SQLite
  const handleSaveHsBinding = async () => {
    if (!studentId) {
      showToast("Vui lòng chọn học sinh", true);
      return;
    }
    if (!selectedHsNotebookId) {
      showToast("Vui lòng chọn một sổ tay từ danh sách", true);
      return;
    }
    const targetNb = availableNotebooks.find((nb: any) => nb.id === selectedHsNotebookId);
    const targetName = targetNb?.displayName || targetNb?.name || "";
    if (!targetName) {
      showToast("Tên sổ tay không hợp lệ", true);
      return;
    }

    setBindingHsNotebook(true);
    try {
      await api.bindStudentNotebook({
        student_id: studentId,
        audience: "HS",
        notebook_id: selectedHsNotebookId,
        notebook_name: targetName,
      });
      setHsNotebook({
        notebook_id: selectedHsNotebookId,
        notebook_name: targetName,
        is_bound: true,
      });
      setHsSections([]);
      setShowHsSelector(false);
      showToast(`Đã đổi liên kết sổ tay Học sinh: "${targetName}"`);
    } catch (err) {
      showToast("Lỗi liên kết sổ tay Học sinh: " + normalizeError(err), true);
    } finally {
      setBindingHsNotebook(false);
    }
  };

  // Lưu đổi liên kết sổ tay Giáo viên (GV) vào SQLite
  const handleSaveGvBinding = async () => {
    if (!studentId) {
      showToast("Vui lòng chọn học sinh", true);
      return;
    }
    if (!selectedGvNotebookId) {
      showToast("Vui lòng chọn một sổ tay từ danh sách", true);
      return;
    }
    const targetNb = availableNotebooks.find((nb: any) => nb.id === selectedGvNotebookId);
    const targetName = targetNb?.displayName || targetNb?.name || "";
    if (!targetName) {
      showToast("Tên sổ tay không hợp lệ", true);
      return;
    }

    setBindingGvNotebook(true);
    try {
      await api.bindStudentNotebook({
        student_id: studentId,
        audience: "GV",
        notebook_id: selectedGvNotebookId,
        notebook_name: targetName,
      });
      setGvNotebook({
        notebook_id: selectedGvNotebookId,
        notebook_name: targetName,
        is_bound: true,
      });
      setGvSections([]);
      setShowGvSelector(false);
      showToast(`Đã đổi liên kết sổ tay Giáo viên: "${targetName}"`);
    } catch (err) {
      showToast("Lỗi liên kết sổ tay Giáo viên: " + normalizeError(err), true);
    } finally {
      setBindingGvNotebook(false);
    }
  };

  // Mở/đóng danh sách các chương cũ trong sổ tay Học sinh (HS)
  const handleToggleHsSections = async () => {
    if (showHsSections) {
      setShowHsSections(false);
      return;
    }
    const nbId = hsNotebook?.notebook_id;
    if (!nbId) {
      showToast("Sổ tay chưa có ID trên OneNote. Vui lòng bấm 'Đổi liên kết' để chọn sổ tay trước.", true);
      return;
    }
    setShowHsSections(true);
    setShowGvSections(false);
    if (hsSections.length === 0) {
      setLoadingHsSections(true);
      try {
        const list = await api.listOneNoteSections({ notebook_id: nbId });
        setHsSections(list || []);
      } catch (err) {
        showToast("Không thể tải danh sách chương từ OneNote: " + normalizeError(err), true);
      } finally {
        setLoadingHsSections(false);
      }
    }
  };

  // Mở/đóng danh sách các chương cũ trong sổ tay Giáo viên (GV)
  const handleToggleGvSections = async () => {
    if (showGvSections) {
      setShowGvSections(false);
      return;
    }
    const nbId = gvNotebook?.notebook_id;
    if (!nbId) {
      showToast("Sổ tay chưa có ID trên OneNote. Vui lòng bấm 'Đổi liên kết' để chọn sổ tay trước.", true);
      return;
    }
    setShowGvSections(true);
    setShowHsSections(false);
    if (gvSections.length === 0) {
      setLoadingGvSections(true);
      try {
        const list = await api.listOneNoteSections({ notebook_id: nbId });
        setGvSections(list || []);
      } catch (err) {
        showToast("Không thể tải danh sách chương từ OneNote: " + normalizeError(err), true);
      } finally {
        setLoadingGvSections(false);
      }
    }
  };

  // Thực hiện giao bài giảng và tạo trang trên Microsoft OneNote
  const handlePush = async () => {
    if (!studentId || !studentChapter.trim() || !teacherChapter.trim() || !pageTitle.trim()) {
      showToast("Vui lòng điền đủ tên các chương và tiêu đề", true);
      return;
    }
    const lessonId = draft?.lesson_data?.id || draft?.id;
    if (!lessonId) {
      showToast("Không tìm thấy thông tin ID bài giảng", true);
      return;
    }

    setPushing(true);
    try {
      await api.publishPDFLesson({
        lesson_id: String(lessonId),
        student_id: studentId,
        student_chapter_name: studentChapter.trim(),
        teacher_chapter_name: teacherChapter.trim(),
        page_name: pageTitle.trim()
      });
      showToast("Đã đẩy 2 bản in PDF (Giáo viên & Học sinh) lên Microsoft OneNote thành công!");
      onClose();
      onGoGrading();
    } catch (err) {
      showToast("Lỗi đẩy lên OneNote: " + normalizeError(err), true);
    } finally {
      setPushing(false);
    }
  };

  if (!draft) return null;

  return (
    <div className="fixed inset-0 bg-slate-900/40 backdrop-blur-xs flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-xl max-w-md w-full p-6 shadow-xl space-y-4 max-h-[92vh] overflow-y-auto">
        <div className="flex justify-between items-center">
          <h3 className="font-bold text-purple-800 flex items-center gap-2">
            <Send size={18} /> Đẩy bài lên OneNote
          </h3>
          <button onClick={onClose}><X size={18} /></button>
        </div>

        <div className="space-y-3">
          {/* 1. Chọn học sinh */}
          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1">1. Học sinh nhận bài</label>
            <select
              value={studentId}
              onChange={(e) => setStudentId(e.target.value)}
              className="w-full px-3 py-2 border rounded-lg text-sm bg-white"
            >
              {students.map((s) => <option key={s.id} value={s.id}>{s.name}</option>)}
            </select>
          </div>

          {/* Sổ tay OneNote Học sinh (Audience HS) */}
          <div className="p-3 bg-purple-50/50 border border-purple-200/80 rounded-lg space-y-2">
            <div className="flex items-center justify-between">
              <label className="text-xs font-semibold text-purple-900 flex items-center gap-1.5">
                <BookOpen size={14} className="text-purple-700" /> Sổ tay OneNote của Học sinh
              </label>
              <button
                type="button"
                onClick={handleToggleHsSelector}
                title="Bấm để đổi liên kết sang sổ tay khác trên OneNote"
                className="flex items-center gap-1 px-2 py-1 text-[11px] font-medium text-purple-700 bg-purple-100 hover:bg-purple-200 rounded transition-colors"
              >
                <Link2 size={13} />
                <span>{showHsSelector ? "Thu gọn" : "Đổi liên kết"}</span>
              </button>
            </div>

            {loadingHsNotebook ? (
              <div className="text-xs text-slate-500 italic py-1">Đang kiểm tra sổ tay học sinh...</div>
            ) : (
              <div className="flex items-center justify-between bg-white px-3 py-2 rounded border border-purple-100 text-xs">
                <div className="font-medium text-slate-800 truncate mr-2">
                  {hsNotebook?.notebook_name || "Chưa xác định"}
                </div>
                {hsNotebook?.is_bound ? (
                  <span className="text-[10px] bg-emerald-100 text-emerald-700 font-semibold px-2 py-0.5 rounded-full shrink-0">
                    Đã liên kết
                  </span>
                ) : (
                  <span className="text-[10px] bg-amber-100 text-amber-700 font-medium px-2 py-0.5 rounded-full shrink-0">
                    Mặc định
                  </span>
                )}
              </div>
            )}

            {/* Panel chọn và đổi liên kết HS */}
            {showHsSelector && (
              <div className="pt-2 border-t border-purple-200/60 space-y-2">
                <div className="text-[11px] text-purple-900 font-medium">
                  Chọn sổ tay OneNote làm Vở Học sinh:
                </div>
                {loadingNotebooksList ? (
                  <div className="flex items-center gap-2 text-xs text-purple-700 py-1.5">
                    <RefreshCw size={13} className="animate-spin" />
                    <span>Đang truy vấn danh sách sổ tay từ Microsoft OneNote...</span>
                  </div>
                ) : availableNotebooks.length === 0 ? (
                  <div className="text-xs text-slate-500 py-1">
                    Không tìm thấy sổ tay nào hoặc chưa kết nối tài khoản.
                  </div>
                ) : (
                  <div className="flex gap-2">
                    <select
                      value={selectedHsNotebookId}
                      onChange={(e) => setSelectedHsNotebookId(e.target.value)}
                      className="flex-1 px-2.5 py-1.5 border rounded-lg text-xs bg-white text-slate-800"
                    >
                      {availableNotebooks.map((nb: any) => (
                        <option key={nb.id} value={nb.id}>
                          {nb.displayName || nb.name}
                        </option>
                      ))}
                    </select>
                    <button
                      type="button"
                      onClick={handleSaveHsBinding}
                      disabled={bindingHsNotebook || !selectedHsNotebookId}
                      className="px-3 py-1.5 bg-purple-700 hover:bg-purple-800 text-white rounded-lg text-xs font-semibold shrink-0 disabled:opacity-50"
                    >
                      {bindingHsNotebook ? "Đang lưu..." : "Lưu liên kết"}
                    </button>
                  </div>
                )}
              </div>
            )}
          </div>

          {/* Sổ tay OneNote Giáo viên (Audience GV) */}
          <div className="p-3 bg-blue-50/50 border border-blue-200/80 rounded-lg space-y-2">
            <div className="flex items-center justify-between">
              <label className="text-xs font-semibold text-blue-900 flex items-center gap-1.5">
                <GraduationCap size={15} className="text-blue-700" /> Sổ tay OneNote của Giáo viên
              </label>
              <button
                type="button"
                onClick={handleToggleGvSelector}
                title="Bấm để đổi liên kết sang sổ tay khác trên OneNote"
                className="flex items-center gap-1 px-2 py-1 text-[11px] font-medium text-blue-700 bg-blue-100 hover:bg-blue-200 rounded transition-colors"
              >
                <Link2 size={13} />
                <span>{showGvSelector ? "Thu gọn" : "Đổi liên kết"}</span>
              </button>
            </div>

            {loadingGvNotebook ? (
              <div className="text-xs text-slate-500 italic py-1">Đang kiểm tra sổ tay giáo viên...</div>
            ) : (
              <div className="flex items-center justify-between bg-white px-3 py-2 rounded border border-blue-100 text-xs">
                <div className="font-medium text-slate-800 truncate mr-2">
                  {gvNotebook?.notebook_name || "Chưa xác định"}
                </div>
                {gvNotebook?.is_bound ? (
                  <span className="text-[10px] bg-emerald-100 text-emerald-700 font-semibold px-2 py-0.5 rounded-full shrink-0">
                    Đã liên kết
                  </span>
                ) : (
                  <span className="text-[10px] bg-amber-100 text-amber-700 font-medium px-2 py-0.5 rounded-full shrink-0">
                    Mặc định
                  </span>
                )}
              </div>
            )}

            {/* Panel chọn và đổi liên kết GV */}
            {showGvSelector && (
              <div className="pt-2 border-t border-blue-200/60 space-y-2">
                <div className="text-[11px] text-blue-900 font-medium">
                  Chọn sổ tay OneNote làm Vở Giáo viên:
                </div>
                {loadingNotebooksList ? (
                  <div className="flex items-center gap-2 text-xs text-blue-700 py-1.5">
                    <RefreshCw size={13} className="animate-spin" />
                    <span>Đang truy vấn danh sách sổ tay từ Microsoft OneNote...</span>
                  </div>
                ) : availableNotebooks.length === 0 ? (
                  <div className="text-xs text-slate-500 py-1">
                    Không tìm thấy sổ tay nào hoặc chưa kết nối tài khoản.
                  </div>
                ) : (
                  <div className="flex gap-2">
                    <select
                      value={selectedGvNotebookId}
                      onChange={(e) => setSelectedGvNotebookId(e.target.value)}
                      className="flex-1 px-2.5 py-1.5 border rounded-lg text-xs bg-white text-slate-800"
                    >
                      {availableNotebooks.map((nb: any) => (
                        <option key={nb.id} value={nb.id}>
                          {nb.displayName || nb.name}
                        </option>
                      ))}
                    </select>
                    <button
                      type="button"
                      onClick={handleSaveGvBinding}
                      disabled={bindingGvNotebook || !selectedGvNotebookId}
                      className="px-3 py-1.5 bg-blue-700 hover:bg-blue-800 text-white rounded-lg text-xs font-semibold shrink-0 disabled:opacity-50"
                    >
                      {bindingGvNotebook ? "Đang lưu..." : "Lưu liên kết"}
                    </button>
                  </div>
                )}
              </div>
            )}
          </div>

          {/* 2. Chương trong vở Học sinh */}
          <div className="relative">
            <div className="flex items-center justify-between mb-1">
              <label className="block text-xs font-semibold text-slate-700">
                2. Chương trong vở Học sinh
              </label>
              <button
                type="button"
                onClick={handleToggleHsSections}
                title="Bấm để chọn chương đã có trong sổ tay OneNote"
                className="flex items-center gap-1 text-[11px] text-purple-700 hover:text-purple-900 font-medium px-2 py-0.5 rounded bg-purple-50 hover:bg-purple-100 transition-colors"
              >
                <FolderOpen size={12} />
                <span>{showHsSections ? "Thu gọn" : "Chọn chương cũ"}</span>
              </button>
            </div>
            <input
              type="text"
              placeholder="Nhập tên chương mới hoặc chọn chương cũ..."
              value={studentChapter}
              onChange={(e) => setStudentChapter(e.target.value)}
              className="w-full px-3 py-2 border rounded-lg text-sm bg-white text-slate-900 focus:outline-none focus:ring-1 focus:ring-purple-500"
            />
            <p className="text-[11px] text-slate-500 mt-1">
              * Nhập tên để tạo chương mới, hoặc bấm <span className="font-semibold text-purple-700">"Chọn chương cũ"</span> để dùng lại chương trong sổ tay.
            </p>

            {/* Danh sách chương cũ của Học sinh */}
            {showHsSections && (
              <div className="mt-1.5 p-2 bg-slate-50 border border-purple-200 rounded-lg shadow-sm space-y-1.5 max-h-44 overflow-y-auto">
                <div className="text-[11px] font-semibold text-purple-900 flex items-center justify-between">
                  <span>Các chương có sẵn trong sổ tay:</span>
                  <button
                    type="button"
                    onClick={() => {
                      if (hsNotebook?.notebook_id) {
                        setLoadingHsSections(true);
                        api.listOneNoteSections({ notebook_id: hsNotebook.notebook_id })
                          .then((secs: any) => setHsSections(secs || []))
                          .catch((e: any) => showToast("Lỗi làm mới: " + normalizeError(e), true))
                          .finally(() => setLoadingHsSections(false));
                      }
                    }}
                    className="text-purple-600 hover:text-purple-800 p-0.5"
                    title="Làm mới danh sách chương"
                  >
                    <RefreshCw size={12} className={loadingHsSections ? "animate-spin" : ""} />
                  </button>
                </div>
                {loadingHsSections ? (
                  <div className="flex items-center gap-2 text-xs text-purple-700 py-1.5">
                    <RefreshCw size={12} className="animate-spin" />
                    <span>Đang tải các chương từ OneNote...</span>
                  </div>
                ) : hsSections.length === 0 ? (
                  <div className="text-xs text-slate-500 italic py-1">
                    Sổ tay này chưa có chương nào. Hãy nhập tên để tạo mới.
                  </div>
                ) : (
                  <div className="space-y-1">
                    {hsSections.map((sec: any) => (
                      <button
                        key={sec.id}
                        type="button"
                        onClick={() => {
                          setStudentChapter(sec.displayName);
                          setShowHsSections(false);
                        }}
                        className={`w-full text-left px-2.5 py-1.5 rounded text-xs flex items-center justify-between transition-colors ${
                          studentChapter === sec.displayName
                            ? "bg-purple-100 text-purple-900 font-semibold"
                            : "hover:bg-purple-100/60 text-slate-700 bg-white"
                        }`}
                      >
                        <span className="truncate">{sec.displayName}</span>
                        {studentChapter === sec.displayName && (
                          <Check size={13} className="text-purple-700 shrink-0" />
                        )}
                      </button>
                    ))}
                  </div>
                )}
              </div>
            )}
          </div>

          {/* 3. Chương trong vở Giáo viên */}
          <div className="relative">
            <div className="flex items-center justify-between mb-1">
              <label className="block text-xs font-semibold text-slate-700">
                3. Chương trong vở Giáo viên
              </label>
              <button
                type="button"
                onClick={handleToggleGvSections}
                title="Bấm để chọn chương đã có trong sổ tay OneNote"
                className="flex items-center gap-1 text-[11px] text-blue-700 hover:text-blue-900 font-medium px-2 py-0.5 rounded bg-blue-50 hover:bg-blue-100 transition-colors"
              >
                <FolderOpen size={12} />
                <span>{showGvSections ? "Thu gọn" : "Chọn chương cũ"}</span>
              </button>
            </div>
            <input
              type="text"
              placeholder="Nhập tên chương mới hoặc chọn chương cũ..."
              value={teacherChapter}
              onChange={(e) => setTeacherChapter(e.target.value)}
              className="w-full px-3 py-2 border rounded-lg text-sm bg-white text-slate-900 focus:outline-none focus:ring-1 focus:ring-blue-500"
            />
            <p className="text-[11px] text-slate-500 mt-1">
              * Nhập tên để tạo chương mới, hoặc bấm <span className="font-semibold text-blue-700">"Chọn chương cũ"</span> để dùng lại chương trong sổ tay.
            </p>

            {/* Danh sách chương cũ của Giáo viên */}
            {showGvSections && (
              <div className="mt-1.5 p-2 bg-slate-50 border border-blue-200 rounded-lg shadow-sm space-y-1.5 max-h-44 overflow-y-auto">
                <div className="text-[11px] font-semibold text-blue-900 flex items-center justify-between">
                  <span>Các chương có sẵn trong sổ tay:</span>
                  <button
                    type="button"
                    onClick={() => {
                      if (gvNotebook?.notebook_id) {
                        setLoadingGvSections(true);
                        api.listOneNoteSections({ notebook_id: gvNotebook.notebook_id })
                          .then((secs: any) => setGvSections(secs || []))
                          .catch((e: any) => showToast("Lỗi làm mới: " + normalizeError(e), true))
                          .finally(() => setLoadingGvSections(false));
                      }
                    }}
                    className="text-blue-600 hover:text-blue-800 p-0.5"
                    title="Làm mới danh sách chương"
                  >
                    <RefreshCw size={12} className={loadingGvSections ? "animate-spin" : ""} />
                  </button>
                </div>
                {loadingGvSections ? (
                  <div className="flex items-center gap-2 text-xs text-blue-700 py-1.5">
                    <RefreshCw size={12} className="animate-spin" />
                    <span>Đang tải các chương từ OneNote...</span>
                  </div>
                ) : gvSections.length === 0 ? (
                  <div className="text-xs text-slate-500 italic py-1">
                    Sổ tay này chưa có chương nào. Hãy nhập tên để tạo mới.
                  </div>
                ) : (
                  <div className="space-y-1">
                    {gvSections.map((sec: any) => (
                      <button
                        key={sec.id}
                        type="button"
                        onClick={() => {
                          setTeacherChapter(sec.displayName);
                          setShowGvSections(false);
                        }}
                        className={`w-full text-left px-2.5 py-1.5 rounded text-xs flex items-center justify-between transition-colors ${
                          teacherChapter === sec.displayName
                            ? "bg-blue-100 text-blue-900 font-semibold"
                            : "hover:bg-blue-100/60 text-slate-700 bg-white"
                        }`}
                      >
                        <span className="truncate">{sec.displayName}</span>
                        {teacherChapter === sec.displayName && (
                          <Check size={13} className="text-blue-700 shrink-0" />
                        )}
                      </button>
                    ))}
                  </div>
                )}
              </div>
            )}
          </div>
          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1">4. Tiêu đề buổi học</label>
            <input
              type="text"
              value={pageTitle}
              onChange={(e) => setPageTitle(e.target.value)}
              className="w-full px-3 py-2 border rounded-lg text-sm"
            />
          </div>

          <div className="p-3 bg-purple-50 rounded-lg border border-purple-100 flex items-start gap-2">
            <FileText size={16} className="text-purple-700 mt-0.5 shrink-0" />
            <div className="text-xs text-purple-900">
              <span className="font-semibold">Bản in PDF đính kèm:</span> Hệ thống sẽ tự động xuất bản 2 bản in PDF chất lượng cao (Bản Giáo viên có đáp án & Bản Học sinh làm bài) trực tiếp lên OneNote.
            </div>
          </div>
        </div>

        <div className="flex justify-end gap-2 pt-2">
          <button onClick={onClose} className="px-4 py-2 bg-slate-100 hover:bg-slate-200 rounded-lg text-xs font-semibold">
            Hủy
          </button>
          <button
            onClick={handlePush}
            disabled={pushing}
            className="flex items-center gap-1.5 px-4 py-2 bg-purple-700 hover:bg-purple-800 text-white rounded-lg text-xs font-semibold"
          >
            <Send size={14} /> {pushing ? "Đang đẩy bài..." : "Bắt đầu đẩy bài"}
          </button>
        </div>
      </div>
    </div>
  );
};
