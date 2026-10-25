// Wrapper an toàn gọi các API từ Go backend qua Wails IPC
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
  saveLessonDraft: (req: any) => GoApp().V2SaveLessonDraft(req),

  // Module 3: PDF / Documents
  listDocuments: () => GoApp().V2ListDocuments(),
  uploadDocument: () => GoApp().V2UploadDocument(),
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
  getStudentNotebook: (req: { student_id: string; audience?: string }) => GoApp().V2GetStudentNotebook(req),
  listOneNoteNotebooks: () => GoApp().V2ListOneNoteNotebooks(),
  bindStudentNotebook: (req: { student_id: string; audience?: string; notebook_id: string; notebook_name: string }) => GoApp().V2BindStudentNotebook(req),
  listOneNoteSections: (req: { notebook_id: string }) => GoApp().V2ListOneNoteSections(req),
  saveLastChapter: (req: { student_id: string; audience?: string; chapter_name: string }) => GoApp().V2SaveLastChapter(req),

  openExternalURL: async (url: string) => {
    if (!url) return;
    try {
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
      } catch (_) {}
    }
  }
};