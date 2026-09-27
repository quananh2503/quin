package main

import (
	"context"
	"embed"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"path/filepath"

	"github.com/wailsapp/wails/v2"
	"github.com/wailsapp/wails/v2/pkg/options"
	"github.com/wailsapp/wails/v2/pkg/options/assetserver"

	application2 "meet-attendance-clean/application2"
	"meet-attendance-clean/config"
	"meet-attendance-clean/infrastructure/onenote"
	database2 "meet-attendance-clean/infrastructure2/database"
	gemini2 "meet-attendance-clean/infrastructure2/gemini"
	googlemeet "meet-attendance-clean/infrastructure2/googlemeet"
	"meet-attendance-clean/infrastructure2/html"
	onenote2 "meet-attendance-clean/infrastructure2/onenote"
	"meet-attendance-clean/infrastructure2/pdf"
	"meet-attendance-clean/infrastructure2/renderer"
	wailsAdapter "meet-attendance-clean/infrastructure2/wails"
)

// ============================================================================
// EMBEDDED ASSETS & CONFIGS
// ============================================================================

//go:embed frontend
var assets embed.FS

//go:embed config/google-oauth.json
var embeddedGoogleCredentials []byte

//go:embed config/gemini-key.txt
var embeddedGeminiKey []byte

//go:embed config/microsoft-oauth.json
var embeddedMicrosoftCredentials []byte

const localDatabaseFilename = "attendance-local.db"

type MicrosoftConfig struct {
	ClientID     string `json:"client_id"`
	ClientSecret string `json:"client_secret"`
	RedirectURL  string `json:"redirect_url"`
}

// ============================================================================
// MAIN COMPOSITION ROOT
// ============================================================================

func main() {
	// 1. Phục vụ tiến trình sinh TypeScript bindings của Wails (tránh init SQLite thừa thãi)
	if isBindingGeneration() {
		app := &wailsAdapter.App{}
		if err := wails.Run(&options.App{
			Bind:  []any{app},
			Debug: options.Debug{OpenInspectorOnStartup: true},
		}); err != nil {
			log.Fatal(err)
		}
		return
	}

	// 2. Tải cấu hình & thư mục làm việc
	cfg, err := config.NewConfig()
	if err != nil {
		log.Printf("Cảnh báo config: %v", err)
	}

	dataDir, err := appDataDirectory()
	if err != nil {
		log.Fatalf("Lỗi tạo thư mục dữ liệu QUIN: %v", err)
	}

	// 3. Khởi tạo Database SQLite
	db, err := database2.Open(filepath.Join(dataDir, localDatabaseFilename))
	if err != nil {
		log.Fatalf("Lỗi mở database: %v", err)
	}
	defer db.Close()

	// 4. Khởi tạo External Clients (OAuth, Google Meet, OneNote)
	msCfg := loadMicrosoftConfig(embeddedMicrosoftCredentials)
	msTokenPath := filepath.Join(dataDir, "token_microsoft.json")
	googleTokenPath := filepath.Join(dataDir, "token.json")

	meetClient, _ := googlemeet.NewClient(embeddedGoogleCredentials, googleTokenPath, cfg.GoogleRedirectURL)
	oneNoteClient := onenote.New(msCfg.ClientID, msCfg.ClientSecret, msCfg.RedirectURL, msTokenPath)

	// 5. Wire toàn bộ Application Services (Dependency Injection)
	services, err := buildApplicationServices(
		db,
		meetClient,
		string(embeddedGeminiKey),
		msCfg,
		msTokenPath,
		filepath.Join(dataDir, "document-storage"),
	)
	if err != nil {
		log.Fatalf("Lỗi khởi tạo services: %v", err)
	}

	// 6. Gắn Services vào Wails Adapter & Khởi chạy ứng dụng
	app := wailsAdapter.NewApp(oneNoteClient, meetClient)
	app.SetApplication2Services(services)

	err = wails.Run(&options.App{
		Title:       "QUIN",
		Width:       1280,
		Height:      820,
		MinWidth:    1024,
		MinHeight:   700,
		AssetServer: &assetserver.Options{Assets: assets},
		OnStartup:   app.Startup,
		Bind:        []any{app},
	})

	if err != nil {
		log.Fatal(err)
	}
}

// ============================================================================
// SERVICE BUILDER (DEPENDENCY INJECTION)
// ============================================================================

func buildApplicationServices(
	db *database2.SQLite,
	meetClient *googlemeet.Client,
	geminiKey string,
	msCfg MicrosoftConfig,
	tokenPath string,
	storageRoot string,
) (*wailsAdapter.Application2Services, error) {
	// Repositories
	students := database2.Students{Store: db}
	sessions := database2.Sessions{Store: db}
	drafts := database2.Drafts{Store: db}
	lessons := database2.Lessons{Store: db}
	assignments := database2.Assignments{Store: db}
	graphs := database2.Graphs{Store: db}
	documents := database2.Documents{Store: db}

	// Khôi phục các bản nháp bị đứt đoạn do tắt ứng dụng đột ngột
	if err := drafts.RecoverInterrupted(context.Background()); err != nil {
		return nil, fmt.Errorf("khôi phục lesson draft bị gián đoạn: %w", err)
	}
	imgRenderer := renderer.NewLocalRenderer()

	// 2. Khởi tạo bộ lắp ghép HTML (đưa imgRenderer vào)
	htmlRenderer := html.NewRenderer(imgRenderer)
	// Gateways & Adapters
	oneNote := onenote2.New(msCfg.ClientID, msCfg.ClientSecret, msCfg.RedirectURL, tokenPath, database2.OneNoteLinks{Store: db}, assignments, htmlRenderer)
	meetGateway := googlemeet.NewAdapter(meetClient, db)
	// pdfProcessor := document2.NewPopplerProcessor()
	pdfProcessor := pdf.NewProcessor()
	ai, err := gemini2.New(context.Background(), geminiKey, pdfProcessor)
	if err != nil {
		return nil, fmt.Errorf("khởi tạo Gemini AI client thất bại: %w", err)
	}
	// defer cancel()

	// Document Handlers
	uploadHandler, err := application2.NewUploadDocumentHandler(documents, storageRoot)
	if err != nil {
		return nil, fmt.Errorf("khởi tạo upload handler: %w", err)
	}
	extractHandler := application2.NewExtractPagesHandler(documents)

	return &wailsAdapter.Application2Services{
		ListAIModels: func(ctx context.Context) ([]wailsAdapter.ModelView, error) {
			models, err := ai.ListModels(ctx)
			if err != nil {
				return nil, err
			}
			result := make([]wailsAdapter.ModelView, 0, len(models))
			for _, m := range models {
				result = append(result, wailsAdapter.ModelView{
					ID:          m.ID,
					DisplayName: m.DisplayName,
					Description: m.Description,
				})
			}
			return result, nil
		},
		Queries:                   application2.NewQueries(database2.ReadStore{Store: db}),
		SyncMeetings:              application2.NewSyncMeetingUsecase(db, meetGateway, sessions, students),
		GenerateLesson:            application2.NewGenerateLessonUsecase(drafts, ai),
		GenerateRemediationLesson: application2.NewGenerateRemediationLessonUsecase(drafts, ai, graphs),
		UpdateLessonDraft:         application2.NewUpdateLessonDraftUsecase(drafts),
		UpdateStudent:             application2.NewUpdateInfoStudentUsecase(students),
		PreparePublishingTargets:  application2.NewPreparePublishingTargetsUsecase(students, oneNote),
		AssignLesson:              application2.NewAssignLessonUsecase(students, lessons, assignments, graphs, oneNote),
		GradeAssignment:           application2.NewGradeAssignmentUsecase(assignments, graphs, oneNote, ai),
		Lessons:                   lessons,
		Assignments:               assignments,
		Workspace:                 oneNote,
		StorageRoot:               storageRoot,
		DocRepo:                   documents,
		UploadHandler:             uploadHandler,
		ExtractHandler:            extractHandler,
	}, nil
}

// ============================================================================
// HELPERS
// ============================================================================

func loadMicrosoftConfig(data []byte) MicrosoftConfig {
	var cfg MicrosoftConfig
	_ = json.Unmarshal(data, &cfg)
	if cfg.RedirectURL == "" {
		cfg.RedirectURL = "http://localhost:9000/oauth/microsoft/callback"
	}
	return cfg
}

func appDataDirectory() (string, error) {
	return os.Getwd()
}
