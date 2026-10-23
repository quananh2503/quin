import pypdf

def search_pdf(path, keywords):
    reader = pypdf.PdfReader(path)
    print(f"=== Searching in {path} ===")
    for i, page in enumerate(reader.pages):
        txt = page.extract_text()
        found = [kw for kw in keywords if kw.lower() in txt.lower()]
        if found:
            print(f"Page {i+1} matched: {found}")
            lines = [l.strip() for l in txt.split('\n') if any(k.lower() in l.lower() for k in found)]
            for l in lines[:4]:
                print('   ', l[:120])

search_pdf(r'e:\quin\quin\infrastructure2\gemini\HH12-KNTT- C2-GHEP FULL GIAI.pdf', ['đèn', 'treo', 'cân bằng', 'lực căng', 'bàn'])
search_pdf(r'e:\quin\quin\infrastructure2\gemini\ÔN VEC TƠ KG 10T10.pdf', ['đèn', 'treo', 'cân bằng', 'lực căng', 'bàn', 'lực'])
