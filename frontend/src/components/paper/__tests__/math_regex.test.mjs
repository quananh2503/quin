import assert from 'node:assert/strict';
import test from 'node:test';

function parseMathTokens(content) {
  if (!content) return [];
  const regex = /(\$\$[\s\S]+?\$\$|\$[^\$\n]+?\$)/g;
  const tokens = [];

  let lastIndex = 0;
  let match;

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
}

test('parseMathTokens splits text and inline/block formulas correctly', () => {
  const input = 'Hàm số $y = a x^2$ với $$a \\neq 0$$ có đồ thị là parabol.';
  const tokens = parseMathTokens(input);

  assert.equal(tokens.length, 5);
  assert.equal(tokens[0].type, 'text');
  assert.equal(tokens[0].value, 'Hàm số ');

  assert.equal(tokens[1].type, 'inline-math');
  assert.equal(tokens[1].value, 'y = a x^2');

  assert.equal(tokens[2].type, 'text');
  assert.equal(tokens[2].value, ' với ');

  assert.equal(tokens[3].type, 'block-math');
  assert.equal(tokens[3].value, 'a \\neq 0');

  assert.equal(tokens[4].type, 'text');
  assert.equal(tokens[4].value, ' có đồ thị là parabol.');
});

test('parseMathTokens handles pure text without math', () => {
  const input = 'Đây là văn bản tiếng Việt thông thường.';
  const tokens = parseMathTokens(input);

  assert.equal(tokens.length, 1);
  assert.equal(tokens[0].type, 'text');
  assert.equal(tokens[0].value, input);
});

test('parseMathTokens handles empty string', () => {
  const tokens = parseMathTokens('');
  assert.deepEqual(tokens, []);
});
