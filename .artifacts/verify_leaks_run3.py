import json
import re

print("=== CHECKING FOR LEAK KEYWORDS IN RUN 3 ===")
leak_keywords = [
    'chỉnh sửa', 'chỉnh sửa:', '(sai)', 'sai.', 'không rút gọn được', 
    'nhầm', 'chú ý:', 'sửa lại', 'lưu ý:', 'thay đổi:', 'nháp'
]

with open(r'e:\quin\quin\.artifacts\phase2_all_results.json', 'r', encoding='utf-8') as f:
    topics = json.load(f)

found_leaks = 0
for i, t in enumerate(topics):
    tid = f"Dạng {i+1} ({t.get('topic_id')})"
    for j, ex in enumerate(t.get('examples', [])):
        sol = ex.get('solution', '')
        for kw in leak_keywords:
            if kw in sol.lower():
                print(f"[{tid}] Ex {j+1} '{ex.get('title')}' matched '{kw}':")
                print(f"   {sol[:150]}...")
                found_leaks += 1
    for j, dr in enumerate(t.get('drills', [])):
        sol = dr.get('solution', '')
        for kw in leak_keywords:
            if kw in sol.lower():
                print(f"[{tid}] Drill {j+1} '{dr.get('title')}' matched '{kw}':")
                print(f"   {sol[:150]}...")
                found_leaks += 1

print(f"\nTotal leak matches in phase2: {found_leaks}")

# Check failed_attempt_1.typ
with open(r'e:\quin\quin\infrastructure2\gemini\.artifacts\full_pipeline_output\failed_attempt_1.typ', 'r', encoding='utf-8') as f:
    typ_text = f.read()

typ_leaks = 0
for kw in ['chỉnh sửa', '(sai)', 'không rút gọn được']:
    matches = [m.start() for m in re.finditer(re.escape(kw), typ_text, re.IGNORECASE)]
    if matches:
        print(f"In failed_attempt_1.typ: found '{kw}' at {len(matches)} places!")
        typ_leaks += len(matches)

print(f"Total critical leak keywords in typst: {typ_leaks}")
