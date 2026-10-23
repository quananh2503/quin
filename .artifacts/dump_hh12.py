import pypdf

reader = pypdf.PdfReader(r'e:\quin\quin\infrastructure2\gemini\HH12-KNTT- C2-GHEP FULL GIAI.pdf')
for p in [3, 4, 15, 16, 24, 25, 26, 27, 28, 29, 30]:
    txt = reader.pages[p-1].extract_text()
    print(f"=== PAGE {p} ===")
    print(txt[:800])
