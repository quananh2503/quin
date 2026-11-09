import React, { useState, useRef, useEffect } from 'react';
import { Sidebar } from './components/Sidebar';
import { DashboardView } from './components/views/DashboardView';
import { StudentDetailView } from './components/views/StudentDetailView';
import { LessonsView } from './components/views/LessonsView';
import { LessonEditorView } from './components/views/LessonEditorView';
import { DocumentsView } from './components/views/DocumentsView';
import { GradingView } from './components/views/GradingView';
import { GradingDetailView } from './components/views/GradingDetailView';
import { SettingsView } from './components/views/SettingsView';
import { ErrorModal } from './components/modals/ErrorModal';
import { OneNoteModal } from './components/modals/OneNoteModal';
import { RemediationModal } from './components/modals/RemediationModal';

interface ErrorBoundaryState {
  hasError: boolean;
  error: any;
}

class ErrorBoundary extends React.Component<{ children: React.ReactNode }, ErrorBoundaryState> {
  constructor(props: { children: React.ReactNode }) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: any) {
    return { hasError: true, error };
  }

  componentDidCatch(error: any, errorInfo: any) {
    console.error("ErrorBoundary caught:", error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="p-12 text-center space-y-4">
          <div className="inline-block p-4 bg-red-50 text-red-600 rounded-2xl mb-2 font-bold text-base">
            Đã xảy ra sự cố khi hiển thị màn hình này
          </div>
          <p className="text-xs text-slate-500 font-mono max-w-xl mx-auto bg-slate-100 p-3 rounded-lg overflow-x-auto text-left">
            {String(this.state.error?.message || this.state.error)}
          </p>
          <button
            onClick={() => this.setState({ hasError: false, error: null })}
            className="px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-xs font-semibold cursor-pointer"
          >
            Tải lại màn hình
          </button>
        </div>
      );
    }
    return this.props.children;
  }
}

export default function App() {
  const [currentView, setCurrentView] = useState("dashboard");
  const [selectedStudentId, setSelectedStudentId] = useState<string | null>(null);
  const [selectedRange, setSelectedRange] = useState<{
  from: Date;
  to: Date;
} | null>(null);
  const [selectedDraftId, setSelectedDraftId] = useState<string | null>(null);
  const [retryDraft, setRetryDraft] = useState<any>(null);
  const [selectedAssignmentId, setSelectedAssignmentId] = useState<string | null>(null);

  // Modals state
  const [errorDraft, setErrorDraft] = useState<any>(null);
  const [pushOneNoteDraft, setPushOneNoteDraft] = useState<any>(null);
  const [remediationMistake, setRemediationMistake] = useState<any>(null);

  // Toast
  const [toast, setToast] = useState<{ msg: string; isError?: boolean } | null>(null);

  const showToast = (msg: string, isError = false) => {
    setToast({ msg, isError });
    setTimeout(() => setToast(null), 3500);
  };

  const mainRef = useRef<HTMLElement | null>(null);

  // Tự động cuộn lên đầu trang mỗi khi chuyển màn hình
  useEffect(() => {
    if (mainRef.current) {
      mainRef.current.scrollTop = 0;
    }
  }, [currentView, selectedDraftId]);


  return (
    <div className="flex h-screen w-screen bg-slate-50 font-sans text-slate-800 overflow-hidden">
      {/* Toast popup */}
      {toast && (
        <div className={`fixed bottom-6 right-6 z-50 px-4 py-2.5 rounded-lg text-white text-sm font-medium shadow-lg transition-all ${
          toast.isError ? 'bg-red-600' : 'bg-slate-900'
        }`}>
          {toast.msg}
        </div>
      )}

      {/* Sidebar cố định bên trái */}
      <Sidebar currentView={currentView} onNavigate={(view) => setCurrentView(view)} showToast={showToast} />

      {/* Nội dung trang bên phải */}
      <main ref={mainRef} className="flex-1 h-screen overflow-y-auto">
        <ErrorBoundary key={currentView}>
        {currentView === "dashboard" && (
          <DashboardView
             onSelectStudent={(id, from, to) => {
              setSelectedStudentId(id);
              setSelectedRange({ from, to });
              setCurrentView("student-detail");
            }}
            showToast={showToast}
          />
        )}

        {currentView === "student-detail" && (
          selectedStudentId && selectedRange ? (
            <StudentDetailView
              studentId={selectedStudentId}
              fromDate={selectedRange.from}
              toDate={selectedRange.to}
              onBack={() => setCurrentView("dashboard")}
              showToast={showToast}
            />
          ) : (
            <DashboardView
              onSelectStudent={(id, from, to) => {
                setSelectedStudentId(id);
                setSelectedRange({ from, to });
                setCurrentView("student-detail");
              }}
              showToast={showToast}
            />
          )
        )}

        {currentView === "lessons" && (
          <LessonsView
            onOpenEditor={(id) => {
              setSelectedDraftId(id);
              setCurrentView("lesson-editor");
            }}
            onRetryPDF={(draft) => {
              setRetryDraft(draft);
              setCurrentView("documents");
            }}
            onOpenErrorModal={(draft) => setErrorDraft(draft)}
            showToast={showToast}
          />
        )}

        {currentView === "lesson-editor" && (
          selectedDraftId ? (
            <LessonEditorView
              draftId={selectedDraftId}
              onBack={() => setCurrentView("lessons")}
              onOpenPushOneNote={(d) => setPushOneNoteDraft(d)}
              showToast={showToast}
            />
          ) : (
            <LessonsView
              onOpenEditor={(id) => {
                setSelectedDraftId(id);
                setCurrentView("lesson-editor");
              }}
              onRetryPDF={(draft) => {
                setRetryDraft(draft);
                setCurrentView("documents");
              }}
              onOpenErrorModal={(draft) => setErrorDraft(draft)}
              showToast={showToast}
            />
          )
        )}

        {currentView === "documents" && (
          <DocumentsView
            initialDraft={retryDraft}
            onNavigateLessons={() => {
              setRetryDraft(null);
              setCurrentView("lessons");
            }}
            showToast={showToast}
          />
        )}

        {currentView === "grading" && (
          <GradingView
            onOpenGradingDetail={(id) => {
              setSelectedAssignmentId(id);
              setCurrentView("grading-detail");
            }}
            onOpenRemediation={(m) => setRemediationMistake(m)}
            showToast={showToast}
          />
        )}

        {currentView === "grading-detail" && (
          selectedAssignmentId ? (
            <GradingDetailView
              assignmentId={selectedAssignmentId}
              onBack={() => setCurrentView("grading")}
              showToast={showToast}
            />
          ) : (
            <GradingView
              onOpenGradingDetail={(id) => {
                setSelectedAssignmentId(id);
                setCurrentView("grading-detail");
              }}
              onOpenRemediation={(m) => setRemediationMistake(m)}
              showToast={showToast}
            />
          )
        )}

        {currentView === "settings" && (
          <SettingsView showToast={showToast} />
        )}

        {/* Fallback an toàn: Luôn hiển thị LessonsView nếu currentView bất thường */}
        {!["dashboard", "student-detail", "lessons", "lesson-editor", "documents", "grading", "grading-detail", "settings"].includes(currentView) && (
          <LessonsView
            onOpenEditor={(id) => {
              setSelectedDraftId(id);
              setCurrentView("lesson-editor");
            }}
            onRetryPDF={(draft) => {
              setRetryDraft(draft);
              setCurrentView("documents");
            }}
            onOpenErrorModal={(draft) => setErrorDraft(draft)}
            showToast={showToast}
          />
        )}
        </ErrorBoundary>
      </main>

      {/* Các Modals */}
      <ErrorModal draft={errorDraft} onClose={() => setErrorDraft(null)} showToast={showToast} />
      <OneNoteModal
        draft={pushOneNoteDraft}
        onClose={() => setPushOneNoteDraft(null)}
        showToast={showToast}
        onGoGrading={() => setCurrentView("grading")}
      />
      <RemediationModal
        mistake={remediationMistake}
        onClose={() => setRemediationMistake(null)}
        showToast={showToast}
        onGoLessons={() => setCurrentView("lessons")}
      />
    </div>
  );
}