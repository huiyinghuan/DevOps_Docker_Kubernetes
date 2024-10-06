package main

import (
	"fmt"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

func main() {
	r := chi.NewRouter()
	r.Use(middleware.Logger)

	fmt.Println("Starting server on :8080")
	r.Get("/api/message", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Welcome to the Go server with Chi!"))
	})

	http.ListenAndServe(":8080", r)
}
