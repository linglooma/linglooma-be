package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
	_ "github.com/linglooma/linglooma-be/doc/statik"
	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	pb "github.com/linglooma/linglooma-be/pb"
	"github.com/rs/zerolog/log"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

func callGRPCServer(audioData []byte) (*pb.SpeakingAssessment, error) {
	conn, err := grpc.NewClient("localhost:50051", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		return nil, fmt.Errorf("failed to connect to gRPC server: %v", err)
	}
	defer conn.Close()
	client := pb.NewSpeakingAssessmentServiceClient(conn)
	request := &pb.SpeakingAssessmentRequest{Audio: audioData}
	response, err := client.AssessSpeaking(context.Background(), request)
	if err != nil {
		return nil, fmt.Errorf("failed to call AssessSpeaking: %v", err)
	}

	return response, nil
}

func uploadHandler(w http.ResponseWriter, r *http.Request) {
    err := r.ParseMultipartForm(10 << 20) // Giới hạn 10MB
    if err != nil {
        http.Error(w, "Error parsing form", http.StatusBadRequest)
        return
    }

    file, _, err := r.FormFile("audio")
    if err != nil {
        http.Error(w, "Error retrieving file", http.StatusBadRequest)
        return
    }
    defer file.Close()

    // Đọc nội dung file
    audioData, err := io.ReadAll(file)
    if err != nil {
        http.Error(w, "Error reading file", http.StatusInternalServerError)
        return
    }

    response, err := callGRPCServer(audioData)
    if err != nil {
        http.Error(w, "Error calling gRPC: "+err.Error(), http.StatusInternalServerError)
        return
    }

    responseJSON, err := json.Marshal(response)
    if err != nil {
        http.Error(w, "Error encoding JSON: "+err.Error(), http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusOK)
    w.Write(responseJSON)
}

func main() {
	r := chi.NewRouter()
	r.Use(middleware.Logger)
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{"https://*", "http://*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type", "X-CSRF-Token"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: false,
		MaxAge:           300,
	  }))
	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello, World! Toi Yeu FTU va DAV"))
	})
	r.Post("/test-sessions/{testSessionID}/submissions", uploadHandler)
	go func() {
		err := http.ListenAndServe(":8080", r)
		if err != nil {
			log.Fatal().Err(err).Msg("Failed to start server")
		}
		log.Print("Server started at :8080...")
	}()
	select {}
}
