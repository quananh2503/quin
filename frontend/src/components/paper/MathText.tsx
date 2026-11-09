import React, { useMemo } from 'react';
import katex from 'katex';
import { extractContentText } from '../../utils';

interface MathTextProps {
  content?: any;
  className?: string;
}

// Bounded Cache toàn cục cho KaTeX rendered HTML strings
// Giúp tránh parse lại hàng ngàn công thức toán lặp đi lặp lại
const KATEX_CACHE_LIMIT = 3000;
const katexHtmlCache = new Map<string, string>();

function getKatexHtml(formula: string, isBlock: boolean): string {
  const cacheKey = (isBlock ? 'B:' : 'I:') + formula;
  const cached = katexHtmlCache.get(cacheKey);
  if (cached !== undefined) {
    return cached;
  }

  try {
    const html = katex.renderToString(formula, {
      displayMode: isBlock,
      throwOnError: false,
    });
    if (katexHtmlCache.size >= KATEX_CACHE_LIMIT) {
      // Xóa bớt phần tử cũ nhất nếu cache đầy
      const firstKey = katexHtmlCache.keys().next().value;
      if (firstKey) {
        katexHtmlCache.delete(firstKey);
      }
    }
    katexHtmlCache.set(cacheKey, html);
    return html;
  } catch {
    const fallback = `<span class="font-mono text-red-500">${formula}</span>`;
    katexHtmlCache.set(cacheKey, fallback);
    return fallback;
  }
}

export const MathText: React.FC<MathTextProps> = React.memo(({ content, className = '' }) => {
  const safeContent = useMemo(() => {
    return extractContentText(content);
  }, [content]);

  const parts = useMemo(() => {
    if (!safeContent) return [];

    // Regex phân tách $$...$$ (khối công thức lớn) và $...$ (công thức nội dòng)
    const regex = /(\$\$[\s\S]+?\$\$|\$[^\$\n]+?\$)/g;
    const tokens: Array<{ type: 'text' | 'inline-math' | 'block-math'; value: string }> = [];

    let lastIndex = 0;
    let match: RegExpExecArray | null;

    while ((match = regex.exec(safeContent)) !== null) {
      if (match.index > lastIndex) {
        tokens.push({ type: 'text', value: safeContent.substring(lastIndex, match.index) });
      }

      const raw = match[0];
      if (raw.startsWith('$$') && raw.endsWith('$$')) {
        tokens.push({ type: 'block-math', value: raw.slice(2, -2).trim() });
      } else if (raw.startsWith('$') && raw.endsWith('$')) {
        tokens.push({ type: 'inline-math', value: raw.slice(1, -1).trim() });
      }

      lastIndex = regex.lastIndex;
    }

    if (lastIndex < safeContent.length) {
      tokens.push({ type: 'text', value: safeContent.substring(lastIndex) });
    }

    return tokens;
  }, [safeContent]);

  if (!parts.length) return null;

  return (
    <span className={`inline ${className}`}>
      {parts.map((p, idx) => {
        if (p.type === 'text') {
          // Chuẩn hóa chuỗi literal \n thành ký tự xuống dòng thật nếu chuỗi chưa được unescape
          const textValue = p.value.replace(/\\n/g, '\n');
          return <span key={idx} className="whitespace-pre-wrap">{textValue}</span>;
        }

        const html = getKatexHtml(p.value, p.type === 'block-math');
        return (
          <span
            key={idx}
            className={p.type === 'block-math' ? 'my-2 block text-center' : 'inline-block px-0.5'}
            dangerouslySetInnerHTML={{ __html: html }}
          />
        );
      })}
    </span>
  );
});

MathText.displayName = 'MathText';
