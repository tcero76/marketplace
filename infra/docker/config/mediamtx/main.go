package main

import (
	"bytes"
	"encoding/json"
	"log"
	"net/http"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		log.Fatal("missing hook type")
	}

	hookType := os.Args[1]
	log.Printf("hookType=%s", hookType)
	path := os.Getenv("MTX_PATH")

	node := os.Getenv("NODE_ID")

	payload := map[string]string{
		"path": path,
		"node": node,
	}

	log.Printf("node=%s path=%s\n", node, path)
	jsonBody, _ := json.Marshal(payload)

	http.Post(
		"http://mediamtx-service:3001/streamready",
		"application/json",
		bytes.NewBuffer(jsonBody),
	)
}
