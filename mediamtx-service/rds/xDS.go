package rds

import (
	clusterv3 "github.com/envoyproxy/go-control-plane/envoy/service/cluster/v3"
	discoverygrpc "github.com/envoyproxy/go-control-plane/envoy/service/discovery/v3"
	endpointv3 "github.com/envoyproxy/go-control-plane/envoy/service/endpoint/v3"
	listenerv3 "github.com/envoyproxy/go-control-plane/envoy/service/listener/v3"
	routev3 "github.com/envoyproxy/go-control-plane/envoy/service/route/v3"
	server "github.com/envoyproxy/go-control-plane/pkg/server/v3"
	"google.golang.org/grpc"
)

func RegisterXDSServices(grpcServer *grpc.Server, srv server.Server) {
	discoverygrpc.RegisterAggregatedDiscoveryServiceServer(grpcServer, srv)
	endpointv3.RegisterEndpointDiscoveryServiceServer(grpcServer, srv)
	clusterv3.RegisterClusterDiscoveryServiceServer(grpcServer, srv)
	routev3.RegisterRouteDiscoveryServiceServer(grpcServer, srv)
	listenerv3.RegisterListenerDiscoveryServiceServer(grpcServer, srv)
}
