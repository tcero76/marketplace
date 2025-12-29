package rds

// type StreamEvent struct {
// 	Path string `json:"path"`
// 	Node string `json:"node"`
// }

// func StreamReadyHandler(cache cache.SnapshotCache) http.HandlerFunc {
// 	return func(w http.ResponseWriter, r *http.Request) {
// 		var evt StreamEvent
// 		json.NewDecoder(r.Body).Decode(&evt)

// 		log.Printf("🎥 Stream READY path=%s node=%s\n", evt.Path, evt.Node)

// 		snapshot, err := BuildSnapshot(evt.Path, evt.Node+"_hls")
// 		if err != nil {
// 			http.Error(w, err.Error(), 500)
// 			return
// 		}

// 		cache.SetSnapshot("envoy", snapshot)

// 		w.WriteHeader(http.StatusOK)
// 	}
// }
