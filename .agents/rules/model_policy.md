# QUY ĐỊNH BẮT BUỘC VỀ MODEL AI (QUIN PROJECT)

1. **Model Gemini chuẩn duy nhất hiện tại**:
   - Chỉ sử dụng **`gemini-3.8-flash`** (`ModelGeminiFlash`).
   - Google đã ngừng cung cấp các model cũ (`gemini-3.7-flash`, `gemini-2.5-flash`, `gemini-1.5-flash`, v.v.). **TUYỆT ĐỐI KHÔNG** cấu hình hoặc gọi tới các model này trong backend hoặc frontend.

2. **Xử lý tài liệu PDF (`application/pdf`)**:
   - Google GenAI API đối với dòng Gemma 4 (`gemma-4-31b-it`, `gemma-4-26b-a4b-it`) chỉ hỗ trợ các modalities: `Text`, `Image (image/png, image/jpeg, ...)`, `Video`. Model endpoint của Gemma **KHÔNG** chấp nhận MIME type `application/pdf` và sẽ lập tức trả về `Error 400 INVALID_ARGUMENT`.
   - Các Stage nhận tài liệu đầu vào là file PDF (như Stage 1 Planner) **BẮT BUỘC** phải sử dụng **`gemini-3.8-flash`** vì đây là model hỗ trợ natively document understanding từ PDF inline blob.

3. **Cấu hình Request (GenerateContentConfig)**:
   - Không cấu hình bừa bãi `ThinkingConfig` với `ThinkingLevelMinimal` cho các model không hỗ trợ để tránh lỗi 400 `INVALID_ARGUMENT`.
