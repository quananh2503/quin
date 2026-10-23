import json

with open(r'e:\quin\quin\.artifacts\phase2_all_results.json', 'r', encoding='utf-8') as f:
    topics = json.load(f)

print(f"{'Dạng':<8}{'Tên Dạng':<45}{'Theory':<8}{'SA':<5}{'Ex':<5}{'Drills':<8}{'Drill breakdown'}")
print("-" * 110)

total_theory = 0
total_sa = 0
total_ex = 0
total_dr = 0

for i, t in enumerate(topics):
    tid = f"Dạng {i+1}"
    title = t.get('title')[:42]
    theory_cnt = len(t.get('theory_points', []))
    sa_cnt = len(t.get('short_answers', []))
    ex_cnt = len(t.get('examples', []))
    drills = t.get('drills', [])
    dr_cnt = len(drills)
    
    levels = {}
    for d in drills:
        lvl = d.get('level', 'Unknown')
        levels[lvl] = levels.get(lvl, 0) + 1
    lvl_str = ", ".join([f"{k}:{v}" for k, v in levels.items()])
    
    total_theory += theory_cnt
    total_sa += sa_cnt
    total_ex += ex_cnt
    total_dr += dr_cnt
    
    print(f"{tid:<8}{title:<45}{theory_cnt:<8}{sa_cnt:<5}{ex_cnt:<5}{dr_cnt:<8}{lvl_str}")

print("-" * 110)
print(f"{'TỔNG':<8}{'11 Dạng':<45}{total_theory:<8}{total_sa:<5}{total_ex:<5}{total_dr:<8}")
