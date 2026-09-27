import React, { useState } from 'react';
import { Sidebar } from './components/Sidebar';
import { DashboardView } from './components/views/DashboardView';
import { StudentDetailView } from './components/views/StudentDetailView';
import { LessonsView } from './components/views/LessonsView';
import { LessonEditorView } from './components/views/LessonEditorView';
import { DocumentsView } from './components/views/DocumentsView';
import { GradingView } from './components/views/GradingView';
import { GradingDetailView } from './components/views/GradingDetailView';
import { ErrorModal } from './components/modals/ErrorModal';
import { OneNoteModal } from './components/modals/OneNoteModal';
import { RemediationModal } from './components/modals/RemediationModal';

export default function App() {
  const [currentView, setCurrentView] = useState("dashboard");
  const [selectedStudentId, setSelectedStudentId] = useState<string | null>(null);
  const [selectedRange, setSelectedRange] = useState<{
  from: Date;
  to: Date;
} | null>(null);
  const [selectedDraftId, setSelectedDraftId] = useState<string | null>(null);
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
      <main className="flex-1 h-screen overflow-y-auto">
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

        {currentView === "student-detail" && selectedStudentId && selectedRange && (
        <StudentDetailView
          studentId={selectedStudentId}
          fromDate={selectedRange.from}
          toDate={selectedRange.to}
          onBack={() => setCurrentView("dashboard")}
          showToast={showToast}
        />
      )}

        {currentView === "lessons" && (
          <LessonsView
            onOpenEditor={(id) => {
              setSelectedDraftId(id);
              setCurrentView("lesson-editor");
            }}
            onOpenErrorModal={(draft) => setErrorDraft(draft)}
            showToast={showToast}
          />
        )}

        {currentView === "lesson-editor" && selectedDraftId && (
          <LessonEditorView
            draftId={selectedDraftId}
            onBack={() => setCurrentView("lessons")}
            onOpenPushOneNote={(d) => setPushOneNoteDraft(d)}
            showToast={showToast}
          />
        )}

        {currentView === "documents" && (
          <DocumentsView
            onNavigateLessons={() => setCurrentView("lessons")}
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

        {currentView === "grading-detail" && selectedAssignmentId && (
          <GradingDetailView
            assignmentId={selectedAssignmentId}
            onBack={() => setCurrentView("grading")}
            showToast={showToast}
          />
        )}
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