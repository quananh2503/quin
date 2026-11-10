// Tự động khởi tạo Cầu nối Web Proxy nếu chạy trên Trình duyệt thông thường (iPad, Safari, Chrome...)
if (typeof window !== 'undefined' && !(window as any).go?.wails?.App) {
  (window as any).__isWebBridge = true;
  (window as any).go = (window as any).go || {};
  (window as any).go.wails = (window as any).go.wails || {};
  (window as any).go.wails.App = new Proxy({}, {
    get: (_target, prop: string) => {
      return async (...args: any[]) => {
        const response = await fetch(`/api/wails/${prop}`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(args),
        });
        if (!response.ok) {
          const errText = await response.text();
          throw new Error(errText || `Lỗi HTTP ${response.status}`);
        }
        const contentType = response.headers.get('content-type');
        if (contentType && contentType.includes('application/json')) {
          return await response.json();
        }
        return await response.text();
      };
    },
  });
}

function pickFileFromBrowser(accept: string = "*/*"): Promise<File | null> {
  return new Promise((resolve) => {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = accept;
    input.onchange = () => {
      if (input.files && input.files.length > 0) {
        resolve(input.files[0]);
      } else {
        resolve(null);
      }
    };
    input.click();
  });
}

function pickMultipleFilesFromBrowser(accept: string = "*/*"): Promise<File[]> {
  return new Promise((resolve) => {
    const input = document.createElement('input');
    input.type = 'file';
    input.multiple = true;
    input.accept = accept;
    input.onchange = () => {
      if (input.files && input.files.length > 0) {
        resolve(Array.from(input.files));
      } else {
        resolve([]);
      }
    };
    input.click();
  });
}

function fileToBase64(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(reader.result as string);
    reader.onerror = (error) => reject(error);
    reader.readAsDataURL(file);
  });
}

// Wrapper an toàn gọi các API từ Go backend qua Wails IPC hoặc Web Bridge
const GoApp = () => (window as any).go?.wails?.App;

export const api = {
  // Google Meet & OneNote Auth
  isGoogleConnected: () => GoApp().IsGoogleConnected(),
  connectGoogleMeet: () => GoApp().ConnectGoogleMeet(),
  isOneNoteConnected: () => GoApp().IsOneNoteConnected(),
  connectOneNote: () => GoApp().ConnectOneNote(),

  // Module 1: Dashboard & Students
  getDashboard: (filter: any) => GoApp().V2GetDashboard(filter),
  getStudentDetail: (req: any) => GoApp().V2GetStudentDetail(req),
  updateStudent: (student: any) => GoApp().V2UpdateStudent(student),
  syncMeetings: () => GoApp().V2SyncMeetings(),

  // Module 2: AI Lessons
  listAIModels: () => GoApp().V2ListAIModels(),
  createLesson: (req: any) => GoApp().V2CreateLesson(req),
  createLessonFromURL: (req: any) => GoApp().V2CreateLesson(req),
  listLessonDrafts: () => GoApp().V2ListLessonDrafts(),
  getLessonDraft: (id: string) => GoApp().V2GetLessonDraft(id),
  saveLessonDraft: (req: any) => (GoApp()?.V2SaveLessonDraft ? GoApp().V2SaveLessonDraft(req) : Promise.resolve()),

  // Module 3: PDF / Documents
  listDocuments: () => GoApp().V2ListDocuments(),
  uploadDocument: async () => {
    if ((window as any).go?.wails?.App && !(window as any).__isWebBridge) {
      return GoApp().V2UploadDocument();
    }
    const file = await pickFileFromBrowser('.pdf,.docx,.doc,.png,.jpg,.jpeg,.webp');
    if (!file) return null;
    const b64 = await fileToBase64(file);
    return await api.saveDocumentData(file.name, b64);
  },
  uploadDocuments: async () => {
    if ((window as any).go?.wails?.App && !(window as any).__isWebBridge) {
      return GoApp().V2UploadDocuments();
    }
    const files = await pickMultipleFilesFromBrowser('.pdf,.docx,.doc,.png,.jpg,.jpeg,.webp');
    if (!files || files.length === 0) return [];
    const results = [];
    for (const f of files) {
      const b64 = await fileToBase64(f);
      const doc = await api.saveDocumentData(f.name, b64);
      if (doc) results.push(doc);
    }
    return results;
  },
  saveDocumentData: (fileName: string, base64Data: string) => GoApp().V2SaveDocumentData(fileName, base64Data),
  getDocument: (id: string) => GoApp().V2GetDocument(id),
  getDocumentPreview: (id: string, page: number) => GoApp().V2GetDocumentPreview(id, page),
  createLessonFromPDF: (req: any) => GoApp().V2CreateLessonFromPDF(req),

  // Module 4: Grading & Mistakes
  listAssignments: (search: string) => GoApp().V2ListAssignments(search),
  getAssignment: (id: string) => GoApp().V2GetAssignment(id),
  gradeAssignment: (req: any) => GoApp().V2GradeAssignment(req),
  pushAssignmentFeedback: (id: string) => GoApp().V2PushAssignmentFeedback(id),
  listMistakes: () => GoApp().V2ListMistakes(),
  generateRemediation: (req: any) => GoApp().V2GenerateRemediation(req),

  // OneNote Publishing & Notebook Bindings
  listStudentChoices: () => GoApp().V2ListStudentChoices(),
  preparePublishing: (req: any) => GoApp().V2PreparePublishing(req),
  publishLesson: (req: any) => GoApp().V2PublishLesson(req),
  publishPDFLesson: (req: any) => GoApp().V2PublishPDFLesson(req),
  exportLessonPDF: (req: { lesson_id: string; is_teacher: boolean }) =>
    GoApp()?.V2ExportLessonPDF ? GoApp().V2ExportLessonPDF(req) : Promise.reject(new Error("V2ExportLessonPDF chưa sẵn sàng")),
  exportBothLessonPDFs: (lessonId: string) =>
    GoApp()?.V2ExportBothLessonPDFs ? GoApp().V2ExportBothLessonPDFs(lessonId) : Promise.reject(new Error("V2ExportBothLessonPDFs chưa sẵn sàng")),
  getStudentNotebook: (req: { student_id: string; audience?: string }) => GoApp().V2GetStudentNotebook(req),
  listOneNoteNotebooks: () => GoApp().V2ListOneNoteNotebooks(),
  bindStudentNotebook: (req: { student_id: string; audience?: string; notebook_id: string; notebook_name: string }) => GoApp().V2BindStudentNotebook(req),
  listOneNoteSections: (req: { notebook_id: string }) => GoApp().V2ListOneNoteSections(req),
  saveLastChapter: (req: { student_id: string; audience?: string; chapter_name: string }) => GoApp().V2SaveLastChapter(req),

  openExternalURL: async (url: string) => {
    if (!url) return;
    try {
      if ((window as any).__isWebBridge) {
        window.open(url, '_blank');
        return;
      }
      if (GoApp()?.OpenExternalURL) {
        await GoApp().OpenExternalURL(url);
        return;
      }
      if ((window as any).runtime?.BrowserOpenURL) {
        (window as any).runtime.BrowserOpenURL(url);
        return;
      }
      window.open(url, '_blank');
    } catch (e) {
      console.error("Lỗi khi mở URL ngoài:", url, e);
      try {
        window.open(url, '_blank');
      } catch (winErr) {
        console.error("Lỗi window.open fallback:", winErr);
        throw e;
      }
    }
  },

  // Settings & API Keys
  getAPIKeys: async (): Promise<Record<string, string>> => {
    try {
      if (GoApp()?.V2GetAPIKeys) {
        return await GoApp().V2GetAPIKeys();
      }
    } catch (e) {
      console.error("Lỗi getAPIKeys:", e);
    }
    return {};
  },
  saveAPIKey: async (provider: string, key: string): Promise<void> => {
    if (GoApp()?.V2SaveAPIKey) {
      return await GoApp().V2SaveAPIKey(provider, key);
    }
    throw new Error("Dịch vụ lưu API Key chưa sẵn sàng");
  },
};
