import React from 'react';
import { EditablePaperBlock } from './EditablePaperBlock';
import { Lightbulb, BookOpen, HelpCircle, CheckCircle, GraduationCap, School } from 'lucide-react';

export interface OptionView {
  label: string;
  content: string;
}

export interface EssayPartView {
  label: string;
  question: string;
  solution: string;
  rubric: string;
}

export interface ExerciseView {
  type: string;
  topic?: string;
  difficulty?: string;
  question: string;
  options?: OptionView[];
  answer?: string;
  explanation?: string;
  parts?: EssayPartView[];
}

export interface BlockView {
  type: string;
  body?: string;
  math?: string;
  title?: string;
  problem?: string;
  solution?: string;
  callout_kind?: string;
}

export interface TopicView {
  title: string;
  blocks?: BlockView[];
  exercises?: ExerciseView[]; // 🌟 Bài tập rèn luyện thuộc về chính Dạng toán này
}

export interface SectionView {
  title?: string;
  section_title?: string; // Tương thích ngược
  detailed_content?: string; // Tương thích ngược
  topics?: TopicView[];
}

interface A4PaperLessonViewProps {
  title: string;
  onTitleChange: (val: string) => void;
  overview: string;
  onOverviewChange: (val: string) => void;
  sections: SectionView[];
  onSectionsChange: (sections: SectionView[]) => void;
  exercises?: ExerciseView[]; // Dành cho tương thích bài cũ
  onExercisesChange?: (exercises: ExerciseView[]) => void;
  isTeacherMode: boolean;
}

export const A4PaperLessonView: React.FC<A4PaperLessonViewProps> = ({
  title,
  onTitleChange,
  overview,
  onOverviewChange,
  sections,
  onSectionsChange,
  exercises = [],
  onExercisesChange,
  isTeacherMode,
}) => {
  // Cập nhật khối Block trong Topic
  const updateBlock = (secIdx: number, topIdx: number, blockIdx: number, updatedFields: Partial<BlockView>) => {
    const newSections = JSON.parse(JSON.stringify(sections));
    const target = newSections[secIdx]?.topics?.[topIdx]?.blocks?.[blockIdx];
    if (target) {
      Object.assign(target, updatedFields);
      onSectionsChange(newSections);
    }
  };

  // Cập nhật tiêu đề Topic
  const updateTopicTitle = (secIdx: number, topIdx: number, newTitle: string) => {
    const newSections = JSON.parse(JSON.stringify(sections));
    if (newSections[secIdx]?.topics?.[topIdx]) {
      newSections[secIdx].topics[topIdx].title = newTitle;
      onSectionsChange(newSections);
    }
  };

  // Cập nhật bài tập của chính Topic
  const updateTopicExercise = (secIdx: number, topIdx: number, exIdx: number, updatedFields: Partial<ExerciseView>) => {
    const newSections = JSON.parse(JSON.stringify(sections));
    const target = newSections[secIdx]?.topics?.[topIdx]?.exercises?.[exIdx];
    if (target) {
      Object.assign(target, updatedFields);
      onSectionsChange(newSections);
    }
  };

  // Cập nhật option trắc nghiệm của Topic
  const updateTopicOption = (secIdx: number, topIdx: number, exIdx: number, optIdx: number, newContent: string) => {
    const newSections = JSON.parse(JSON.stringify(sections));
    const target = newSections[secIdx]?.topics?.[topIdx]?.exercises?.[exIdx]?.options?.[optIdx];
    if (target) {
      target.content = newContent;
      onSectionsChange(newSections);
    }
  };

  // Render một bài tập cụ thể
  const renderExerciseItem = (
    ex: ExerciseView,
    exIdx: number,
    onUpdate: (fields: Partial<ExerciseView>) => void,
    onUpdateOption: (optIdx: number, content: string) => void
  ) => {
    const isMCQ = ex.type === 'multiple-choice';

    return (
      <div key={exIdx} className="rounded-md border border-slate-200 bg-white p-3.5 shadow-xs space-y-2.5">
        {/* TIÊU ĐỀ & ĐỀ BÀI */}
        <div className="flex items-start gap-2">
          <span className="font-bold text-xs text-blue-900 bg-blue-50 px-2 py-0.5 rounded border border-blue-200 shrink-0 select-none">
            Bài {exIdx + 1}
          </span>
          <div className="flex-1 min-w-0">
            <EditablePaperBlock
              value={ex.question || ''}
              multiline
              onChange={(newQ) => onUpdate({ question: newQ })}
              placeholder="Nội dung đề bài tập..."
              textClassName="text-sm font-medium text-slate-800 leading-relaxed"
            />
          </div>
        </div>

        {/* NẾU LÀ TRẮC NGHIỆM: HIỂN THỊ CÁC LỰA CHỌN A, B, C, D */}
        {isMCQ && ex.options && ex.options.length > 0 && (
          <div className="grid grid-cols-2 gap-2 pt-1 pl-4">
            {ex.options.map((opt, optIdx) => {
              const isCorrect = isTeacherMode && ex.answer === opt.label;
              return (
                <div
                  key={optIdx}
                  className={`flex items-center gap-2 rounded px-2.5 py-1 text-xs border ${
                    isCorrect
                      ? 'bg-emerald-50 border-emerald-300 font-bold text-emerald-900 ring-1 ring-emerald-400'
                      : 'bg-slate-50/50 border-slate-200 text-slate-700'
                  }`}
                >
                  <span className="font-bold select-none text-slate-600">{opt.label}.</span>
                  <div className="flex-1">
                    <EditablePaperBlock
                      value={opt.content}
                      onChange={(newC) => onUpdateOption(optIdx, newC)}
                      placeholder="Phương án..."
                      textClassName="text-xs"
                    />
                  </div>
                </div>
              );
            })}
          </div>
        )}

        {/* HIỂN THỊ THEO CHẾ ĐỘ GIÁO VIÊN / HỌC SINH */}
        {isTeacherMode ? (
          <div className="pt-2 border-t border-slate-100 text-xs space-y-1">
            {isMCQ && ex.answer && (
              <div className="font-bold text-emerald-700 flex items-center gap-1.5">
                <span>Đáp án đúng:</span>
                <span className="px-2 py-0.5 rounded bg-emerald-100 text-emerald-900 border border-emerald-300">
                  {ex.answer}
                </span>
              </div>
            )}
            <div className="text-slate-700 pt-1">
              <span className="font-bold text-emerald-700 block mb-0.5">Lời giải chi tiết:</span>
              <EditablePaperBlock
                value={ex.explanation || (ex.parts?.[0]?.solution) || ''}
                multiline
                onChange={(newSol) => {
                  if (isMCQ) {
                    onUpdate({ explanation: newSol });
                  } else {
                    const newParts = [...(ex.parts || [])];
                    if (newParts.length > 0) {
                      newParts[0] = { ...newParts[0], solution: newSol };
                    }
                    onUpdate({ explanation: newSol, parts: newParts });
                  }
                }}
                placeholder="Lời giải chi tiết..."
                textClassName="text-xs text-slate-600 leading-relaxed"
              />
            </div>
          </div>
        ) : (
          /* BẢN HỌC SINH: CHỪA KHUNG NÉT ĐỨT ĐỂ LÀM BÀI */
          <div className="h-14 rounded border border-dashed border-slate-300 bg-slate-50/40 p-2 flex items-start text-xs text-slate-400 select-none">
            ✍️ Bài làm / Đáp số:
          </div>
        )}
      </div>
    );
  };

  return (
    <div className="w-full flex justify-center py-6 px-4 bg-slate-100/80 min-h-screen">
      {/* TỜ GIẤY IN A4 */}
      <div className="w-full max-w-[850px] min-h-[1100px] bg-white shadow-2xl rounded-sm p-12 mx-auto border border-slate-200 transition-all font-sans text-slate-800 space-y-6">
        
        {/* BANNER HEADER: GIÁO VIÊN / HỌC SINH */}
        <div className="text-center pb-4 border-b border-slate-200 space-y-2">
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold tracking-wide uppercase shadow-xs">
            {isTeacherMode ? (
              <span className="bg-blue-50 text-blue-800 border border-blue-200 px-3 py-1 rounded-full flex items-center gap-1.5">
                <GraduationCap className="h-4 w-4 text-blue-700" />
                Giáo Án Giảng Dạy & Đáp Án (Giáo Viên)
              </span>
            ) : (
              <span className="bg-teal-50 text-teal-800 border border-teal-200 px-3 py-1 rounded-full flex items-center gap-1.5">
                <School className="h-4 w-4 text-teal-700" />
                Phiếu Bài Tập & Rèn Luyện (Học Sinh)
              </span>
            )}
          </div>

          {/* TIÊU ĐỀ BÀI HỌC (CLICK TO EDIT) */}
          <div className="pt-2">
            <EditablePaperBlock
              value={title}
              onChange={onTitleChange}
              placeholder="Nhập tiêu đề bài học..."
              label="Tiêu đề bài học"
              className="text-center"
              textClassName="text-2xl font-black tracking-tight text-slate-900 block"
            />
          </div>

          {/* TỔNG QUAN / MỤC TIÊU BÀI HỌC */}
          <div className="max-w-xl mx-auto">
            <EditablePaperBlock
              value={overview}
              onChange={onOverviewChange}
              multiline
              placeholder="Nhập tổng quan mục tiêu kiến thức bài học..."
              label="Tổng quan bài học"
              className="text-center"
              textClassName="text-xs italic text-slate-500 leading-relaxed block"
            />
          </div>
        </div>

        {/* NỘI DUNG TỪNG DẠNG TOÁN (TOPICS) */}
        {sections.map((sec, secIdx) => {
          const hasTopics = Array.isArray(sec.topics) && sec.topics.length > 0;

          if (!hasTopics) {
            // Tương thích ngược: Bài cũ chỉ có detailed_content
            return (
              <div key={secIdx} className="space-y-3 p-4 bg-slate-50/70 border border-slate-200 rounded-lg">
                <h3 className="font-bold text-base text-slate-900">
                  {sec.title || sec.section_title || `Phần ${secIdx + 1}`}
                </h3>
                <p className="text-sm text-slate-700 whitespace-pre-wrap">
                  {sec.detailed_content || 'Chưa có nội dung chi tiết.'}
                </p>
              </div>
            );
          }

          return (
            <div key={secIdx} className="space-y-10">
              {sec.topics?.map((top, topIdx) => {
                const blocks = top.blocks || [];
                const theoryBlocks = blocks.filter((b) => b.type === 'paragraph' || b.type === 'definition' || b.type === 'theorem');
                const calloutBlocks = blocks.filter((b) => b.type === 'callout');
                const formulaBlocks = blocks.filter((b) => b.type === 'formula');
                const exampleBlocks = blocks.filter((b) => b.type === 'example');
                const topicExercises = top.exercises || [];

                return (
                  <div key={topIdx} className="space-y-4 pt-2">
                    {/* TIÊU ĐỀ DẠNG TOÁN */}
                    <div className="flex items-center gap-2 border-b-2 border-blue-900/20 pb-1.5">
                      <BookOpen className="h-5 w-5 text-blue-800 shrink-0" />
                      <div className="flex-1 min-w-0">
                        <EditablePaperBlock
                          value={top.title}
                          onChange={(newTitle) => updateTopicTitle(secIdx, topIdx, newTitle)}
                          placeholder="Tiêu đề dạng toán..."
                          textClassName="text-base font-bold text-blue-900"
                        />
                      </div>
                    </div>

                    {/* CARD I: LÝ THUYẾT & GHI NHỚ (CỦA DẠNG NÀY) */}
                    {(theoryBlocks.length > 0 || calloutBlocks.length > 0 || formulaBlocks.length > 0) && (
                      <div className="rounded-lg border border-slate-300 bg-[#f8fafc] p-4 shadow-xs space-y-3">
                        <h4 className="text-xs font-bold uppercase tracking-wider text-teal-800 flex items-center gap-1.5 border-b border-slate-200/70 pb-1.5">
                          <CheckCircle className="h-3.5 w-3.5 text-teal-600" />
                          I. Lý thuyết & Ghi nhớ
                        </h4>

                        {/* Các ý lý thuyết cốt lõi */}
                        <div className="space-y-1.5 pl-1">
                          {blocks.map((b, bIdx) => {
                            if (b.type !== 'paragraph' && b.type !== 'definition' && b.type !== 'theorem') return null;
                            return (
                              <div key={bIdx} className="flex items-start gap-2 text-sm text-slate-800">
                                <span className="font-bold text-teal-700 select-none">•</span>
                                <div className="flex-1">
                                  <EditablePaperBlock
                                    value={b.body || ''}
                                    multiline
                                    onChange={(newBody) => updateBlock(secIdx, topIdx, bIdx, { body: newBody })}
                                    placeholder="Nội dung ý lý thuyết..."
                                    textClassName="text-sm leading-relaxed"
                                  />
                                </div>
                              </div>
                            );
                          })}
                        </div>

                        {/* Mẹo nhớ siêu tốc (Callout) */}
                        {calloutBlocks.map((cBlock, cIdx) => {
                          const originalIdx = blocks.indexOf(cBlock);
                          return (
                            <div key={cIdx} className="rounded-md border-l-4 border-emerald-500 bg-emerald-50/80 p-3 shadow-xs">
                              <div className="flex items-center gap-1.5 text-xs font-bold text-emerald-800 mb-1">
                                <Lightbulb className="h-4 w-4 text-emerald-600" />
                                💡 Mẹo giải nhanh & Khẩu quyết:
                              </div>
                              <EditablePaperBlock
                                value={cBlock.body || ''}
                                multiline
                                onChange={(newBody) => updateBlock(secIdx, topIdx, originalIdx, { body: newBody })}
                                placeholder="Nội dung mẹo nhớ..."
                                textClassName="text-xs text-emerald-950 font-medium leading-relaxed"
                              />
                            </div>
                          );
                        })}

                        {/* Công thức cốt lõi */}
                        {formulaBlocks.map((fBlock, fIdx) => {
                          const originalIdx = blocks.indexOf(fBlock);
                          return (
                            <div key={fIdx} className="flex items-center gap-2 text-xs font-semibold text-slate-700 bg-white p-2 rounded border border-slate-200">
                              <span className="text-teal-700 font-bold shrink-0">Công thức:</span>
                              <div className="flex-1">
                                <EditablePaperBlock
                                  value={fBlock.math || fBlock.body || ''}
                                  onChange={(newMath) => updateBlock(secIdx, topIdx, originalIdx, { math: newMath, body: newMath })}
                                  placeholder="Công thức cốt lõi..."
                                  textClassName="font-mono text-xs"
                                />
                              </div>
                            </div>
                          );
                        })}
                      </div>
                    )}

                    {/* CARD II: VÍ DỤ MINH HỌA GIẢI MẪU (CỦA DẠNG NÀY) */}
                    {exampleBlocks.length > 0 && (
                      <div className="rounded-lg border border-slate-300 bg-[#f8fafc] p-4 shadow-xs space-y-3">
                        <h4 className="text-xs font-bold uppercase tracking-wider text-teal-800 flex items-center gap-1.5 border-b border-slate-200/70 pb-1.5">
                          <HelpCircle className="h-3.5 w-3.5 text-teal-600" />
                          II. Ví dụ minh họa giải mẫu
                        </h4>

                        <div className="space-y-3">
                          {exampleBlocks.map((exBlock, eIdx) => {
                            const originalIdx = blocks.indexOf(exBlock);
                            return (
                              <div key={eIdx} className="rounded-md border border-slate-200 bg-white p-3.5 shadow-xs space-y-2">
                                <div className="flex items-center gap-1.5 text-xs font-bold text-sky-800">
                                  <EditablePaperBlock
                                    value={exBlock.title || `Ví dụ ${eIdx + 1}`}
                                    onChange={(newT) => updateBlock(secIdx, topIdx, originalIdx, { title: newT })}
                                    textClassName="text-xs font-bold text-sky-800"
                                  />
                                </div>

                                <div className="text-sm text-slate-800">
                                  <EditablePaperBlock
                                    value={exBlock.problem || ''}
                                    multiline
                                    onChange={(newP) => updateBlock(secIdx, topIdx, originalIdx, { problem: newP })}
                                    placeholder="Đề bài ví dụ mẫu..."
                                    textClassName="text-sm leading-relaxed"
                                  />
                                </div>

                                {/* Lời giải ví dụ mẫu */}
                                {isTeacherMode ? (
                                  <div className="pt-2 border-t border-slate-100 mt-2">
                                    <span className="text-xs font-bold text-emerald-700 block mb-0.5">Lời giải mẫu:</span>
                                    <EditablePaperBlock
                                      value={exBlock.solution || ''}
                                      multiline
                                      onChange={(newS) => updateBlock(secIdx, topIdx, originalIdx, { solution: newS })}
                                      placeholder="Lời giải chi tiết..."
                                      textClassName="text-xs text-slate-700 leading-relaxed"
                                    />
                                  </div>
                                ) : (
                                  <div className="h-10 rounded border border-dashed border-slate-200 flex items-center justify-center text-xs text-slate-400 italic">
                                    (Khoảng trống theo dõi bài giảng của giáo viên)
                                  </div>
                                )}
                              </div>
                            );
                          })}
                        </div>
                      </div>
                    )}

                    {/* 🌟 CARD III: BÀI TẬP RÈN LUYỆN (CỦA CHÍNH DẠNG NÀY) */}
                    {topicExercises.length > 0 && (
                      <div className="rounded-lg border border-slate-300 bg-[#f8fafc] p-4 shadow-xs space-y-4">
                        <h4 className="text-xs font-bold uppercase tracking-wider text-teal-800 flex items-center gap-1.5 border-b border-slate-200/70 pb-1.5">
                          <CheckCircle className="h-3.5 w-3.5 text-teal-600" />
                          III. Bài tập rèn luyện & Phản xạ (Theo dạng)
                        </h4>

                        <div className="space-y-3">
                          {topicExercises.map((ex, exIdx) =>
                            renderExerciseItem(
                              ex,
                              exIdx,
                              (fields) => updateTopicExercise(secIdx, topIdx, exIdx, fields),
                              (optIdx, val) => updateTopicOption(secIdx, topIdx, exIdx, optIdx, val)
                            )
                          )}
                        </div>
                      </div>
                    )}
                  </div>
                );
              })}
            </div>
          );
        })}

        {/* TƯƠNG THÍCH NGƯỢC: NẾU BÀI CŨ CÓ EXERCISES Ở CẤP GỐC MÀ TOPIC CHƯA CÓ */}
        {exercises.length > 0 && (
          <div className="rounded-lg border border-slate-300 bg-[#f8fafc] p-4 shadow-xs space-y-4 pt-4 mt-6">
            <h4 className="text-xs font-bold uppercase tracking-wider text-teal-800 flex items-center gap-1.5 border-b border-slate-200/70 pb-1.5">
              <CheckCircle className="h-3.5 w-3.5 text-teal-600" />
              Bài tập tổng hợp
            </h4>

            <div className="space-y-3">
              {exercises.map((ex, exIdx) =>
                renderExerciseItem(
                  ex,
                  exIdx,
                  (fields) => {
                    const newExercises = JSON.parse(JSON.stringify(exercises));
                    Object.assign(newExercises[exIdx], fields);
                    if (onExercisesChange) onExercisesChange(newExercises);
                  },
                  (optIdx, val) => {
                    const newExercises = JSON.parse(JSON.stringify(exercises));
                    if (newExercises[exIdx]?.options?.[optIdx]) {
                      newExercises[exIdx].options[optIdx].content = val;
                      if (onExercisesChange) onExercisesChange(newExercises);
                    }
                  }
                )
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
