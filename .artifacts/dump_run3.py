import json

with open(r'e:\quin\quin\.artifacts\phase2_all_results.json', 'r', encoding='utf-8') as f:
    topics = json.load(f)

with open(r'e:\quin\quin\.artifacts\run3_detail.txt', 'w', encoding='utf-8') as out:
    out.write(f"TOTAL TOPICS: {len(topics)}\n\n")
    for i, t in enumerate(topics):
        out.write("=" * 80 + "\n")
        out.write(f"DẠNG {i+1} [{t.get('topic_id')}]: {t.get('title')}\n")
        out.write("-" * 40 + "\n")
        out.write("THEORY POINTS:\n")
        for tp in t.get('theory_points', []):
            out.write(f"  • {tp}\n")
        out.write(f"TIP: {t.get('callout_tip')}\n")
        out.write(f"CLOZE FORMULA: {t.get('cloze_formula')}\n")
        out.write("-" * 40 + "\n")
        out.write(f"SHORT ANSWERS ({len(t.get('short_answers', []))} câu):\n")
        for j, sa in enumerate(t.get('short_answers', [])):
            out.write(f"  [SA {j+1}] {sa.get('prompt')}\n")
            out.write(f"        ĐS: {sa.get('final_number')} | Giải: {sa.get('solution')}\n")
        out.write("-" * 40 + "\n")
        out.write(f"WORKED EXAMPLES ({len(t.get('examples', []))} ví dụ):\n")
        for j, ex in enumerate(t.get('examples', [])):
            out.write(f"  [{ex.get('title')}]\n")
            out.write(f"    Đề: {ex.get('problem')}\n")
            out.write(f"    Giải: {ex.get('solution')}\n")
        out.write("-" * 40 + "\n")
        out.write(f"DRILL EXERCISES ({len(t.get('drills', []))} bài):\n")
        for j, dr in enumerate(t.get('drills', [])):
            out.write(f"  [{dr.get('title')} - Level: {dr.get('level')}]\n")
            out.write(f"    Đề: {dr.get('prompt')}\n")
            out.write(f"    Giải: {dr.get('solution')}\n")
        out.write("\n\n")
