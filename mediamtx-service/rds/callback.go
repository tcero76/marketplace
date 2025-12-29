package rds

import (
	"context"
	"log"

	corev3 "github.com/envoyproxy/go-control-plane/envoy/config/core/v3"
	discovery "github.com/envoyproxy/go-control-plane/envoy/service/discovery/v3"
)

type Callbacks struct {
	Logger *log.Logger
}

func (cb *Callbacks) OnStreamOpen(ctx context.Context, id int64, typ string) error {
	cb.Logger.Printf("📡 Stream opened: %d type=%s", id, typ)
	return nil
}

func (cb *Callbacks) OnStreamClosed(id int64) {
	cb.Logger.Printf("❌ Stream closed: %d", id)
}

func (cb *Callbacks) OnStreamRequest(id int64, req *discovery.DiscoveryRequest) error {
	cb.Logger.Printf(
		"📨 Request: type=%s resources=%v node=%s",
		req.TypeUrl,
		req.ResourceNames,
		req.Node.GetId(),
	)
	return nil
}

func (cb *Callbacks) OnStreamResponse(
	ctx context.Context,
	id int64,
	req *discovery.DiscoveryRequest,
	resp *discovery.DiscoveryResponse,
) {
	cb.Logger.Printf("📤 Response: type=%s version=%s", resp.TypeUrl, resp.VersionInfo)
}

func (cb *Callbacks) OnDeltaStreamOpen(ctx context.Context, id int64, typ string) error {
	return nil
}

func (cb *Callbacks) OnDeltaStreamClosed(int64, *corev3.Node) {}

func (cb *Callbacks) OnDeltaStreamRequest(
	id int64,
	req *discovery.DeltaDiscoveryRequest,
) error {
	return nil
}

func (cb *Callbacks) OnDeltaStreamResponse(
	ctx context.Context,
	id int64,
	req *discovery.DeltaDiscoveryRequest,
	resp *discovery.DeltaDiscoveryResponse,
) {
}
