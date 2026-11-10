package main

import (
	"context"
	"embed"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"sync"

	"github.com/wailsapp/wails/v2"
	"github.com/wailsapp/wails/v2/pkg/options"
	"github.com/wailsapp/wails/v2/pkg/options/assetserver"

	application2 "meet-attendance-clean/application2"
	"meet-attendance-clean/config"
	"meet-attendance-clean/domain2/assignment"
	"meet-attendance-clean/domain2/lesson"

	// "meet-attendance-clean/infrastructure/onenote"
	database2 "meet-attendance-clean/infrastructure2/database"
	gemini2 "meet-attendance-clean/infrastructure2/gemini"
	googlemeet "meet-attendance-clean/infrastructure2/googlemeet"
	"meet-attendance-clean/infrastructure2/html"
	"meet-attendance-clean/infrastructure2/onenote"
	onenote2 "meet-attendance-clean/infrastructure2/onenote"
	"meet-attendance-clean/infrastructure2/pdf"
	"meet-attendance-clean/infrastructure2/renderer"
	wailsAdapter "meet-attendance-clean/infrastructure2/wails"
	"meet-attendance-clean/infrastructure2/webserver"

	"meet-attendance-clean/infrastructure2/AI/deepseek"
	"meet-attendance-clean/infrastructure2/AI/pipeline"
	"meet-attendance-clean/infrastructure2/media"
)

// ============================================================================
// EMBEDDED ASSETS & CONFIGS
// ============================================================================

//go:embed all:frontend/dist
var assets embed.FS

//go:embed config/google-oauth.json
var embeddedGoogleCredentials []byte

//go:embed config/gemini-key.txt
var embeddedGeminiKey []byte

//go:embed config/microsoft-oauth.json
var embeddedMicrosoftCredentials []byte

const localDatabaseFilename = "quin-v1.1.db"

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
	imgRenderer := renderer.NewLocalRenderer()
	htmlRenderer := html.NewRenderer(imgRenderer)

	meetClient, err := googlemeet.NewClient(embeddedGoogleCredentials, googleTokenPath, cfg.GoogleRedirectURL)
	if err != nil {
		log.Fatalf("Lỗi khởi tạo Google Meet client: %v", err)
	}
	oneNoteClient := onenote.New(msCfg.ClientID, msCfg.ClientSecret, msCfg.RedirectURL, msTokenPath, database2.OneNoteLinks{Store: db}, database2.Assignments{Store: db}, htmlRenderer)

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

	// Kiểm tra chế độ chạy Web Server (phục vụ trình duyệt / iPad / Docker / Cloud)
	isWebMode := false
	for _, arg := range os.Args[1:] {
		if arg == "--web" || arg == "-web" {
			isWebMode = true
			break
		}
	}
	if os.Getenv("WEB_MODE") == "1" || os.Getenv("PORT") != "" {
		isWebMode = true
	}
	// Nếu chạy trên môi trường Linux không có giao diện đồ họa (headless server/container/render)
	if runtime.GOOS == "linux" && os.Getenv("DISPLAY") == "" && os.Getenv("WAYLAND_DISPLAY") == "" {
		isWebMode = true
	}

	if isWebMode {
		port := os.Getenv("PORT")
		if port == "" {
			port = "8080"
		}
		addr := ":" + port
		log.Printf("==================================================================")
		log.Printf("🚀 QUIN ĐANG CHẠY Ở CHẾ ĐỘ WEB SERVER CHO TRÌNH DUYỆT / IPAD")
		log.Printf("👉 Mở trình duyệt truy cập: http://localhost:%s", port)
		log.Printf("👉 Hoặc truy cập qua IP mạng LAN trên iPad: http://<IP-may-tinh>:%s", port)
		log.Printf("==================================================================")

		server := webserver.NewServer(addr, app, assets, http.HandlerFunc(app.ServePDFStream))
		if err := server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			log.Fatalf("Lỗi khởi chạy Web Server: %v", err)
		}
		return
	}

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
	meetGateway := googlemeet.NewAdapter(meetClient, database2.ExternalLinks{Store: db})
	// pdfProcessor := document2.NewPopplerProcessor()
	pdfProcessor := pdf.NewProcessor()

	// Quản lý API Key lưu trong SQLite DB
	apiKeysRepo := database2.APIKeys{Store: db}

	// Tự động gán ban đầu nếu DB chưa có key
	dbGeminiKey, errGemKey := apiKeysRepo.GetKey(context.Background(), "gemini")
	if errGemKey == nil && dbGeminiKey == "" {
		fallbackGem := strings.TrimSpace(geminiKey)
		if fallbackGem == "" {
			fallbackGem = strings.TrimSpace(os.Getenv("GEMINI_API_KEY"))
		}
		if fallbackGem != "" {
			if sErr := apiKeysRepo.SetKey(context.Background(), "gemini", fallbackGem); sErr != nil {
				log.Printf("cảnh báo: lưu gemini key mặc định vào DB: %v", sErr)
			}
			dbGeminiKey = fallbackGem
		}
	}

	dbDeepseekKey, errDSKey := apiKeysRepo.GetKey(context.Background(), "deepseek")
	if errDSKey == nil && dbDeepseekKey == "" {
		fallbackDS := strings.TrimSpace(os.Getenv("DEEPSEEK_API_KEY"))
		if fallbackDS != "" {
			if sErr := apiKeysRepo.SetKey(context.Background(), "deepseek", fallbackDS); sErr != nil {
				log.Printf("cảnh báo: lưu deepseek key mặc định vào DB: %v", sErr)
			}
			dbDeepseekKey = fallbackDS
		}
	}

	activeGeminiKey := dbGeminiKey
	if activeGeminiKey == "" {
		activeGeminiKey = geminiKey
	}
	var ai *gemini2.Client
	if activeGeminiKey != "" {
		var initErr error
		ai, initErr = gemini2.New(context.Background(), activeGeminiKey, pdfProcessor)
		if initErr != nil {
			log.Printf("cảnh báo: khởi tạo Gemini AI client: %v (vui lòng cấu hình key trong Cài đặt)", initErr)
		}
	}

	dynGemini := &dynamicGeminiGenerator{
		client:       ai,
		pdfProcessor: pdfProcessor,
		apiKeys:      apiKeysRepo,
	}
	dynGrader := &dynamicGrader{
		client:       ai,
		pdfProcessor: pdfProcessor,
		apiKeys:      apiKeysRepo,
	}

	// Router điều phối: chọn giữa DeepSeek Pipeline mới và Gemini cũ (đọc key động từ SQLite)
	dsGen := &dynamicDeepSeekGenerator{apiKeys: apiKeysRepo}
	dualGen := pipeline.NewDualLessonGenerator(dynGemini, dsGen)

	// Document Handlers
	uploadHandler, err := application2.NewUploadDocumentHandler(documents, storageRoot)
	if err != nil {
		return nil, fmt.Errorf("khởi tạo upload handler: %w", err)
	}
	extractHandler := application2.NewExtractPagesHandler(documents)

	return &wailsAdapter.Application2Services{
		ListAIModels: func(ctx context.Context) ([]wailsAdapter.ModelView, error) {
			result := []wailsAdapter.ModelView{
				{
					ID:          "deepseek-flash",
					DisplayName: "DeepSeek Flash (Pipeline mới - 30 Workers)",
					Description: "5-Stage Pipeline, 30 workers song song, phân dạng hạt mịn, mẹo Casio, bước giải chi tiết.",
				},
				{
					ID:          "gemini-3.8-flash",
					DisplayName: "Gemini 3.8 Flash (Pipeline cũ - Native PDF)",
					Description: "Pipeline cũ: Xử lý trực tiếp tài liệu PDF qua Google Gemini Flash.",
				},
			}
			return result, nil
		},
		GetAPIKeys: func(ctx context.Context) (map[string]string, error) {
			return apiKeysRepo.GetAll(ctx)
		},
		SaveAPIKey: func(ctx context.Context, provider, key string) error {
			provider = strings.ToLower(strings.TrimSpace(provider))
			if err := apiKeysRepo.SetKey(ctx, provider, key); err != nil {
				return err
			}
			if provider == "gemini" {
				_ = dynGrader.updateKey(ctx, key)
				_ = dynGemini.updateKey(ctx, key)
			}
			return nil
		},
		Queries:                   application2.NewQueries(database2.ReadStore{Store: db}),
		SyncMeetings:              application2.NewSyncMeetingUsecase(db, meetGateway, sessions, students),
		GenerateLesson:            application2.NewGenerateLessonUsecase(drafts, dualGen),
		GenerateRemediationLesson: application2.NewGenerateRemediationLessonUsecase(drafts, dualGen, graphs),
		UpdateLessonDraft:         application2.NewUpdateLessonDraftUsecase(drafts),
		UpdateStudent:             application2.NewUpdateInfoStudentUsecase(students),
		PreparePublishingTargets:  application2.NewPreparePublishingTargetsUsecase(students, oneNote),
		AssignLesson:              application2.NewAssignLessonUsecase(students, lessons, assignments, graphs, oneNote),
		GradeAssignment:           application2.NewGradeAssignmentUsecase(assignments, graphs, oneNote, dynGrader),
		Drafts:                    drafts,
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
// DYNAMIC DEEPSEEK GENERATOR (NẠP KEY ĐỘNG TỪ SQLITE)
// ============================================================================

type dynamicDeepSeekGenerator struct {
	apiKeys database2.APIKeys
}

func (d *dynamicDeepSeekGenerator) Generate(ctx context.Context, title string, materials []lesson.StudyMaterial, model string, prompt string) (*lesson.Lesson, error) {
	key, err := d.apiKeys.GetKey(ctx, "deepseek")
	if err != nil || strings.TrimSpace(key) == "" {
		key = strings.TrimSpace(os.Getenv("DEEPSEEK_API_KEY"))
	}
	if strings.TrimSpace(key) == "" {
		return nil, fmt.Errorf("chưa cấu hình API Key cho DeepSeek. Vui lòng vào mục 'Cài đặt' để nhập DeepSeek API Key")
	}

	dsModel := strings.TrimSpace(os.Getenv("DEEPSEEK_MODEL"))
	if dsModel == "" {
		dsModel = "deepseek-flash"
	}
	dsProvider := deepseek.NewProvider(key, dsModel)
	dsPlanner := pipeline.NewPlanner(dsProvider, dsModel)
	dsGenerator := pipeline.NewGenerator(dsProvider, dsModel, 30)
	dsRepairer := pipeline.NewRepairer(dsProvider, dsModel)
	dsAssembler := pipeline.NewAssembler()

	dsOrchestrator := pipeline.NewOrchestrator(
		nil,
		dsPlanner,
		dsGenerator,
		nil,
		dsRepairer,
		dsAssembler,
	)
	adapter := pipeline.NewOrchestratorLessonGeneratorAdapter(
		media.NewConverter(),
		dsOrchestrator,
		dsAssembler,
		"",
		30,
	)
	return adapter.Generate(ctx, title, materials, model, prompt)
}

// ============================================================================
// DYNAMIC GEMINI GENERATOR & GRADER (NẠP KEY ĐỘNG TỪ SQLITE)
// ============================================================================

type dynamicGeminiGenerator struct {
	mu           sync.RWMutex
	client       *gemini2.Client
	pdfProcessor gemini2.PDFProcessor
	apiKeys      database2.APIKeys
}

func (g *dynamicGeminiGenerator) Generate(ctx context.Context, title string, materials []lesson.StudyMaterial, model string, prompt string) (*lesson.Lesson, error) {
	g.mu.Lock()
	defer g.mu.Unlock()

	key, err := g.apiKeys.GetKey(ctx, "gemini")
	if err != nil || strings.TrimSpace(key) == "" {
		key = strings.TrimSpace(os.Getenv("GEMINI_API_KEY"))
	}
	key = strings.TrimSpace(key)
	if key == "" {
		return nil, errors.New("chưa cấu hình Gemini API Key. Vui lòng vào Cài đặt để thêm key")
	}

	if g.client == nil {
		c, errNew := gemini2.New(ctx, key, g.pdfProcessor)
		if errNew != nil {
			return nil, fmt.Errorf("không thể khởi tạo Gemini AI: %w", errNew)
		}
		g.client = c
	} else {
		_ = g.client.UpdateKey(ctx, key)
	}

	return g.client.Generate(ctx, title, materials, model, prompt)
}

func (g *dynamicGeminiGenerator) updateKey(ctx context.Context, key string) error {
	g.mu.Lock()
	defer g.mu.Unlock()

	key = strings.TrimSpace(key)
	if key == "" {
		return nil
	}
	if g.client == nil {
		c, err := gemini2.New(ctx, key, g.pdfProcessor)
		if err != nil {
			return err
		}
		g.client = c
		return nil
	}
	return g.client.UpdateKey(ctx, key)
}

type dynamicGrader struct {
	mu           sync.RWMutex
	client       *gemini2.Client
	pdfProcessor gemini2.PDFProcessor
	apiKeys      database2.APIKeys
}

func (g *dynamicGrader) Evaluate(ctx context.Context, gradeItems []assignment.EvaluationRequest, items []assignment.AssignmentItem, pageInk []byte, prompt string, model string) ([]assignment.EvaluationResult, error) {
	g.mu.Lock()
	defer g.mu.Unlock()

	key, err := g.apiKeys.GetKey(ctx, "gemini")
	if err != nil || strings.TrimSpace(key) == "" {
		key = strings.TrimSpace(os.Getenv("GEMINI_API_KEY"))
	}
	key = strings.TrimSpace(key)
	if key == "" {
		return nil, errors.New("chưa cấu hình Gemini API Key. Vui lòng vào Cài đặt để thêm key trước khi chấm bài.")
	}

	if g.client == nil {
		c, errNew := gemini2.New(ctx, key, g.pdfProcessor)
		if errNew != nil {
			return nil, fmt.Errorf("không thể khởi tạo Gemini AI để chấm bài: %w", errNew)
		}
		g.client = c
	} else {
		_ = g.client.UpdateKey(ctx, key)
	}

	return g.client.Evaluate(ctx, gradeItems, items, pageInk, prompt, model)
}

func (g *dynamicGrader) updateKey(ctx context.Context, key string) error {
	g.mu.Lock()
	defer g.mu.Unlock()

	key = strings.TrimSpace(key)
	if key == "" {
		return nil
	}
	if g.client == nil {
		c, err := gemini2.New(ctx, key, g.pdfProcessor)
		if err != nil {
			return err
		}
		g.client = c
		return nil
	}
	return g.client.UpdateKey(ctx, key)
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

// appDataDirectory lấy đường dẫn thư mục dữ liệu chuẩn người dùng từ hệ điều hành:
// Trên Windows: %APPDATA%\QUIN (C:\Users\<User>\AppData\Roaming\QUIN)
// Trên macOS:   ~/Library/Application Support/QUIN
// Trên Linux:   ~/.config/QUIN
func appDataDirectory() (string, error) {
	configDir, err := os.UserConfigDir()
	if err != nil {
		configDir, err = os.UserHomeDir()
		if err != nil {
			configDir = "."
		}
	}
	appDir := filepath.Join(configDir, "QUIN")
	if err := os.MkdirAll(appDir, 0755); err != nil {
		return ".", fmt.Errorf("không thể tạo thư mục dữ liệu ứng dụng: %w", err)
	}
	return appDir, nil
}
