import json

with open(r'e:\quin\quin\.artifacts\phase2_all_results.json', 'r', encoding='utf-8') as f:
    topics = json.load(f)

for i, t in enumerate(topics):
    print("=" * 60)
    print(f"DẠNG {i+1}: {t.get('topic_id')} - {t.get('title')}")
    print("Theory Points:")
    for tp in t.get('theory_points', []):
        print(f"  * {tp[:120]}")
    print("Tip:", t.get('callout_tip', '')[:120])
    print("Cloze Formula:", t.get('cloze_formula', ''))
    print(f"Short answers ({len(t.get('short_answers', []))}):")
    for sa in t.get('short_answers', []):
        print(f"  - Q: {sa.get('question', '')[:90]} | Ans: {sa.get('answer', '')}")
    print(f"Examples ({len(t.get('examples', []))}):")
    for ex in t.get('examples', []):
        print(f"  - [{ex.get('label', '')}] {ex.get('question', '')[:90]}")
    print(f"Drills ({len(t.get('drills', []))}):")
    for dr in t.get('drills', []):
        print(f"  - [{dr.get('level', '')}] {dr.get('question', '')[:90]}")
