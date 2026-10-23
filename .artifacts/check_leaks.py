import json
import re

with open(r'e:\quin\quin\.artifacts\phase2_all_results.json', 'r', encoding='utf-8') as f:
    topics = json.load(f)

print("=== CHECKING FOR ANOMALIES & LEAKS IN GENERATION ===")
leak_keywords = ['chỉnh sửa', 'sai', 'không rút gọn được', 'nhầm', 'chú ý:', 'sửa lại']

for i, t in enumerate(topics):
    tid = f"Dạng {i+1} ({t.get('topic_id')})"
    # check examples
    for j, ex in enumerate(t.get('examples', [])):
        sol = ex.get('solution', '')
        for kw in leak_keywords:
            if kw in sol.lower():
                print(f"[{tid}] Example {j+1} '{ex.get('title')}' matched '{kw}':")
                print(f"   Excerpt: {sol}")
    # check drills
    for j, dr in enumerate(t.get('drills', [])):
        sol = dr.get('solution', '')
        for kw in leak_keywords:
            if kw in sol.lower():
                print(f"[{tid}] Drill {j+1} '{dr.get('title')}' matched '{kw}':")
                print(f"   Excerpt: {sol}")
