import React, { useState, useEffect } from 'react';
import { api } from '../../api';
import { normalizeError } from '../../utils';
import { X, Send } from 'lucide-react';

export const OneNoteModal: React.FC<{ draft: any; onClose: () => void; showToast: any; onGoGrading: any }> = ({ draft, onClose, showToast, onGoGrading }) => {
  const [students, setStudents] = useState<any[]>([]);
  const [studentId, setStudentId] = useState("");
  const [studentChapter, setStudentChapter] = useState("");
  const [teacherChapter, setTeacherChapter] = useState("");
  const [pageTitle, setPageTitle] = useState("");
  const [pushing, setPushing] = useState(false);

  useEffect(() => {
    api.listStudentChoices().then((list:any) => {
      setStudents(list || []);
      if (list?.length > 0) setStudentId(String(list[0].id));
    });
    setPageTitle(draft?.title || "Buổi học mới");
  }, [draft]);

  // Thực hiện giao bài giảng và tạo trang trên Microsoft OneNote
  const handlePush = async () => {
    if (!studentId || !studentChapter.trim() || !teacherChapter.trim() || !pageTitle.trim()) {
      showToast("Vui lòng điền đủ tên các chương và tiêu đề", true);
      return;
    }
    setPushing(true);
    try {
      await api.publishLesson({
        lesson_id: draft.lesson_data.id,
        student_id: studentId,
        student_chapter_name: studentChapter.trim(),
        teacher_chapter_name: teacherChapter.trim(),
        page_name: pageTitle.trim()
      });
      showToast("Đã đẩy bài lên sổ OneNote của Giáo viên & Học sinh thành công!");
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
      <div className="bg-white rounded-xl max-w-md w-full p-6 shadow-xl space-y-4">
        <div className="flex justify-between items-center">
          <h3 className="font-bold text-purple-800">Đẩy bài lên OneNote</h3>
          <button onClick={onClose}><X size={18} /></button>
        </div>

        <div className="space-y-3">
          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1">1. Học sinh nhận bài</label>
            <select value={studentId} onChange={(e) => setStudentId(e.target.value)} className="w-full px-3 py-2 border rounded-lg text-sm">
              {students.map((s) => <option key={s.id} value={s.id}>{s.name}</option>)}
            </select>
          </div>
          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1">2. Chương trong vở Học sinh</label>
            <input type="text" placeholder="Tên chương mới..." value={studentChapter} onChange={(e) => setStudentChapter(e.target.value)} className="w-full px-3 py-2 border rounded-lg text-sm" />
          </div>
          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1">3. Chương trong vở Giáo viên</label>
            <input type="text" placeholder="Tên chương mới..." value={teacherChapter} onChange={(e) => setTeacherChapter(e.target.value)} className="w-full px-3 py-2 border rounded-lg text-sm" />
          </div>
          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1">4. Tiêu đề buổi học</label>
            <input type="text" value={pageTitle} onChange={(e) => setPageTitle(e.target.value)} className="w-full px-3 py-2 border rounded-lg text-sm" />
          </div>
        </div>

        <div className="flex justify-end gap-2 pt-2">
          <button onClick={onClose} className="px-4 py-2 bg-slate-100 hover:bg-slate-200 rounded-lg text-xs font-semibold">Hủy</button>
          <button onClick={handlePush} disabled={pushing} className="flex items-center gap-1.5 px-4 py-2 bg-purple-700 hover:bg-purple-800 text-white rounded-lg text-xs font-semibold">
            <Send size={14} /> {pushing ? "Đang đẩy bài..." : "Bắt đầu đẩy bài"}
          </button>
        </div>
      </div>
    </div>
  );
};