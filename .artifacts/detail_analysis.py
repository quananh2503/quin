import json

with open(r'e:\quin\quin\.artifacts\phase2_all_results.json', 'r', encoding='utf-8') as f:
    topics = json.load(f)

print(f"Total topics: {len(topics)}\n")

for i, t in enumerate(topics):
    print("=" * 80)
    print(f"DẠNG {i+1} [{t.get('topic_id')}]: {t.get('title')}")
    print("-" * 40)
    print("THEORY POINTS:")
    for tp in t.get('theory_points', []):
        print(f"  • {tp}")
    print(f"TIP: {t.get('callout_tip')}")
    print(f"CLOZE FORMULA: {t.get('cloze_formula')}")
    print("-" * 40)
    print(f"SHORT ANSWERS ({len(t.get('short_answers', []))} câu):")
    for j, sa in enumerate(t.get('short_answers', [])):
        print(f"  [SA {j+1}] {sa.get('prompt')} --> ĐS: {sa.get('final_number')}")
    print("-" * 40)
    print(f"WORKED EXAMPLES ({len(t.get('examples', []))} ví dụ):")
    for j, ex in enumerate(t.get('examples', [])):
        print(f"  [{ex.get('title')}]")
        print(f"    Đề: {ex.get('problem')}")
        print(f"    Giải: {ex.get('solution')[:120]}...")
    print("-" * 40)
    print(f"DRILL EXERCISES ({len(t.get('drills', []))} bài):")
    for j, dr in enumerate(t.get('drills', [])):
        print(f"  [{dr.get('title')} - Level: {dr.get('level')}]")
        print(f"    Đề: {dr.get('prompt')}")
        print(f"    Giải: {dr.get('solution')[:120]}...")
    print("\n")
