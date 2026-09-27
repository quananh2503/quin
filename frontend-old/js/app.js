// State toàn cục
let currentStudentId = null;
let currentDraftId = null;
let aiPollingTimer = null;
let cachedDrafts = [];
let editingDraft = null;
let currentGradingAssignment = null;
let selectedMistakeId = null;
let gradingSearchTimer = null;
let mistakeById = new Map();
let currentDocument = null;
let selectedDocumentPages = new Set();
let dashboardRequestVersion = 0;
let previewQueue = [];
let previewWorkers = 0;
let documentPreviewObserver = null;
const MAX_PREVIEW_WORKERS = 2;

// Khởi chạy khi nạp trang
document.addEventListener("DOMContentLoaded", () => {
  initDateFilters();
  loadDashboard();
  loadAIModels();
  loadLessonDrafts();
  loadDocuments();
  checkGoogleStatus();
  checkOneNoteStatus();
});

// Điều hướng Tab chính
function navigate(viewName) {
  document.querySelectorAll(".view-panel").forEach(el => el.classList.remove("active"));
  document.querySelectorAll(".nav-item").forEach(el => el.classList.remove("active"));
  
  const target = document.getElementById("view-" + viewName);
  if (target) target.classList.add("active");

  const navBtn = document.querySelector(`[data-view="${viewName}"]`);
  if (navBtn) navBtn.classList.add("active");

  if (viewName === "dashboard") loadDashboard();
  if (viewName === "lessons") loadLessonDrafts();
  if (viewName === "documents") loadDocuments();
  if (viewName === "grading") loadGradingPages();
}

// ==================== MODULE 2: TÀI LIỆU PDF ====================

async function loadDocuments() {
  const list = document.getElementById("documents-list");
  if (!list) return;
  try {
    const documents = await window.go.main.App.V2ListDocuments();
    document.getElementById("documents-count").innerText = `${(documents || []).length} tài liệu`;
    if (!documents?.length) {
      list.innerHTML = `<p class="text-muted" style="padding:18px 0;">Chưa có tài liệu nào.</p>`;
      return;
    }
    list.innerHTML = documents.map(doc => `<div class="document-row">
      <div><strong>${escapeHTML(doc.file_name)}</strong><br><small class="text-muted">${doc.page_count} trang · ${escapeHTML(doc.status)}</small></div>
      <button class="btn btn-secondary compact" ${doc.status === "READY" ? "" : "disabled"} onclick="selectDocument('${doc.id}')">Chọn trang</button>
    </div>`).join("");
  } catch (err) {
    list.innerHTML = `<p class="error-text">${escapeHTML(normalizeError(err))}</p>`;
  }
}

async function handleUploadDocument() {
  const button = document.getElementById("btn-upload-document");
  button.disabled = true;
  button.innerText = "Đang xử lý tài liệu...";
  try {
    const documentView = await window.go.main.App.V2UploadDocument();
    showToast(`Đã xử lý ${documentView.file_name}: ${documentView.page_count} trang`);
    await loadDocuments();
    await selectDocument(documentView.id);
  } catch (err) {
    if (!String(normalizeError(err)).includes("chưa chọn")) showToast("Lỗi upload tài liệu: " + normalizeError(err), true);
  } finally {
    button.disabled = false;
    button.innerText = "Chọn tài liệu";
  }
}

async function selectDocument(documentID) {
  try {
    currentDocument = await window.go.main.App.V2GetDocument(String(documentID));
    selectedDocumentPages = new Set();
    previewQueue = [];
    if (documentPreviewObserver) documentPreviewObserver.disconnect();
    documentPreviewObserver = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        const card = entry.target;
        documentPreviewObserver.unobserve(card);
        enqueueDocumentPreview(String(documentID), Number(card.dataset.page), card.querySelector("img"));
      });
    }, { rootMargin: "500px 0px" });
    document.getElementById("document-status").innerText = `${currentDocument.file_name} · ${currentDocument.page_count} trang`;
    copyModelOptions("pdf-model-select");
    const picker = document.getElementById("document-page-picker");
    picker.innerHTML = "";
    for (let page = 1; page <= currentDocument.page_count; page++) {
      const card = document.createElement("div");
      card.className = "document-page";
	  card.dataset.page = String(page);
      card.innerHTML = `<img alt="Trang ${page}" loading="lazy"><label><input type="checkbox"> Trang ${page}</label>`;
      card.querySelector("input").addEventListener("change", event => {
        if (event.target.checked) selectedDocumentPages.add(page); else selectedDocumentPages.delete(page);
        card.classList.toggle("selected", event.target.checked);
        updatePDFButton();
      });
      picker.appendChild(card);
	  documentPreviewObserver.observe(card);
    }
    updatePDFButton();
  } catch (err) {
    showToast("Không thể mở tài liệu: " + normalizeError(err), true);
  }
}

function enqueueDocumentPreview(documentID, page, image) {
  previewQueue.push(async () => {
    if (!currentDocument || String(currentDocument.id) !== String(documentID)) return;
    const url = await window.go.main.App.V2GetDocumentPreview(documentID, page);
    if (currentDocument && String(currentDocument.id) === String(documentID)) image.src = url;
  });
  runPreviewQueue();
}

function runPreviewQueue() {
  while (previewWorkers < MAX_PREVIEW_WORKERS && previewQueue.length) {
    const task = previewQueue.shift();
    previewWorkers += 1;
    task().catch(() => {}).finally(() => {
      previewWorkers -= 1;
      runPreviewQueue();
    });
  }
}

function updatePDFButton() {
  document.getElementById("btn-create-pdf-lesson").disabled = !currentDocument || selectedDocumentPages.size === 0;
}

async function handleCreatePDFLesson() {
  if (!currentDocument || selectedDocumentPages.size === 0) return;
  const button = document.getElementById("btn-create-pdf-lesson");
  button.disabled = true;
  button.innerText = "Đang tạo bài...";
  try {
    await window.go.main.App.V2CreateLessonFromPDF({
      material: "pdf",
      document_id: String(currentDocument.id),
      pages: [...selectedDocumentPages].sort((a, b) => a - b),
      title: document.getElementById("pdf-title").value.trim(),
      model: document.getElementById("pdf-model-select").value,
      prompt: document.getElementById("pdf-prompt").value.trim()
    });
    showToast("Đã gửi các trang PDF cho AI xử lý");
    navigate("lessons");
  } catch (err) {
    showToast("Lỗi tạo bài từ PDF: " + normalizeError(err), true);
  } finally {
    updatePDFButton();
    button.innerText = "Tạo bài từ trang đã chọn";
  }
}

// ==================== MODULE 1: SỔ BUỔI HỌC ====================

function initDateFilters() {
  const now = new Date();
  const to = new Date(now);
  const from = new Date(now.getTime() - 60 * 24 * 60 * 60 * 1000); // 60 days ago

  document.getElementById("filter-from").value = formatDateForVietnam(from);
  document.getElementById("filter-to").value = formatDateForVietnam(to);
  
  // Set month picker to current month for display
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, "0");
  document.getElementById("filter-month").value = `${year}-${month}`;
}

function onMonthChange() {
  const monthVal = document.getElementById("filter-month").value;
  if (!monthVal) return;
  const [year, month] = monthVal.split("-");
  const lastDay = new Date(year, month, 0).getDate();
  document.getElementById("filter-from").value = `${year}-${month}-01`;
  document.getElementById("filter-to").value = `${year}-${month}-${lastDay}`;
  loadDashboard();
}

async function loadDashboard() {
  const requestVersion = ++dashboardRequestVersion;
  try {
    setDashboardStatus("Đang tải thống kê...", "loading");

    const searchVal = document.getElementById("filter-search").value.trim();
    const fromDateStr = document.getElementById("filter-from").value;
    const toDateStr = document.getElementById("filter-to").value;
    
    const filter = {
      // Người dùng chọn ngày Việt Nam; backend nhận khoảng UTC tương ứng.
      from_date: vietnamDayBoundaryISO(fromDateStr, false),
      to_date: vietnamDayBoundaryISO(toDateStr, true),
      min_duration_minutes: parseInt(document.getElementById("filter-min-duration").value) || 0,
      SearchName: searchVal ? searchVal : null
    };

    const data = await window.go.main.App.V2GetDashboard({ ...filter, search_name: searchVal });
    // Khi bấm đồng bộ/lọc liên tiếp, chỉ request mới nhất mới được quyền vẽ UI.
    if (requestVersion !== dashboardRequestVersion) return;

    document.getElementById("stat-students").innerText = data.total_students;
    document.getElementById("stat-sessions").innerText = data.total_sessions;
    document.getElementById("stat-duration").innerText = formatDuration(data.total_duration_minutes);
    document.getElementById("student-count-badge").innerText = `${data.total_students} học sinh`;

    const tbody = document.getElementById("student-table-body");
    tbody.innerHTML = "";

    if (!data.students || data.students.length === 0) {
      tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;color:#64748b;padding:32px;">Không tìm thấy học sinh nào</td></tr>`;
      setDashboardStatus("Đã tải xong, nhưng không có dữ liệu phù hợp bộ lọc hiện tại.", "info");
      return;
    }

    data.students.forEach(s => {
      const tr = document.createElement("tr");
      tr.style.cursor = "pointer";
      tr.onclick = () => openStudentDetail(s.id);
      tr.innerHTML = `
        <td><strong>${s.name}</strong></td>
        <td>${renderMeetIdentity(s.space_name, s.meeting_code, s.class)}</td>
        <td>Ngày ${s.cycle_start_day} hàng tháng</td>
        <td><strong style="color:#15803d">${s.total_sessions}</strong> buổi</td>
        <td>${formatDuration(s.total_duration_minutes)}</td>
        <td style="color:#15803d;font-weight:bold;">→</td>
      `;
      tbody.appendChild(tr);
    });

    setDashboardStatus(`Đã tải thành công: ${data.total_students} học sinh, ${data.total_sessions} buổi hợp lệ.`, "success");
  } catch (err) {
    if (requestVersion !== dashboardRequestVersion) return;
    const detail = normalizeError(err);
    setDashboardStatus("Lỗi tải thống kê: " + detail, "error");
    showToast("Lỗi tải danh sách: " + detail, true);
  }
}

async function handleSyncMeet() {
  const btn = document.getElementById("btn-sync");
  const icon = btn.querySelector(".spin-icon");
  const btnText = btn.querySelector("span");

  // Bật loading
  icon.classList.remove("hidden");
  btnText.innerText = "Đang đồng bộ...";
  btn.disabled = true;

  try {
    await window.go.main.App.V2SyncMeetings();
    showToast("Đồng bộ Google Meet thành công!");
    await loadDashboard();
  } catch (err) {
    showToast("Đồng bộ thất bại: " + err, true);
  } finally {
    // Tắt loading hoàn toàn
    icon.classList.add("hidden");
    btnText.innerText = "Đồng bộ Google Meet";
    btn.disabled = false;
  }
}

async function openStudentDetail(studentId) {
  currentStudentId = studentId;
  const fromDateStr = document.getElementById("filter-from").value;
  const toDateStr = document.getElementById("filter-to").value;
  
  // Initialize detail filter fields with dashboard filter values
  document.getElementById("detail-filter-from").value = fromDateStr;
  document.getElementById("detail-filter-to").value = toDateStr;
  document.getElementById("detail-filter-min-duration").value = document.getElementById("filter-min-duration").value;
  
  const filter = {
    from_date: vietnamDayBoundaryISO(fromDateStr, false),
    to_date: vietnamDayBoundaryISO(toDateStr, true),
    min_duration_minutes: parseInt(document.getElementById("filter-min-duration").value) || 0
  };

  navigate("student-detail");
  document.getElementById("detail-name").innerText = "Đang tải học sinh...";
  try {
    const data = await window.go.main.App.V2GetStudentDetail({ student_id: String(studentId), ...filter });
    document.getElementById("detail-name").innerText = data.student.name;
    const identity = data.student.space_name || data.student.meeting_code || data.student.class;
    const code = data.student.meeting_code ? ` · Meet: ${data.student.meeting_code}` : "";
    document.getElementById("detail-space").innerText = `${identity}${code}`;
    document.getElementById("detail-stat-sessions").innerText = data.total_sessions + " buổi";
    document.getElementById("detail-stat-duration").innerText = formatDuration(data.total_duration_minutes);

    document.getElementById("edit-student-name").value = data.student.name;
    document.getElementById("edit-student-space").value = data.student.class;
    document.getElementById("edit-student-cycle").value = data.student.cycle_start_day;

    const tbody = document.getElementById("meetings-table-body");
    tbody.innerHTML = "";

    if (!data.meetings || data.meetings.length === 0) {
      tbody.innerHTML = `<tr><td colspan="3" style="text-align:center;color:#64748b;padding:24px;">Chưa có buổi học nào trong khoảng thời gian này</td></tr>`;
    } else {
      data.meetings.forEach(m => {
        const tr = document.createElement("tr");
        const participantsHTML = m.participants.map(p => `<div>${p.name} <small style="color:#64748b">(${formatDuration(p.duration)})</small></div>`).join("");
        tr.innerHTML = `
          <td><strong>${formatDateTime(m.started_at)}</strong><br><small style="color:#64748b">Đến ${formatDateTime(m.ended_at)}</small></td>
          <td><strong>${formatDuration(calculateMinutes(m.started_at, m.ended_at))}</strong></td>
          <td>${participantsHTML || "—"}</td>
        `;
        tbody.appendChild(tr);
      });
    }
  } catch (err) {
    document.getElementById("detail-name").innerText = "Không thể tải học sinh";
    showToast("Lỗi tải chi tiết: " + normalizeError(err), true);
  }
}

function renderMeetIdentity(spaceName, meetingCode, spaceID) {
  const title = String(spaceName || "").trim();
  const code = String(meetingCode || "").trim();
  if (title) return `<strong>${escapeHTML(title)}</strong>${code ? `<br><code>${escapeHTML(code)}</code>` : ""}`;
  if (code) return `<code>${escapeHTML(code)}</code>`;
  return `<code title="Mã kỹ thuật Google Meet">${escapeHTML(spaceID)}</code>`;
}

async function reloadStudentDetail() {
  if (!currentStudentId) return;
  
  const fromDateStr = document.getElementById("detail-filter-from").value;
  const toDateStr = document.getElementById("detail-filter-to").value;
  
  const filter = {
    from_date: vietnamDayBoundaryISO(fromDateStr, false),
    to_date: vietnamDayBoundaryISO(toDateStr, true),
    min_duration_minutes: parseInt(document.getElementById("detail-filter-min-duration").value) || 0
  };

  try {
    const data = await window.go.main.App.V2GetStudentDetail({ student_id: String(currentStudentId), ...filter });
    document.getElementById("detail-stat-sessions").innerText = data.total_sessions + " buổi";
    document.getElementById("detail-stat-duration").innerText = formatDuration(data.total_duration_minutes);

    const tbody = document.getElementById("meetings-table-body");
    tbody.innerHTML = "";

    if (!data.meetings || data.meetings.length === 0) {
      tbody.innerHTML = `<tr><td colspan="3" style="text-align:center;color:#64748b;padding:24px;">Chưa có buổi học nào trong khoảng thời gian này</td></tr>`;
    } else {
      data.meetings.forEach(m => {
        const tr = document.createElement("tr");
        const participantsHTML = m.participants.map(p => `<div>${p.name} <small style="color:#64748b">(${formatDuration(p.duration)})</small></div>`).join("");
        tr.innerHTML = `
          <td><strong>${formatDateTime(m.started_at)}</strong><br><small style="color:#64748b">Đến ${formatDateTime(m.ended_at)}</small></td>
          <td><strong>${formatDuration(calculateMinutes(m.started_at, m.ended_at))}</strong></td>
          <td>${participantsHTML || "—"}</td>
        `;
        tbody.appendChild(tr);
      });
    }
  } catch (err) {
    showToast("Lỗi cập nhật chi tiết: " + err, true);
  }
}

async function handleUpdateStudent() {
  const student = {
    student_id: String(currentStudentId),
    name: document.getElementById("edit-student-name").value.trim(),
    start_cycle_day: parseInt(document.getElementById("edit-student-cycle").value)
  };

  try {
    await window.go.main.App.V2UpdateStudent(student);
    showToast("Đã lưu thông tin học sinh!");
    document.getElementById("detail-name").innerText = student.name;
  } catch (err) {
    showToast("Lỗi lưu: " + err, true);
  }
}

// ==================== MODULE 2: SOẠN BÀI GIẢNG AI ====================

async function loadAIModels() {
  const select = document.getElementById("lesson-model-select");
  const defaultModel = "gemini-3.7-flash";

  try {
    const models = await window.go.main.App.V2ListAIModels();
    const supportedModels = (models || []).filter(isSupportedLessonModel);
    const defaultModelInfo = supportedModels.find(m => m.id === defaultModel) || {
      id: defaultModel,
      display_name: "gemini-3.7 Flash (Mặc định)",
    };
    const displayModels = [
      defaultModelInfo,
      ...supportedModels.filter(m => m.id !== defaultModel),
    ];

    select.innerHTML = displayModels
      .map(m => `<option value="${m.id}">${m.display_name}</option>`)
      .join("");
    select.value = defaultModel;
  } catch (e) {
    // Giữ lựa chọn mặc định trong HTML khi không thể tải danh sách từ API.
    select.value = defaultModel;
    console.log("Không thể tải danh sách models, dùng Gemini 3.5 Flash mặc định");
  }
}

function isSupportedLessonModel(model) {
  const id = String(model?.id || "").toLowerCase();
  const modelText = [model?.display_name, model?.displayName, model?.description]
    .filter(Boolean)
    .join(" ")
    .toLowerCase();

  // Nano Banana là model tạo ảnh, không phù hợp với luồng tạo giáo án từ video.
  // Loại cả biến thể tên thương mại lẫn ID có hậu tố image/imagen.
  if (/nano\s*banana|\bimage\b|\bimagen\b/.test(`${id} ${modelText}`)) {
    return false;
  }

  const match = id
    .match(/^gemini-(\d+)(?:\.(\d+))?-(flash|pro)(?:[-_]|$)/);

  if (!match) return false;

  const majorVersion = Number(match[1]);
  const minorVersion = Number(match[2] || 0);
  return majorVersion > 2 || (majorVersion === 2 && minorVersion >= 5);
}

async function handleCreateLesson() {
  const button = document.getElementById("btn-create-lesson");
  let url = document.getElementById("lesson-url").value.trim();
  const prompt = document.getElementById("lesson-prompt").value.trim();
  const model = document.getElementById("lesson-model-select").value;

  if (!url) {
    showToast("Vui lòng dán đường dẫn YouTube", true);
    return;
  }

  // Tự động làm sạch URL YouTube (xóa bỏ &list=..., &t=...)
  url = cleanYouTubeURL(url);

  try {
    button.disabled = true;
    button.querySelector("span").innerText = "Đang gửi yêu cầu...";
    await window.go.main.App.V2CreateLesson({ title: "", model, prompt, url });
  } catch (err) {
    showToast("Lỗi tạo bài giảng: " + normalizeError(err), true);
    return;
  } finally {
    button.disabled = false;
    button.querySelector("span").innerText = "Bắt đầu tạo bài giảng";
  }

  showToast("Đã gửi yêu cầu! AI đang phân tích video ngầm...");
  document.getElementById("lesson-url").value = "";
  document.getElementById("lesson-prompt").value = "";

  // Bản nháp đã được backend lưu trước khi CreateLessonJob trả về.
  // Chờ tải xong để dòng prompt xuất hiện ngay, thay vì chờ chu kỳ polling.
  await loadLessonDrafts();
  startPolling();
}

async function loadLessonDrafts() {
  try {
    const drafts = await window.go.main.App.V2ListLessonDrafts();
    cachedDrafts = drafts || [];
    
    document.getElementById("drafts-count-badge").innerText = `${cachedDrafts.length} bài`;
    const tbody = document.getElementById("drafts-table-body");
    tbody.innerHTML = "";

    if (!cachedDrafts || cachedDrafts.length === 0) {
      tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;color:#64748b;padding:32px;">Chưa có bài giảng nào được tạo</td></tr>`;
      return;
    }

    let hasProcessing = false;
    cachedDrafts.forEach(d => {
      if (d.status === "processing") hasProcessing = true;

      const tr = document.createElement("tr");

      let statusHTML = `<span class="badge badge-${d.status}">${d.status}</span>`;
      if (d.status === "processing") {
        statusHTML = `<span class="badge badge-processing">Đang phân tích...</span>`;
      } else if (d.status === "completed") {
        statusHTML = `<span class="badge badge-completed">Đã hoàn thành</span>`;
      } else if (d.status === "failed") {
        statusHTML = `
          <span class="badge badge-failed">Thất bại</span>
          <br><button class="btn-view-error" onclick="openErrorModal('${d.id}')">🔍 Xem lỗi</button>
        `;
      }

      const promptDisplay = d.custom_prompt 
        ? `<span class="prompt-preview" title="${d.custom_prompt}">${d.custom_prompt}</span>`
        : `<span style="color:#94a3b8;font-size:12px;">Mặc định</span>`;

      const sourceHTML = d.source_type === "YOUTUBE" && d.source_url
        ? `<a class="source-link" href="${escapeHTML(d.source_url)}" onclick="event.preventDefault(); openExternalURL(this.href)">${escapeHTML(d.source_url)}</a>`
        : d.source_type === "MISTAKE"
          ? `<small style="color:#64748b;">Bài khắc phục từ kho lỗi</small>`
          : `<small style="color:#64748b;">${escapeHTML(d.source_type || "Nguồn khác")}</small>`;
      tr.innerHTML = `
        <td>
          <strong>${d.title || "Chưa có tiêu đề"}</strong>
          <br><small style="word-break:break-all;">${sourceHTML}</small>
        </td>
        <td>${promptDisplay}</td>
        <td><code>${d.model || "gemini"}</code></td>
        <td style="white-space:nowrap;">${formatDateTime(d.created_at)}</td>
        <td>${statusHTML}</td>
        <td style="text-align:right; white-space:nowrap;">
          ${d.status === "completed" ? `<button class="btn btn-primary" style="padding:6px 12px;font-size:12px;" onclick="openLessonEditor('${d.id}')">Sửa & Xuất PDF</button>` : ""}
          ${d.status === "failed" && d.source_type === "YOUTUBE" ? `<button class="btn btn-secondary" style="padding:6px 12px;font-size:12px;" onclick="retryLesson('${d.id}')">Tạo lại</button>` : ""}
        </td>
      `;
      tbody.appendChild(tr);
    });

    if (hasProcessing) startPolling(); else stopPolling();
    return true;
  } catch (err) {
    const detail = normalizeError(err);
    console.error("Lỗi load drafts:", detail);
    // Không để lỗi bridge/database bị ngụy trang thành “0 bài”.
    const badge = document.getElementById("drafts-count-badge");
    const tbody = document.getElementById("drafts-table-body");
    if (badge) badge.innerText = "Không tải được";
    if (tbody) {
      tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;color:#b91c1c;padding:32px;">
        Không thể tải lịch sử bài giảng.<br><small>${detail}</small>
      </td></tr>`;
    }
    return false;
  }
}

function startPolling() {
  if (!aiPollingTimer) {
    aiPollingTimer = setInterval(loadLessonDrafts, 3000);
  }
}
function stopPolling() {
  if (aiPollingTimer) {
    clearInterval(aiPollingTimer);
    aiPollingTimer = null;
  }
}

function retryLesson(draftId) {
  const draft = cachedDrafts.find(d => d.id === draftId);
  if (!draft) return;

  document.getElementById("lesson-url").value = draft.source_url;
  document.getElementById("lesson-prompt").value = draft.custom_prompt || "";
  if (draft.model) {
    document.getElementById("lesson-model-select").value = draft.model;
  }
  window.scrollTo({ top: 0, behavior: 'smooth' });
  showToast("Đã điền lại link & prompt cũ vào form!");
}

async function openLessonEditor(draftId) {
  currentDraftId = draftId;
  try {
    const draft = await window.go.main.App.V2GetLessonDraft(String(draftId));
	editingDraft = draft;
    document.getElementById("editor-title").value = draft.title || "";
	renderStructuredLessonEditor(draft.lesson_data || { title: draft.title || "", overview: "", sections: [], exercises: [] });
    navigate("lesson-editor");
  } catch (err) {
    showToast("Lỗi mở bài giảng: " + err, true);
  }
}

async function handleSaveDraft() {
  const title = document.getElementById("editor-title").value.trim();
	if (!title || !editingDraft) {
		showToast("Vui lòng nhập tiêu đề bài giảng", true);
		return false;
	}
	editingDraft.title = title;
	editingDraft.lesson_data = collectStructuredLesson(title);
  try {
  await window.go.main.App.V2SaveLessonDraft({ draft_id: String(currentDraftId), lesson: editingDraft.lesson_data });
    showToast("Đã lưu thay đổi bản nháp thành công!");
	return true;
  } catch (err) {
	showToast("Lỗi lưu: " + normalizeError(err), true);
	return false;
  }
}

async function handleExportPDF() {
  try {
	if (!(await handleSaveDraft())) return;
	await window.go.main.App.ExportAndSavePDF(currentDraftId);
    showToast("Đã xuất 2 file PDF thành công!");
  } catch (err) {
    showToast("Lỗi xuất PDF: " + err, true);
  }
}

function renderStructuredLessonEditor(lesson) {
	document.getElementById("editor-overview").value = lesson.overview || "";
	const sections = document.getElementById("lesson-sections-editor");
	sections.innerHTML = "";
	(lesson.sections || []).forEach(section => sections.appendChild(createSectionCard(section)));
	const exercises = document.getElementById("lesson-exercises-editor");
	exercises.innerHTML = "";
	(lesson.exercises || []).forEach(exercise => exercises.appendChild(createExerciseCard(exercise)));
}

function createSectionCard(section = {}) {
	const card = document.createElement("div");
	card.className = "structure-card lesson-section-card";
	card.innerHTML = `<div class="structure-card-head"><strong>Mục nội dung</strong><button class="remove-link" onclick="this.closest('.structure-card').remove()">Xóa</button></div>
		<div class="field"><label>Tiêu đề mục</label><input data-field="section_title" value="${escapeHTML(section.section_title || "")}"></div>
		<div class="field"><label>Lời dẫn</label><textarea data-field="transition_intro">${escapeHTML(section.transition_intro || "")}</textarea></div>
		<div class="field"><label>Nội dung chi tiết</label><textarea class="tall" data-field="detailed_content">${escapeHTML(section.detailed_content || "")}</textarea></div>
		<div class="field"><label>Điều cần nhớ</label><textarea data-field="key_takeaway">${escapeHTML(section.key_takeaway || "")}</textarea></div>
		<div class="field"><label>Ghi chú điền khuyết (mỗi dòng một ý)</label><textarea data-field="student_cloze_notes">${escapeHTML((section.student_cloze_notes || []).join("\n"))}</textarea></div>
		<div class="examples-editor"></div><button class="btn btn-secondary compact" onclick="addTeacherExample(this)">+ Thêm ví dụ</button>`;
	(section.teacher_examples || []).forEach(example => card.querySelector(".examples-editor").appendChild(createExampleCard(example)));
	return card;
}

function createExampleCard(example = {}) {
	const item = document.createElement("div");
	item.className = "example-card";
	item.innerHTML = `<div class="structure-card-head"><strong>Ví dụ</strong><button class="remove-link" onclick="this.closest('.example-card').remove()">Xóa</button></div>
		<div class="field"><label>Đề bài</label><textarea data-field="problem">${escapeHTML(example.problem || "")}</textarea></div>
		<div class="field"><label>Lời giải giáo viên</label><textarea data-field="teacher_solution">${escapeHTML(example.teacher_solution || "")}</textarea></div>
		<div class="field"><label>Giải thích dễ hiểu</label><textarea data-field="student_friendly_explanation">${escapeHTML(example.student_friendly_explanation || "")}</textarea></div>
		<div class="field"><label>Lỗi thường gặp</label><input data-field="common_mistake" value="${escapeHTML(example.common_mistake || "")}"></div>`;
	return item;
}

function createExerciseCard(exercise = {}) {
	const card = document.createElement("div");
	card.className = "structure-card lesson-exercise-card";
	const type = exercise.type === "essay" || exercise.type === "Tự luận" ? "essay" : "multiple-choice";
	card.innerHTML = `<div class="structure-card-head"><strong>Câu hỏi</strong><button class="remove-link" onclick="this.closest('.structure-card').remove()">Xóa</button></div>
		<div class="compact-grid"><div class="field"><label>Loại</label><select data-field="type" onchange="toggleExerciseEditorFields(this)"><option value="multiple-choice" ${type === "multiple-choice" ? "selected" : ""}>Trắc nghiệm</option><option value="essay" ${type === "essay" ? "selected" : ""}>Tự luận</option></select></div><div class="field"><label>Chủ đề</label><input data-field="topic" value="${escapeHTML(exercise.topic || "")}" placeholder="Ví dụ: Phương trình bậc hai"></div><div class="field"><label>Mức độ</label><input data-field="difficulty" value="${escapeHTML(exercise.difficulty || "")}" placeholder="Ví dụ: Thông hiểu"></div></div>
		<div class="field"><label>Câu hỏi</label><textarea data-field="question">${escapeHTML(exercise.question || "")}</textarea></div>
		<div class="mcq-editor"><div class="field"><label>Lựa chọn (mỗi dòng một đáp án)</label><textarea data-field="options">${escapeHTML((exercise.options || []).map(option => typeof option === "string" ? option : `${option.label || ""}. ${option.content || ""}`).join("\n"))}</textarea></div>
		<div class="field"><label>Đáp án đúng</label><input data-field="answer" value="${escapeHTML(exercise.answer || "")}" placeholder="A"></div>
		<div class="field"><label>Giải thích</label><textarea data-field="explanation">${escapeHTML(exercise.explanation || "")}</textarea></div></div>
		<div class="essay-editor"><div class="essay-parts-editor"></div><button type="button" class="btn btn-secondary compact" onclick="addEssayPart(this)">+ Thêm ý tự luận</button></div>`;
	(exercise.parts || []).forEach(part => card.querySelector(".essay-parts-editor").appendChild(createEssayPartCard(part)));
	if (type === "essay" && !(exercise.parts || []).length) {
		card.querySelector(".essay-parts-editor").appendChild(createEssayPartCard({ label: "a", question: exercise.question || "", solution: exercise.answer || "", rubric: exercise.explanation || "" }));
	}
	toggleExerciseEditorFields(card.querySelector('[data-field="type"]'));
	return card;
}

function createEssayPartCard(part = {}) {
	const card = document.createElement("div");
	card.className = "example-card essay-part-card";
	card.innerHTML = `<div class="structure-card-head"><strong>Ý tự luận</strong><button type="button" class="remove-link" onclick="this.closest('.essay-part-card').remove()">Xóa</button></div>
		<div class="compact-grid"><div class="field"><label>Nhãn</label><input data-field="label" value="${escapeHTML(part.label || "")}" placeholder="a"></div></div>
		<div class="field"><label>Yêu cầu của ý</label><textarea data-field="question">${escapeHTML(part.question || "")}</textarea></div>
		<div class="field"><label>Lời giải</label><textarea data-field="solution">${escapeHTML(part.solution || "")}</textarea></div>
		<div class="field"><label>Rubric / tiêu chí chấm</label><textarea data-field="rubric">${escapeHTML(part.rubric || "")}</textarea></div>`;
	return card;
}

function addEssayPart(button) { button.previousElementSibling.appendChild(createEssayPartCard()); }

function toggleExerciseEditorFields(select) {
	const card = select.closest(".lesson-exercise-card");
	const essay = select.value === "essay";
	card.querySelector(".mcq-editor").classList.toggle("hidden", essay);
	card.querySelector(".essay-editor").classList.toggle("hidden", !essay);
}

function addLessonSection() { document.getElementById("lesson-sections-editor").appendChild(createSectionCard()); }
function addLessonExercise() { document.getElementById("lesson-exercises-editor").appendChild(createExerciseCard()); }
function addTeacherExample(button) { button.previousElementSibling.appendChild(createExampleCard()); }

function collectStructuredLesson(title) {
	const sections = [...document.querySelectorAll(".lesson-section-card")].map(card => ({
		section_title: fieldValue(card, "section_title"), transition_intro: fieldValue(card, "transition_intro"),
		detailed_content: fieldValue(card, "detailed_content"), key_takeaway: fieldValue(card, "key_takeaway"),
		student_cloze_notes: lines(fieldValue(card, "student_cloze_notes")),
		teacher_examples: [...card.querySelectorAll(".example-card")].map((item, i) => ({ example_num: i + 1, problem: fieldValue(item, "problem"), teacher_solution: fieldValue(item, "teacher_solution"), student_friendly_explanation: fieldValue(item, "student_friendly_explanation"), common_mistake: fieldValue(item, "common_mistake") }))
	}));
	const exercises = [...document.querySelectorAll(".lesson-exercise-card")].map(card => {
		const type = fieldValue(card, "type");
		return {
			type, topic: fieldValue(card, "topic"), difficulty: fieldValue(card, "difficulty"), question: fieldValue(card, "question"),
			options: type === "multiple-choice" ? lines(fieldValue(card, "options")) : [],
			answer: type === "multiple-choice" ? fieldValue(card, "answer") : "",
			explanation: type === "multiple-choice" ? fieldValue(card, "explanation") : "",
			parts: type === "essay" ? [...card.querySelectorAll(".essay-part-card")].map(part => ({ label: fieldValue(part, "label"), question: fieldValue(part, "question"), solution: fieldValue(part, "solution"), rubric: fieldValue(part, "rubric") })) : []
		};
	});
	return { title, overview: document.getElementById("editor-overview").value.trim(), sections, exercises };
}

function fieldValue(root, name) { return root.querySelector(`[data-field="${name}"]`)?.value.trim() || ""; }
function lines(value) { return value.split("\n").map(v => v.trim()).filter(Boolean); }

// ==================== ERROR MODAL & UTILS ====================

function openErrorModal(draftId) {
  const draft = cachedDrafts.find(d => d.id === draftId);
  const errMsg = draft ? (draft.error_message || "Không có chi tiết lỗi") : "Không tìm thấy dữ liệu";

  document.getElementById("error-modal-text").innerText = errMsg;
  document.getElementById("error-modal").classList.remove("hidden");
}

function closeErrorModal() {
  document.getElementById("error-modal").classList.add("hidden");
}

function copyErrorLog() {
  const text = document.getElementById("error-modal-text").innerText;
  navigator.clipboard.writeText(text);
  showToast("Đã sao chép nội dung lỗi!");
}

function cleanYouTubeURL(urlStr) {
  try {
    const u = new URL(urlStr);
    if (u.hostname.includes("youtube.com") && u.searchParams.has("v")) {
      return `https://www.youtube.com/watch?v=${u.searchParams.get("v")}`;
    }
  } catch (e) {}
  return urlStr;
}

function setDashboardStatus(message, level = "info") {
  const el = document.getElementById("dashboard-status");
  if (!el) return;
  el.innerText = message;
  el.className = `status-banner status-${level}`;
}

function normalizeError(err) {
  if (!err) return "Không rõ lỗi";
  if (typeof err === "string") return err;
  if (err.message) return err.message;
  try {
    return JSON.stringify(err);
  } catch (_) {
    return String(err);
  }
}

function escapeHTML(value) {
  return String(value ?? "").replace(/[&<>'"]/g, ch => ({"&":"&amp;","<":"&lt;",">":"&gt;","'":"&#39;",'"':"&quot;"}[ch]));
}

// ==================== MODULE 3: CHẤM BÀI ====================

function scheduleGradingSearch() {
  clearTimeout(gradingSearchTimer);
  gradingSearchTimer = setTimeout(loadGradingPages, 300);
}

async function loadGradingPages() {
  const body = document.getElementById("grading-pages-body");
  if (!body) return;
  body.innerHTML = `<tr><td colspan="4" class="empty-cell">Đang tải bài đã giao...</td></tr>`;
  try {
    const rows = await window.go.main.App.V2ListAssignments(document.getElementById("grading-search").value.trim());
    document.getElementById("grading-count").innerText = `${(rows || []).length} bài`;
    if (!rows?.length) {
      body.innerHTML = `<tr><td colspan="4" class="empty-cell">Không có bài phù hợp.</td></tr>`;
      return;
    }
    body.innerHTML = rows.map(row => `<tr>
      <td><strong>${escapeHTML(row.student_name)}</strong><br><span class="text-muted">${escapeHTML(row.title)}</span></td>
      <td>${formatDateTime(row.assigned_at)}</td>
      <td>${renderCorrectAnswerCount(row)}</td>
      <td><div class="assignment-actions">
        <button class="btn btn-secondary compact" ${row.student_page_web_url ? "" : "disabled"} onclick="openOneNotePage('${escapeHTML(row.student_page_web_url)}')">Mở HS</button>
        <button class="btn btn-secondary compact" ${row.teacher_page_web_url ? "" : "disabled"} onclick="openOneNotePage('${escapeHTML(row.teacher_page_web_url)}')">Mở GV</button>
        <button class="btn btn-primary compact" onclick="openGradingPage('${escapeHTML(row.assignment_id)}')">Chấm bài</button>
      </div></td>
    </tr>`).join("");
  } catch (err) {
    body.innerHTML = `<tr><td colspan="4" class="empty-cell error-text">${escapeHTML(normalizeError(err))}</td></tr>`;
  }
}

async function openExternalURL(pageURL) {
  if (!pageURL) {
    showToast("Không có đường dẫn để mở", true);
    return;
  }
  try {
    await window.go.main.App.OpenExternalURL(pageURL);
  } catch (err) {
    showToast("Không thể mở đường dẫn: " + normalizeError(err), true);
  }
}

function openOneNotePage(pageURL) { return openExternalURL(pageURL); }

function switchGradingTab(tab) {
  const assignments = tab === "assignments";
  document.getElementById("grading-assignments-panel").classList.toggle("hidden", !assignments);
  document.getElementById("grading-mistakes-panel").classList.toggle("hidden", assignments);
  document.getElementById("grading-tab-assignments").classList.toggle("active", assignments);
  document.getElementById("grading-tab-mistakes").classList.toggle("active", !assignments);
  if (!assignments) loadStudentMistakes();
}

async function openGradingPage(pageID) {
  try {
    currentGradingAssignment = await window.go.main.App.V2GetAssignment(pageID);
    document.getElementById("grading-detail-title").innerText = currentGradingAssignment.title;
    document.getElementById("grading-detail-student").innerText = `Học sinh: ${currentGradingAssignment.student_name}`;
    copyModelOptions("grading-model");
    document.getElementById("grade-select-all").checked = true;
    document.getElementById("grading-items").innerHTML = (currentGradingAssignment.items || []).map(item => {
      const status = gradingItemStatus(item);
      return `<label class="grading-item"><input type="checkbox" class="grade-item-check" value="${item.id}" checked><span><strong>${escapeHTML(item.exercise.topic || "Câu hỏi")}</strong> · ${escapeHTML(item.exercise.type)} · <span class="result-${status.tone}">${status.label}</span><br><span>${escapeHTML(item.exercise.question)}</span></span></label>`;
    }).join("");
	document.getElementById("btn-push-feedback").classList.toggle("hidden", !(currentGradingAssignment.items || []).some(item => item.is_evaluated));
    navigate("grading-detail");
  } catch (err) { showToast("Không thể mở bài: " + normalizeError(err), true); }
}

function gradingItemStatus(item) {
  if (!item.is_valid) return { label: item.invalid_reason || "Chưa hoàn tất", tone: "pending" };
  if (!item.is_evaluated) return { label: "Chưa chấm", tone: "pending" };
  if (item.outcome === "correct") return { label: "Đúng", tone: "correct" };
  if (item.outcome === "partially_correct") return { label: "Đúng một phần", tone: "pending" };
  return { label: "Sai", tone: "wrong" };
}

async function handlePushFeedback() {
  if (!currentGradingAssignment) return;
  const button = document.getElementById("btn-push-feedback");
  button.disabled = true; button.innerText = "Đang đẩy...";
  try {
	await window.go.main.App.V2PushAssignmentFeedback(String(currentGradingAssignment.assignment_id));
    showToast("Đã đẩy lại nhận xét lên OneNote");
  } catch (err) { showToast("Lỗi đẩy nhận xét: " + normalizeError(err), true); }
  finally { button.disabled = false; button.innerText = "Đẩy lại nhận xét"; }
}

function toggleGradeAll(checked) { document.querySelectorAll(".grade-item-check").forEach(el => el.checked = checked); }

async function handleGradeAssignment() {
  if (!currentGradingAssignment) return;
  const itemIDs = [...document.querySelectorAll(".grade-item-check:checked")].map(el => String(el.value));
  if (!itemIDs.length) { showToast("Hãy chọn ít nhất một câu cần chấm", true); return; }
  const button = document.getElementById("btn-grade");
  button.disabled = true; button.innerText = "Đang chấm...";
  try {
    await window.go.main.App.V2GradeAssignment({ assignment_id: String(currentGradingAssignment.assignment_id), item_ids: itemIDs, model: document.getElementById("grading-model").value, prompt: document.getElementById("grading-prompt").value.trim() });
    showToast("Đã chấm và ghi nhận xét vào OneNote");
    await openGradingPage(currentGradingAssignment.assignment_id);
  } catch (err) { showToast("Lỗi chấm bài: " + normalizeError(err), true); }
  finally { button.disabled = false; button.innerText = "Chấm các câu đã chọn"; }
}

async function loadStudentMistakes() {
  const container = document.getElementById("mistake-groups");
  container.innerHTML = `<div class="card empty-cell">Đang tải lỗi sai...</div>`;
  try {
    const groups = await window.go.main.App.V2ListMistakes();
    mistakeById = new Map();
    for (const group of groups || []) indexMistakeTree(group.mistakes || [], group.student_id);
    if (!groups?.length) { container.innerHTML = `<div class="card empty-cell">Chưa ghi nhận lỗi sai nào.</div>`; return; }
    container.innerHTML = groups.map(group => `<details class="card mistake-group"><summary><strong>${escapeHTML(group.student_name)}</strong><span>${countMistakes(group.mistakes || [])} lỗi</span></summary><div class="mistake-list">${renderMistakeTree(group.mistakes || [])}</div></details>`).join("");
  } catch (err) { container.innerHTML = `<div class="card empty-cell error-text">${escapeHTML(normalizeError(err))}</div>`; }
}

function indexMistakeTree(nodes, studentID) {
  for (const node of nodes) {
    mistakeById.set(String(node.id), { ...node, student_id: studentID });
    indexMistakeTree(node.children || [], studentID);
  }
}
function countMistakes(nodes) { return nodes.reduce((total, node) => total + 1 + countMistakes(node.children || []), 0); }
function renderMistakeTree(nodes) {
  return nodes.map(node => `<div class="mistake-tree-node"><div class="mistake-row"><div><strong>${escapeHTML(node.topic)}</strong><p>${escapeHTML(node.reason)}</p></div><div class="mistake-row-actions">${renderMistakeStatus(node)}${canCreateRemediation(node) ? `<button class="btn btn-secondary compact" onclick="openRemediationModal('${escapeHTML(node.id)}')">Tạo bài khắc phục</button>` : ""}</div></div>${node.children?.length ? `<div class="mistake-tree-children">${renderMistakeTree(node.children)}</div>` : ""}</div>`).join("");
}

function renderCorrectAnswerCount(row) {
  const correct = Number(row.correct_count || 0);
  const total = Number(row.total_count || 0);
  const isAllCorrect = total > 0 && correct === total;
  return `<span class="badge ${isAllCorrect ? "badge-completed" : "badge-processing"}">${correct}/${total} câu đúng</span>`;
}

function renderMistakeStatus(mistake) {
  switch (String(mistake.status || "").toUpperCase()) {
    case "REMEDIATING":
      return `<span class="badge badge-processing">Đã giao bài khắc phục</span>`;
    case "RESOLVED":
      return `<span class="badge badge-completed">Đã khắc phục</span>`;
    case "DETECTED":
    default:
      // UI chỉ có ba trạng thái nghiệp vụ. Dữ liệu cũ/không rõ vẫn là lỗi mới.
      return `<span class="badge badge-failed">Đã phát hiện</span>`;
  }
}

function canCreateRemediation(mistake) {
  return !["REMEDIATING", "RESOLVED"].includes(String(mistake.status || "").toUpperCase());
}

function openRemediationModal(id) {
  const mistake = mistakeById.get(id);
  if (!mistake) return;
  selectedMistakeId = id;
  document.getElementById("remediation-context").innerText = `${mistake.topic}: ${mistake.reason}`;
  copyModelOptions("remediation-model");
  document.getElementById("remediation-modal").classList.remove("hidden");
}
function closeRemediationModal() { document.getElementById("remediation-modal").classList.add("hidden"); }
function copyModelOptions(targetID) {
  const source = document.getElementById("lesson-model-select");
  const target = document.getElementById(targetID);
  target.innerHTML = source.innerHTML;
  target.value = source.value || "gemini-3.7-flash";
}

async function handleGenerateRemediation() {
  const button = document.getElementById("btn-remediation"); button.disabled = true; button.innerText = "Đang tạo bản nháp...";
  try {
    await window.go.main.App.V2GenerateRemediation({ student_id: mistakeById.get(selectedMistakeId).student_id, mistake_id: selectedMistakeId, model: document.getElementById("remediation-model").value, prompt: document.getElementById("remediation-prompt").value.trim() });
    closeRemediationModal(); showToast("Đã tạo bản nháp bài khắc phục. Hãy mở, xem lại rồi giao bài từ danh sách bài giảng."); navigate("lessons");
  } catch (err) { showToast("Lỗi tạo bài: " + normalizeError(err), true); }
  finally { button.disabled = false; button.innerText = "Tạo bản nháp"; }
}

function formatDuration(minutes) {
  if (!minutes || minutes <= 0) return "0 phút";
  const h = Math.floor(minutes / 60);
  const m = minutes % 60;
  if (h === 0) return `${m} phút`;
  if (m === 0) return `${h} giờ`;
  return `${h} giờ ${m} phút`;
}

function formatDateTime(dateStr) {
  if (!dateStr) return "";
  const parts = new Intl.DateTimeFormat("en-GB", {
    timeZone: "Asia/Ho_Chi_Minh",
    hour: "2-digit", minute: "2-digit",
    day: "2-digit", month: "2-digit", year: "numeric",
    hourCycle: "h23",
  }).formatToParts(new Date(dateStr));
  const value = Object.fromEntries(parts.map(({ type, value }) => [type, value]));
  return `${value.hour}:${value.minute} ${value.day}/${value.month}/${value.year}`;
}

function formatDateForVietnam(date) {
  const parts = new Intl.DateTimeFormat("en-CA", {
    timeZone: "Asia/Ho_Chi_Minh", year: "numeric", month: "2-digit", day: "2-digit",
  }).formatToParts(date);
  const value = Object.fromEntries(parts.map(({ type, value }) => [type, value]));
  return `${value.year}-${value.month}-${value.day}`;
}

function vietnamDayBoundaryISO(date, endOfDay) {
  return `${date}T${endOfDay ? "23:59:59" : "00:00:00"}+07:00`;
}

function calculateMinutes(startStr, endStr) {
  if (!startStr || !endStr) return 0;
  return Math.max(0, Math.round((new Date(endStr) - new Date(startStr)) / 60000));
}

function showToast(msg, isError = false) {
  const t = document.getElementById("toast");
  clearToastTimer();
  t.innerText = msg;
  t.style.background = isError ? "#b91c1c" : "#0f172a";
  t.classList.remove("hidden");
  t.dataset.timer = setTimeout(() => t.classList.add("hidden"), 3500);
}

function showOneNotePublishSuccess() {
  const t = document.getElementById("toast");
  clearToastTimer();
  t.replaceChildren();
  t.style.background = "#0f172a";
  t.append("Đã đẩy bài lên sổ giáo viên và học sinh. ");
  const button = document.createElement("button");
  button.type = "button";
  button.textContent = "Đi tới chấm bài";
  button.className = "toast-link";
  button.addEventListener("click", () => {
    t.classList.add("hidden");
    navigate("grading");
  });
  t.appendChild(button);
  t.classList.remove("hidden");
  t.dataset.timer = setTimeout(() => t.classList.add("hidden"), 12000);
}

function clearToastTimer() {
  const t = document.getElementById("toast");
  if (t.dataset.timer) {
    clearTimeout(Number(t.dataset.timer));
    delete t.dataset.timer;
  }
}

function debounce(func, wait) {
  let timeout;
  return function(...args) {
    clearTimeout(timeout);
    timeout = setTimeout(() => func.apply(this, args), wait);
  };
}

// ==================== LOGIC GOOGLE MEET ====================
async function checkGoogleStatus() {
  try {
    const isConnected = await window.go.main.App.IsGoogleConnected();
    const el = document.getElementById("google-status-indicator");
    if (!el) return;

    if (isConnected) {
      el.innerHTML = `<span class="status-dot" style="color:#22c55e;">●</span> Đã kết nối`;
    } else {
      el.innerHTML = `<span class="status-dot" style="color:#94a3b8;">○</span> Chưa kết nối`;
    }
  } catch (err) {
    console.error("Lỗi kiểm tra Google Meet:", err);
  }
}

async function handleConnectGoogle() {
  showToast("Đang mở trình duyệt để đăng nhập Google Meet...");
  try {
    await window.go.main.App.ConnectGoogleMeet();
    showToast("Đã liên kết tài khoản Google Meet thành công!");
    checkGoogleStatus();
  } catch (err) {
    showToast("Lỗi đăng nhập: " + normalizeError(err), true);
  }
}

// ==================== LOGIC ONENOTE ====================
let oneNotePublishStudents = [];
let oneNotePublishTargets = new Map();

async function checkOneNoteStatus() {
  try {
    const isConnected = await window.go.main.App.IsOneNoteConnected();
    const el = document.getElementById("onenote-status-indicator");
    if (!el) return;

    if (isConnected) {
      el.innerHTML = `<span class="status-dot" style="color:#a855f7;">●</span> Đã kết nối`;
    } else {
      el.innerHTML = `<span class="status-dot" style="color:#94a3b8;">○</span> Chưa kết nối`;
    }
  } catch (err) {
    console.error("Lỗi kiểm tra OneNote:", err);
  }
}

async function handleConnectOneNote() {
  showToast("Đang mở trình duyệt để đăng nhập Microsoft OneNote...");
  try {
    await window.go.main.App.ConnectOneNote();
    showToast("Đã liên kết tài khoản OneNote thành công!");
    checkOneNoteStatus();
  } catch (err) {
    showToast("Lỗi đăng nhập: " + normalizeError(err), true);
  }
}

async function openPushOneNoteDialog() {
  try {
    const isConnected = await window.go.main.App.IsOneNoteConnected();
    if (!isConnected) {
      if (confirm("Bạn chưa kết nối tài khoản Microsoft OneNote. Bạn có muốn đăng nhập ngay bây giờ?")) {
        await handleConnectOneNote();
      }
      return;
    }

	showToast("Đang tải học sinh và cấu trúc OneNote...");
  const students = await window.go.main.App.V2ListStudentChoices();
	if (!students || students.length === 0) {
		showToast("Chưa có học sinh để giao bài", true);
		return;
	}
	oneNotePublishStudents = students;
	document.getElementById("on-student-id").innerHTML = students.map(s => `<option value="${s.id}">${escapeHTML(s.name)}</option>`).join("");

	document.getElementById("on-student-chapter-name").value = "";
	document.getElementById("on-teacher-chapter-name").value = "";
  await refreshOneNotePublishTargets();
    document.getElementById("on-page-title").value = document.getElementById("editor-title").value || "Buổi học mới";
    document.getElementById("onenote-modal").classList.remove("hidden");
  } catch (err) {
    showToast("Lỗi lấy sổ OneNote: " + normalizeError(err), true);
  }
}

async function refreshOneNotePublishTargets() {
  const studentID = document.getElementById("on-student-id").value;
  const student = oneNotePublishStudents.find(item => String(item.id) === String(studentID));
	if (!student) return;
  try {
    const targets = await window.go.main.App.V2PreparePublishing({ student_id: String(student.id) });
    oneNotePublishTargets.set(String(student.id), targets);
    renderOneNoteChapterTarget("student", targets.student, `${student.name}_HS`);
    renderOneNoteChapterTarget("teacher", targets.teacher, `${student.name}_GV`);
  } catch (err) {
    showToast("Lỗi đọc cấu trúc OneNote: " + normalizeError(err), true);
  }
}

function renderOneNoteChapterTarget(type, notebook, fallbackName) {
	const select = document.getElementById(`on-${type}-chapter-select`);
	const status = document.getElementById(`on-${type}-workspace-status`);
  const workspace = notebook && notebook.name ? notebook : null;

	select.replaceChildren();
	if (workspace) {
		status.textContent = `Notebook: ${workspace.name}`;
    for (const chapter of workspace.sections || []) {
			const option = document.createElement("option");
      option.value = chapter;
      option.textContent = chapter;
			select.appendChild(option);
		}
	} else {
		status.textContent = `Chưa có Notebook; hệ thống sẽ tạo “${fallbackName}”.`;
	}

	const createOption = document.createElement("option");
	createOption.value = "__new__";
	createOption.textContent = "+ Tạo chương mới";
	select.appendChild(createOption);
	if (!workspace || !workspace.sections || workspace.sections.length === 0) {
		select.value = "__new__";
	}
	toggleOneNoteChapterInput(type);
}

function toggleOneNoteChapterInput(type) {
	const select = document.getElementById(`on-${type}-chapter-select`);
	const input = document.getElementById(`on-${type}-chapter-name`);
	const isCreating = select.value === "__new__";
	input.classList.toggle("hidden", !isCreating);
	input.required = isCreating;
}

function readOneNoteChapterTarget(type) {
	const select = document.getElementById(`on-${type}-chapter-select`);
	if (select.value && select.value !== "__new__") {
		return { chapter_id: select.value };
	}
	const chapterName = document.getElementById(`on-${type}-chapter-name`).value.trim();
	return chapterName ? { chapter_name: chapterName } : null;
}

function closeOneNoteModal() {
  document.getElementById("onenote-modal").classList.add("hidden");
}

async function handleDoPushOneNote() {
  const studentID = String(document.getElementById("on-student-id").value);
	const studentChapter = readOneNoteChapterTarget("student");
	const teacherChapter = readOneNoteChapterTarget("teacher");
	const pageTitle = document.getElementById("on-page-title").value.trim();

	if (!studentID || !studentChapter || !teacherChapter || !pageTitle) {
		showToast("Vui lòng chọn học sinh, chọn hoặc nhập đủ hai Chapter và Tiêu đề", true);
    return;
  }

	const saved = await handleSaveDraft();
  if (!saved || !currentDraftId) {
    showToast("Không thể lưu bản nháp trước khi đẩy lên OneNote", true);
    return;
  }

  const btn = document.getElementById("btn-do-push-onenote");
  const origText = btn.innerText;
  btn.innerText = "Đang đẩy bài lên OneNote...";
  btn.disabled = true;

  try {
    const result = await window.go.main.App.V2PublishLesson({
          lesson_id: editingDraft.lesson_data.id,
        student_id: studentID,
        student_chapter_name: studentChapter.chapter_name || studentChapter.chapter_id,
        teacher_chapter_name: teacherChapter.chapter_name || teacherChapter.chapter_id,
        page_name: pageTitle,
    });
    showOneNotePublishSuccess();
    closeOneNoteModal();
  } catch (err) {
    showToast("Lỗi đẩy lên OneNote: " + normalizeError(err), true);
  } finally {
    btn.innerText = origText;
    btn.disabled = false;
  }
}
