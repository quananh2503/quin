import pypdf

reader = pypdf.PdfReader(r'e:\quin\quin\infrastructure2\gemini\HH12-KNTT- C2-GHEP FULL GIAI.pdf')
for i in range(1, 31):
    txt = reader.pages[i].extract_text()
    for kw in ['dây', 'treo', 'đèn', 'bàn', 'lực', 'hợp lực']:
        if kw in txt.lower():
            print(f"Page {i+1} has '{kw}':")
            for line in txt.split('\n'):
                if kw in line.lower():
                    print('   ', line.strip()[:100])
