import json

with open(r'e:\quin\quin\.artifacts\phase1_plan.json', 'r', encoding='utf-8') as f:
    p1 = json.load(f)

print('=== PHASE 1 PLAN ===')
print('Lesson title:', p1.get('lesson_title'))
print('Total topics:', len(p1.get('topics', [])))
for i, t in enumerate(p1.get('topics', [])):
    qids = t.get('assigned_question_ids', [])
    print(f"{i+1}. {t.get('topic_id')}: {t.get('title')}")
    print(f"   Target: {t.get('target_output')}")
    print(f"   Assigned Qs ({len(qids)}): {qids}")

with open(r'e:\quin\quin\.artifacts\phase2_all_results.json', 'r', encoding='utf-8') as f:
    p2 = json.load(f)

print('\n=== PHASE 2 RESULTS ===')
print('Total topics:', len(p2))
for i, t in enumerate(p2):
    tid = t.get('topic_id')
    title = t.get('title')
    ex = len(t.get('examples', []))
    dr = len(t.get('drills', []))
    sa = len(t.get('short_answers', []))
    tp = len(t.get('theory_points', []))
    print(f"{i+1}. {tid}: {title} | Theory: {tp} | SA: {sa} | Ex: {ex} | Drills: {dr}")
