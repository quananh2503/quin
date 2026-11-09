package onenote

import "meet-attendance-clean/infrastructure2/database"

// NormalizeOneNoteWebURL chuẩn hóa các URL OneNote OneDrive trả về từ Microsoft Graph (dạng redir.aspx hoặc /edit)
// thành URL Doc.aspx hiện đại của Office Online / SharePoint.
func NormalizeOneNoteWebURL(rawURL string) string {
	return database.NormalizeOneNoteWebURL(rawURL)
}
