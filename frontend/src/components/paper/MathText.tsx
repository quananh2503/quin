import React, { useMemo } from 'react';
import katex from 'katex';

interface MathTextProps {
  content: string;
  className?: string;
}

export const MathText: React.FC<MathTextProps> = ({ content, className = '' }) => {
  const parts = useMemo(() => {
    if (!content) return [];

    // Regex phân tách $$...$$ (khối công thức lớn) và $...$ (công thức nội dòng)
    const regex = /(\$\$[\s\S]+?\$\$|\$[^\$\n]+?\$)/g;
    const tokens: Array<{ type: 'text' | 'inline-math' | 'block-math'; value: string }> = [];

    let lastIndex = 0;
    let match: RegExpExecArray | null;

    while ((match = regex.exec(content)) !== null) {
      if (match.index > lastIndex) {
        tokens.push({ type: 'text', value: content.substring(lastIndex, match.index) });
      }

      const raw = match[0];
      if (raw.startsWith('$$') && raw.endsWith('$$')) {
        tokens.push({ type: 'block-math', value: raw.slice(2, -2).trim() });
      } else if (raw.startsWith('$') && raw.endsWith('$')) {
        tokens.push({ type: 'inline-math', value: raw.slice(1, -1).trim() });
      }

      lastIndex = regex.lastIndex;
    }

    if (lastIndex < content.length) {
      tokens.push({ type: 'text', value: content.substring(lastIndex) });
    }

    return tokens;
  }, [content]);

  return (
    <span className={`inline ${className}`}>
      {parts.map((p, idx) => {
        if (p.type === 'text') {
          return <span key={idx} className="whitespace-pre-wrap">{p.value}</span>;
        }

        try {
          const html = katex.renderToString(p.value, {
            displayMode: p.type === 'block-math',
            throwOnError: false,
          });
          return (
            <span
              key={idx}
              className={p.type === 'block-math' ? 'my-2 block text-center' : 'inline-block px-0.5'}
              dangerouslySetInnerHTML={{ __html: html }}
            />
          );
        } catch {
          return <span key={idx} className="font-mono text-red-500">${p.value}$</span>;
        }
      })}
    </span>
  );
};
