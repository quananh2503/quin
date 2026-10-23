import json

with open(r'e:\quin\quin\.artifacts\phase2_all_results.json', 'r', encoding='utf-8') as f:
    topics = json.load(f)

d1 = topics[0]
print("Title:", d1['title'])
print("Ex 2:", d1['examples'][1])
