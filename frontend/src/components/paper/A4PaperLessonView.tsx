import React, { useMemo } from 'react';
import { EditablePaperBlock } from './EditablePaperBlock';
import { MathText } from './MathText';
import { extractContentText } from '../../utils';
import { Lightbulb, BookOpen, HelpCircle, CheckCircle, GraduationCap, School, Compass, ListOrdered } from 'lucide-react';

export interface OptionView {
  label: string;
  content: any;
}

export interface EssayPartView {
  label: string;
  question: any;
  solution: any;
  rubric?: string;
}

export interface ExerciseView {
  type: string;
  topic?: string;
  difficulty?: string;
  question: any;
  options?: OptionView[];
  answer?: string;
  explanation?: any;
  parts?: EssayPartView[];
}

export interface BlockView {
  type: string;
  body?: any;
  math?: any;
  title?: any;
  problem?: any;
  solution?: any;
  explanation?: any;
  callout_kind?: string;
  items?: any[];
  ordered?: boolean;
}

export interface TopicView {
  title: any;
  blocks?: BlockView[];
  exercises?: ExerciseView[]; // Bài tập rèn luyện thuộc về chính Dạng toán này
}

export interface SectionView {
  title?: any;
  section_title?: any; // Tương thích ngược
  detailed_content?: any; // Tương thích ngược
  topics?: TopicView[];
}

interface ExerciseItemCardProps {
  ex: ExerciseView;
  exIdx: number;
  isTeacherMode: boolean;
  onUpdate: (fields: Partial<ExerciseView>) => void;
  onUpdateOption: (optIdx: number, content: string) => void;
}

// Component bài tập riêng biệt được tối ưu với React.memo
const ExerciseItemCard: React.FC<ExerciseItemCardProps> = React.memo(({
  ex,
  exIdx,
  isTeacherMode,
  onUpdate,
  onUpdateOption,
}) => {
  const isMCQ = ex.type === 'multiple-choice';

  return (
    <div className="rounded-md border border-slate-200 bg-white p-3.5 shadow-xs space-y-2.5">
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
                    value={opt.content || ''}
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
});

ExerciseItemCard.displayName = 'ExerciseItemCard';

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

export const A4PaperLessonView: React.FC<A4PaperLessonViewProps> = React.memo(({
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
  // Cập nhật khối Block trong Topic (sử dụng immutable shallow mapping)
  const updateBlock = (secIdx: number, topIdx: number, blockIdx: number, updatedFields: Partial<BlockView>) => {
    onSectionsChange(
      sections.map((sec, sIdx) => {
        if (sIdx !== secIdx) return sec;
        return {
          ...sec,
          topics: sec.topics?.map((top, tIdx) => {
            if (tIdx !== topIdx) return top;
            return {
              ...top,
              blocks: top.blocks?.map((b, bIdx) => {
                if (bIdx !== blockIdx) return b;
                return { ...b, ...updatedFields };
              }),
            };
          }),
        };
      })
    );
  };

  // Cập nhật tiêu đề Topic
  const updateTopicTitle = (secIdx: number, topIdx: number, newTitle: string) => {
    onSectionsChange(
      sections.map((sec, sIdx) => {
        if (sIdx !== secIdx) return sec;
        return {
          ...sec,
          topics: sec.topics?.map((top, tIdx) => {
            if (tIdx !== topIdx) return top;
            return { ...top, title: newTitle };
          }),
        };
      })
    );
  };

  // Cập nhật bài tập của chính Topic
  const updateTopicExercise = (secIdx: number, topIdx: number, exIdx: number, updatedFields: Partial<ExerciseView>) => {
    onSectionsChange(
      sections.map((sec, sIdx) => {
        if (sIdx !== secIdx) return sec;
        return {
          ...sec,
          topics: sec.topics?.map((top, tIdx) => {
            if (tIdx !== topIdx) return top;
            return {
              ...top,
              exercises: top.exercises?.map((ex, eIdx) => {
                if (eIdx !== exIdx) return ex;
                return { ...ex, ...updatedFields };
              }),
            };
          }),
        };
      })
    );
  };

  // Cập nhật option trắc nghiệm của Topic
  const updateTopicOption = (secIdx: number, topIdx: number, exIdx: number, optIdx: number, newContent: string) => {
    onSectionsChange(
      sections.map((sec, sIdx) => {
        if (sIdx !== secIdx) return sec;
        return {
          ...sec,
          topics: sec.topics?.map((top, tIdx) => {
            if (tIdx !== topIdx) return top;
            return {
              ...top,
              exercises: top.exercises?.map((ex, eIdx) => {
                if (eIdx !== exIdx) return ex;
                return {
                  ...ex,
                  options: ex.options?.map((opt, oIdx) => {
                    if (oIdx !== optIdx) return opt;
                    return { ...opt, content: newContent };
                  }),
                };
              }),
            };
          }),
        };
      })
    );
  };

  // Đếm tổng số bài tập trong các Topic để tránh render trùng lặp bài tập ở cuối
  const totalTopicExercises = useMemo(() => {
    return sections.reduce((acc, sec) => {
      return acc + (sec.topics?.reduce((tAcc, top) => tAcc + (top.exercises?.length || 0), 0) || 0);
    }, 0);
  }, [sections]);

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
                  {extractContentText(sec.title || sec.section_title || `Phần ${secIdx + 1}`)}
                </h3>
                <p className="text-sm text-slate-700 whitespace-pre-wrap">
                  {extractContentText(sec.detailed_content) || 'Chưa có nội dung chi tiết.'}
                </p>
              </div>
            );
          }

          return (
            <div key={secIdx} className="space-y-10">
              {sec.topics?.map((top, topIdx) => {
                const blocks = top.blocks || [];
                const theoryBlocks = blocks.filter((b) => b.type === 'paragraph' || b.type === 'definition' || b.type === 'theorem');
                const formulaBlocks = blocks.filter((b) => b.type === 'formula');
                const topicExercises = top.exercises || [];

                // 1. Phân định ranh giới giữa Khẩu quyết cốt lõi chung của Dạng toán (Mục I)
                // và Các khối thuộc Biến thể / Ví dụ (Mục II)
                const firstVariantIdx = blocks.findIndex((b) => {
                  if (!b) return false;
                  const bTitle = extractContentText(b.title);
                  return (
                    b.type === 'example' || 
                    b.type === 'list' || 
                    (b.type === 'callout' && (
                      bTitle.includes('Dấu hiệu nhận biết') || 
                      bTitle.includes('Casio') || 
                      bTitle.includes('Biến thể') ||
                      b.callout_kind === 'note'
                    ))
                  );
                });

                const coreCallouts: Array<{ block: BlockView; originalIdx: number }> = [];
                const variantCandidateBlocks: Array<{ block: BlockView; originalIdx: number }> = [];

                blocks.forEach((b, idx) => {
                  if (!b || b.type === 'paragraph' || b.type === 'definition' || b.type === 'theorem' || b.type === 'formula') {
                    return;
                  }

                  const bTitle = extractContentText(b.title);
                  const isBeforeVariant = firstVariantIdx === -1 || idx < firstVariantIdx;
                  const isGenericTip = b.type === 'callout' && 
                    (!bTitle || bTitle.includes('Khẩu quyết') || bTitle.includes('Mẹo giải nhanh')) && 
                    !bTitle.includes('Casio') && 
                    !bTitle.includes('Dấu hiệu');

                  if (isBeforeVariant && isGenericTip) {
                    coreCallouts.push({ block: b, originalIdx: idx });
                  } else {
                    variantCandidateBlocks.push({ block: b, originalIdx: idx });
                  }
                });

                // 2. Gom nhóm các blocks của Mục II thành từng cụm Biến thể / Ví dụ mẫu
                interface VariantGroupView {
                  id: string;
                  recognition?: { block: BlockView; originalIdx: number };
                  quickTip?: { block: BlockView; originalIdx: number };
                  actionSteps?: { block: BlockView; originalIdx: number };
                  example?: { block: BlockView; originalIdx: number };
                  otherBlocks: Array<{ block: BlockView; originalIdx: number }>;
                }

                const variantGroups: VariantGroupView[] = [];
                let currentGroup: VariantGroupView = { id: 'v-0', otherBlocks: [] };

                variantCandidateBlocks.forEach((item) => {
                  const b = item.block;
                  if (!b) return;
                  if (b.type === 'example') {
                    currentGroup.example = item;
                    variantGroups.push(currentGroup);
                    currentGroup = { id: `v-${variantGroups.length}`, otherBlocks: [] };
                  } else if (b.type === 'list') {
                    currentGroup.actionSteps = item;
                  } else if (b.type === 'callout') {
                    const titleLower = extractContentText(b.title).toLowerCase();
                    if (titleLower.includes('dấu hiệu') || b.callout_kind === 'note') {
                      currentGroup.recognition = item;
                    } else if (titleLower.includes('casio') || titleLower.includes('mẹo') || b.callout_kind === 'tip') {
                      currentGroup.quickTip = item;
                    } else {
                      currentGroup.otherBlocks.push(item);
                    }
                  } else {
                    currentGroup.otherBlocks.push(item);
                  }
                });

                if (currentGroup.recognition || currentGroup.quickTip || currentGroup.actionSteps || (currentGroup.otherBlocks && currentGroup.otherBlocks.length > 0)) {
                  variantGroups.push(currentGroup);
                }

                return (
                  <div key={topIdx} className="space-y-4 pt-2">
                    {/* TIÊU ĐỀ DẠNG TOÁN */}
                    <div className="flex items-center gap-2 border-b-2 border-blue-900/20 pb-1.5">
                      <BookOpen className="h-5 w-5 text-blue-800 shrink-0" />
                      <div className="flex-1 min-w-0">
                        <EditablePaperBlock
                          value={extractContentText(top.title)}
                          onChange={(newTitle) => updateTopicTitle(secIdx, topIdx, newTitle)}
                          placeholder="Tiêu đề dạng toán..."
                          textClassName="text-base font-bold text-blue-900"
                        />
                      </div>
                    </div>

                    {/* CARD I: LÝ THUYẾT & GHI NHỚ (CỦA DẠNG NÀY) */}
                    {(theoryBlocks.length > 0 || coreCallouts.length > 0 || formulaBlocks.length > 0) && (
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
                                    value={extractContentText(b.body)}
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

                        {/* Khẩu quyết cốt lõi chung của Dạng toán (CHỈ 1 THẺ DUY NHẤT) */}
                        {coreCallouts.map((cItem, cIdx) => (
                          <div key={cIdx} className="rounded-md border-l-4 border-emerald-500 bg-emerald-50/80 p-3 shadow-xs">
                            <div className="flex items-center gap-1.5 text-xs font-bold text-emerald-800 mb-1">
                              <Lightbulb className="h-4 w-4 text-emerald-600" />
                              💡 {extractContentText(cItem.block.title) || 'Mẹo giải nhanh & Khẩu quyết'}:
                            </div>
                            <EditablePaperBlock
                              value={extractContentText(cItem.block.body)}
                              multiline
                              onChange={(newBody) => updateBlock(secIdx, topIdx, cItem.originalIdx, { body: newBody })}
                              placeholder="Nội dung khẩu quyết ghi nhớ..."
                              textClassName="text-xs text-emerald-950 font-medium leading-relaxed"
                            />
                          </div>
                        ))}

                        {/* Công thức cốt lõi */}
                        {formulaBlocks.map((fBlock, fIdx) => {
                          const originalIdx = blocks.indexOf(fBlock);
                          return (
                            <div key={fIdx} className="flex items-center gap-2 text-xs font-semibold text-slate-700 bg-white p-2 rounded border border-slate-200">
                              <span className="text-teal-700 font-bold shrink-0">Công thức:</span>
                              <div className="flex-1">
                                <EditablePaperBlock
                                  value={extractContentText(fBlock.math || fBlock.body)}
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

                    {/* CARD II: CÁC BIẾN THỂ PHƯƠNG PHÁP GIẢI & VÍ DỤ MINH HỌA */}
                    {variantGroups.length > 0 && (
                      <div className="rounded-lg border border-slate-300 bg-[#f8fafc] p-4 shadow-xs space-y-4">
                        <h4 className="text-xs font-bold uppercase tracking-wider text-teal-800 flex items-center gap-1.5 border-b border-slate-200/70 pb-1.5">
                          <HelpCircle className="h-3.5 w-3.5 text-teal-600" />
                          II. Các biến thể phương pháp giải & Ví dụ mẫu
                        </h4>

                        <div className="space-y-4">
                          {variantGroups.map((group, gIdx) => {
                            const recRaw = extractContentText(group.recognition?.block.title);
                            const exRaw = extractContentText(group.example?.block.title);

                            let variantName = '';
                            let cleanRecPrefix = 'Dấu hiệu nhận biết đặc trưng';

                            if (recRaw.includes('-')) {
                              const parts = recRaw.split('-');
                              cleanRecPrefix = parts[0].trim() || 'Dấu hiệu nhận biết';
                              variantName = parts.slice(1).join('-').trim();
                            } else if (exRaw.includes('-')) {
                              const parts = exRaw.split('-');
                              variantName = parts.slice(1).join('-').trim();
                            } else if (recRaw) {
                              const trimmed = recRaw.replace(/^(Dấu hiệu nhận biết|Biến thể\s*\d*)[:\.-]?\s*/i, '').trim();
                              if (trimmed) {
                                variantName = trimmed;
                              }
                            }

                            if (!variantName) {
                              variantName = `Dạng biến thể ${gIdx + 1}`;
                            }

                            return (
                              <div key={gIdx} className="rounded-md border border-slate-200 bg-white p-4 shadow-xs space-y-3">
                                {/* HEADER ĐỊNH DANH BIẾN THỂ RÕ RÀNG */}
                                <div className="flex items-center justify-between border-b border-blue-100 pb-2 mb-2 bg-blue-50/60 -mx-4 -mt-4 px-4 py-2.5 rounded-t-md border-t border-x border-blue-200/70">
                                  <div className="flex items-center gap-2">
                                    <span className="bg-blue-600 text-white font-bold text-[11px] px-2.5 py-0.5 rounded shadow-2xs uppercase tracking-wider">
                                      Biến thể {gIdx + 1}
                                    </span>
                                    <span className="font-bold text-sm text-blue-950">
                                      {variantName}
                                    </span>
                                  </div>
                                </div>

                                {/* 1. DẤU HIỆU NHẬN BIẾT BIẾN THỂ (NẾU CÓ) */}
                                {group.recognition && (
                                  <div className="rounded-md border-l-4 border-sky-500 bg-sky-50/70 p-3 shadow-2xs">
                                    <div className="flex items-center gap-1.5 text-xs font-bold text-sky-800 mb-1">
                                      <Compass className="h-4 w-4 text-sky-600" />
                                      {cleanRecPrefix}:
                                    </div>
                                    <EditablePaperBlock
                                      value={extractContentText(group.recognition.block.body)}
                                      multiline
                                      onChange={(newBody) => updateBlock(secIdx, topIdx, group.recognition!.originalIdx, { body: newBody })}
                                      placeholder="Dấu hiệu nhận biết đặc trưng..."
                                      textClassName="text-xs text-slate-800 leading-relaxed font-medium"
                                    />
                                  </div>
                                )}

                                {/* 2. MẸO GIẢI NHANH & CASIO CỦA BIẾN THỂ (NẾU CÓ) */}
                                {group.quickTip && (
                                  <div className="rounded-md border-l-4 border-amber-500 bg-amber-50/70 p-3 shadow-2xs">
                                    <div className="flex items-center gap-1.5 text-xs font-bold text-amber-800 mb-1">
                                      <Lightbulb className="h-4 w-4 text-amber-600" />
                                      💡 {extractContentText(group.quickTip.block.title) || 'Mẹo giải nhanh & Casio:'}
                                    </div>
                                    <EditablePaperBlock
                                      value={extractContentText(group.quickTip.block.body)}
                                      multiline
                                      onChange={(newBody) => updateBlock(secIdx, topIdx, group.quickTip!.originalIdx, { body: newBody })}
                                      placeholder="Mẹo giải nhanh hoặc phản xạ Casio..."
                                      textClassName="text-xs text-amber-950 leading-relaxed font-medium"
                                    />
                                  </div>
                                )}

                                {/* 3. CÁC BƯỚC HÀNH ĐỘNG TUẦN TỰ (LISTBLOCK - NẾU CÓ) */}
                                {group.actionSteps && group.actionSteps.block.items && group.actionSteps.block.items.length > 0 && (
                                  <div className="rounded-md border-l-4 border-emerald-600 bg-emerald-50/50 p-3.5 space-y-2.5 shadow-2xs border border-emerald-200/70">
                                    <div className="flex items-center gap-1.5 text-xs font-bold text-emerald-900 uppercase tracking-wide">
                                      <ListOrdered className="h-4 w-4 text-emerald-700" />
                                      <span>Các bước giải tuần tự:</span>
                                    </div>
                                    <div className="space-y-2">
                                      {group.actionSteps.block.items.map((step, sIdx) => {
                                        const stepText = extractContentText(step);
                                        const match = stepText.match(/^(Bước\s*\d+|B\d+)[:\.-]?\s*(.*)/i);
                                        const stepLabel = match ? match[1] : `Bước ${sIdx + 1}`;
                                        const stepBody = match ? match[2] : stepText;

                                        return (
                                          <div
                                            key={sIdx}
                                            className="flex items-start gap-2.5 p-2.5 bg-white/95 rounded-md border border-emerald-200/80 shadow-2xs hover:border-emerald-300 transition-colors"
                                          >
                                            <span className="font-bold text-emerald-900 bg-emerald-100/90 px-2 py-0.5 rounded text-[11px] shrink-0 border border-emerald-300/80 shadow-2xs select-none">
                                              {stepLabel}
                                            </span>
                                            <div className="flex-1 min-w-0 text-slate-800 font-medium pt-0.5">
                                              <EditablePaperBlock
                                                value={stepBody}
                                                multiline
                                                onChange={(newText) => {
                                                  const newItems = [...(group.actionSteps?.block.items || [])];
                                                  const fullText = match ? `${stepLabel}: ${newText}` : newText;
                                                  newItems[sIdx] = fullText;
                                                  updateBlock(secIdx, topIdx, group.actionSteps!.originalIdx, { items: newItems });
                                                }}
                                                placeholder="Nội dung bước giải..."
                                                textClassName="text-xs font-semibold text-slate-800 leading-relaxed"
                                              />
                                            </div>
                                          </div>
                                        );
                                      })}
                                    </div>
                                  </div>
                                )}

                                {/* 4. VÍ DỤ MINH HỌA GIẢI MẪU (NẾU CÓ) */}
                                {group.example && (
                                  <div className="space-y-2 pt-1 border-t border-slate-100">
                                    <div className="flex items-center gap-1.5 text-xs font-bold text-teal-800">
                                      <EditablePaperBlock
                                        value={extractContentText(group.example.block.title) || `Ví dụ ${gIdx + 1}`}
                                        onChange={(newT) => updateBlock(secIdx, topIdx, group.example!.originalIdx, { title: newT })}
                                        textClassName="text-xs font-bold text-teal-800"
                                      />
                                    </div>

                                    <div className="text-sm text-slate-800">
                                      <EditablePaperBlock
                                        value={extractContentText(group.example.block.problem)}
                                        multiline
                                        onChange={(newP) => updateBlock(secIdx, topIdx, group.example!.originalIdx, { problem: newP })}
                                        placeholder="Đề bài ví dụ mẫu..."
                                        textClassName="text-sm leading-relaxed"
                                      />
                                    </div>

                                    {/* Lời giải ví dụ mẫu (Hiển thị cho cả giáo viên và học sinh) */}
                                    <div className="pt-2 border-t border-slate-100 mt-2">
                                      <span className="text-xs font-bold text-emerald-700 block mb-0.5">Lời giải mẫu:</span>
                                      <EditablePaperBlock
                                        value={extractContentText(group.example.block.solution)}
                                        multiline
                                        onChange={(newS) => updateBlock(secIdx, topIdx, group.example!.originalIdx, { solution: newS })}
                                        placeholder="Lời giải chi tiết mẫu..."
                                        textClassName="text-xs text-slate-700 leading-relaxed"
                                      />
                                    </div>
                                  </div>
                                )}

                                {/* 5. KHỐI PHỤ KHÁC (NẾU CÓ) */}
                                {group.otherBlocks && group.otherBlocks.length > 0 && (
                                  <div className="space-y-2">
                                    {group.otherBlocks.map((ob, oIdx) => (
                                      <div key={oIdx} className="text-xs text-slate-700">
                                        <EditablePaperBlock
                                          value={extractContentText(ob.block.body)}
                                          multiline
                                          onChange={(newB) => updateBlock(secIdx, topIdx, ob.originalIdx, { body: newB })}
                                        />
                                      </div>
                                    ))}
                                  </div>
                                )}
                              </div>
                            );
                          })}
                        </div>
                      </div>
                    )}

                    {/* CARD III: BÀI TẬP RÈN LUYỆN (CỦA CHÍNH DẠNG NÀY) */}
                    {topicExercises.length > 0 && (
                      <div className="rounded-lg border border-slate-300 bg-[#f8fafc] p-4 shadow-xs space-y-4">
                        <h4 className="text-xs font-bold uppercase tracking-wider text-teal-800 flex items-center gap-1.5 border-b border-slate-200/70 pb-1.5">
                          <CheckCircle className="h-3.5 w-3.5 text-teal-600" />
                          III. Bài tập rèn luyện & Phản xạ (Theo dạng)
                        </h4>

                        <div className="space-y-3">
                          {topicExercises.map((ex, exIdx) => (
                            <ExerciseItemCard
                              key={exIdx}
                              ex={ex}
                              exIdx={exIdx}
                              isTeacherMode={isTeacherMode}
                              onUpdate={(fields) => updateTopicExercise(secIdx, topIdx, exIdx, fields)}
                              onUpdateOption={(optIdx, val) => updateTopicOption(secIdx, topIdx, exIdx, optIdx, val)}
                            />
                          ))}
                        </div>
                      </div>
                    )}
                  </div>
                );
              })}
            </div>
          );
        })}

        {/* TƯƠNG THÍCH NGƯỢC: CHỈ HIỂN THỊ KHI CÁC TOPICS CHƯA CÓ BÀI TẬP NÀO */}
        {totalTopicExercises === 0 && exercises.length > 0 && (
          <div className="rounded-lg border border-slate-300 bg-[#f8fafc] p-4 shadow-xs space-y-4 pt-4 mt-6">
            <h4 className="text-xs font-bold uppercase tracking-wider text-teal-800 flex items-center gap-1.5 border-b border-slate-200/70 pb-1.5">
              <CheckCircle className="h-3.5 w-3.5 text-teal-600" />
              Bài tập tổng hợp
            </h4>

            <div className="space-y-3">
              {exercises.map((ex, exIdx) => (
                <ExerciseItemCard
                  key={exIdx}
                  ex={ex}
                  exIdx={exIdx}
                  isTeacherMode={isTeacherMode}
                  onUpdate={(fields) => {
                    const newExercises = exercises.map((item, i) => (i === exIdx ? { ...item, ...fields } : item));
                    if (onExercisesChange) onExercisesChange(newExercises);
                  }}
                  onUpdateOption={(optIdx, val) => {
                    const newExercises = exercises.map((item, i) => {
                      if (i !== exIdx) return item;
                      const newOpts = item.options?.map((opt, oIdx) => (oIdx === optIdx ? { ...opt, content: val } : opt));
                      return { ...item, options: newOpts };
                    });
                    if (onExercisesChange) onExercisesChange(newExercises);
                  }}
                />
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
});

A4PaperLessonView.displayName = 'A4PaperLessonView';
