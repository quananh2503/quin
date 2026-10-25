import React, { useState, useRef, useEffect } from 'react';
import { Pencil, Check, X } from 'lucide-react';
import { MathText } from './MathText';

interface EditablePaperBlockProps {
  value: string;
  onChange: (newValue: string) => void;
  placeholder?: string;
  multiline?: boolean;
  className?: string;
  textClassName?: string;
  label?: string;
  disabled?: boolean;
}

export const EditablePaperBlock: React.FC<EditablePaperBlockProps> = ({
  value,
  onChange,
  placeholder = 'Nhấp để nhập nội dung...',
  multiline = false,
  className = '',
  textClassName = '',
  label,
  disabled = false,
}) => {
  const [isEditing, setIsEditing] = useState(false);
  const [draft, setDraft] = useState(value);
  const inputRef = useRef<HTMLInputElement | HTMLTextAreaElement | null>(null);

  useEffect(() => {
    setDraft(value);
  }, [value]);

  useEffect(() => {
    if (isEditing && inputRef.current) {
      inputRef.current.focus();
      // Tự động chỉnh độ cao nếu là textarea
      if (multiline && inputRef.current instanceof HTMLTextAreaElement) {
        inputRef.current.style.height = 'auto';
        inputRef.current.style.height = `${inputRef.current.scrollHeight}px`;
      }
    }
  }, [isEditing, multiline]);

  const handleSave = () => {
    setIsEditing(false);
    if (draft !== value) {
      onChange(draft);
    }
  };

  const handleCancel = () => {
    setDraft(value);
    setIsEditing(false);
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Escape') {
      handleCancel();
    } else if (e.key === 'Enter' && !multiline) {
      handleSave();
    } else if (e.key === 'Enter' && e.ctrlKey && multiline) {
      handleSave();
    }
  };

  const handleTextareaChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setDraft(e.target.value);
    e.target.style.height = 'auto';
    e.target.style.height = `${e.target.scrollHeight}px`;
  };

  if (disabled) {
    return (
      <div className={className}>
        <MathText content={value || placeholder} className={textClassName} />
      </div>
    );
  }

  if (isEditing) {
    return (
      <div className={`relative group/edit rounded-md border-2 border-emerald-400 bg-emerald-50/20 p-2 shadow-sm ${className}`}>
        {label && (
          <span className="mb-1 block text-xs font-semibold text-emerald-700">{label}</span>
        )}
        {multiline ? (
          <textarea
            ref={inputRef as React.RefObject<HTMLTextAreaElement>}
            value={draft}
            onChange={handleTextareaChange}
            onKeyDown={handleKeyDown}
            placeholder={placeholder}
            className="w-full resize-none bg-transparent font-sans text-slate-800 outline-none leading-relaxed"
            rows={2}
          />
        ) : (
          <input
            ref={inputRef as React.RefObject<HTMLInputElement>}
            type="text"
            value={draft}
            onChange={(e) => setDraft(e.target.value)}
            onKeyDown={handleKeyDown}
            placeholder={placeholder}
            className="w-full bg-transparent font-sans text-slate-800 outline-none"
          />
        )}
        <div className="mt-2 flex items-center justify-end gap-1.5 pt-1 border-t border-emerald-200/60">
          <span className="text-[11px] text-slate-500 mr-auto">
            {multiline ? 'Nhấn Ctrl+Enter hoặc ✓ để xong' : 'Nhấn Enter hoặc ✓ để xong'}
          </span>
          <button
            type="button"
            onClick={handleCancel}
            className="flex items-center gap-1 rounded px-2 py-0.5 text-xs font-medium text-slate-600 hover:bg-slate-200"
          >
            <X className="h-3.5 w-3.5" /> Hủy
          </button>
          <button
            type="button"
            onClick={handleSave}
            className="flex items-center gap-1 rounded bg-emerald-600 px-2.5 py-0.5 text-xs font-medium text-white shadow-sm hover:bg-emerald-700"
          >
            <Check className="h-3.5 w-3.5" /> Xong
          </button>
        </div>
      </div>
    );
  }

  const isEmpty = !value || value.trim() === '';

  return (
    <div
      onClick={() => setIsEditing(true)}
      title="Nhấp để sửa văn bản"
      className={`group/view relative cursor-pointer rounded px-1.5 py-1 transition-all duration-150 hover:bg-emerald-50/60 hover:ring-1 hover:ring-emerald-300 ${className}`}
    >
      <div className="flex items-start justify-between gap-2">
        <div className="min-w-0 flex-1">
          {isEmpty ? (
            <span className="italic text-slate-400">{placeholder}</span>
          ) : (
            <MathText content={value} className={textClassName} />
          )}
        </div>
        <div className="shrink-0 opacity-0 transition-opacity group-hover/view:opacity-100 text-emerald-600 pl-1">
          <Pencil className="h-3.5 w-3.5" />
        </div>
      </div>
    </div>
  );
};
