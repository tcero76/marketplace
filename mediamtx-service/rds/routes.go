package rds

import (
	"time"

	clusterpb "github.com/envoyproxy/go-control-plane/envoy/config/cluster/v3"
	corepb "github.com/envoyproxy/go-control-plane/envoy/config/core/v3"
	endpointpb "github.com/envoyproxy/go-control-plane/envoy/config/endpoint/v3"
	listenerpb "github.com/envoyproxy/go-control-plane/envoy/config/listener/v3"
	routepb "github.com/envoyproxy/go-control-plane/envoy/config/route/v3"
	router "github.com/envoyproxy/go-control-plane/envoy/extensions/filters/http/router/v3"
	hcm "github.com/envoyproxy/go-control-plane/envoy/extensions/filters/network/http_connection_manager/v3"
	types "github.com/envoyproxy/go-control-plane/pkg/cache/types"
	cache "github.com/envoyproxy/go-control-plane/pkg/cache/v3"
	resource "github.com/envoyproxy/go-control-plane/pkg/resource/v3"
	"google.golang.org/protobuf/reflect/protoreflect"
	"google.golang.org/protobuf/types/known/anypb"
	"google.golang.org/protobuf/types/known/durationpb"
)

func BuildSnapshot(streamPath, clusterName string) (*cache.Snapshot, error) {
	cluster := &clusterpb.Cluster{
		Name:           clusterName,
		ConnectTimeout: durationpb.New(1 * time.Second),
		ClusterDiscoveryType: &clusterpb.Cluster_Type{
			Type: clusterpb.Cluster_LOGICAL_DNS,
		},
		LbPolicy: clusterpb.Cluster_ROUND_ROBIN,
		LoadAssignment: &endpointpb.ClusterLoadAssignment{
			ClusterName: clusterName,
			Endpoints: []*endpointpb.LocalityLbEndpoints{
				{
					LbEndpoints: []*endpointpb.LbEndpoint{
						{
							HostIdentifier: &endpointpb.LbEndpoint_Endpoint{
								Endpoint: &endpointpb.Endpoint{
									Address: &corepb.Address{
										Address: &corepb.Address_SocketAddress{
											SocketAddress: &corepb.SocketAddress{
												Address: "mediamtx1",
												PortSpecifier: &corepb.SocketAddress_PortValue{
													PortValue: 8888,
												},
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
	}

	// --- Route Configuration (para RDS) ---
	route := &routepb.RouteConfiguration{
		Name: "media_routes",
		VirtualHosts: []*routepb.VirtualHost{
			{
				Name:    "media",
				Domains: []string{"*"},
				Routes: []*routepb.Route{
					{
						Match: &routepb.RouteMatch{
							PathSpecifier: &routepb.RouteMatch_Prefix{
								Prefix: "/" + streamPath + "/",
							},
						},
						Action: &routepb.Route_Route{
							Route: &routepb.RouteAction{
								ClusterSpecifier: &routepb.RouteAction_Cluster{
									Cluster: clusterName,
								},
							},
						},
					},
				},
			},
		},
	}
	// --- Listener HLS con RDS ---
	hcmConfig := &hcm.HttpConnectionManager{
		StatPrefix: "hls",
		RouteSpecifier: &hcm.HttpConnectionManager_Rds{
			Rds: &hcm.Rds{
				RouteConfigName: "media_routes",
				ConfigSource: &corepb.ConfigSource{
					ResourceApiVersion: corepb.ApiVersion_V3,
					ConfigSourceSpecifier: &corepb.ConfigSource_ApiConfigSource{
						ApiConfigSource: &corepb.ApiConfigSource{
							ApiType:             corepb.ApiConfigSource_GRPC,
							TransportApiVersion: corepb.ApiVersion_V3,
							GrpcServices: []*corepb.GrpcService{
								{
									TargetSpecifier: &corepb.GrpcService_EnvoyGrpc_{
										EnvoyGrpc: &corepb.GrpcService_EnvoyGrpc{
											ClusterName: "control_plane",
										},
									},
								},
							},
						},
					},
				},
			},
		},
		HttpFilters: []*hcm.HttpFilter{
			{
				Name: "envoy.filters.http.router",
				ConfigType: &hcm.HttpFilter_TypedConfig{
					TypedConfig: mustAny(&router.Router{}),
				},
			},
		},
	}

	listener := &listenerpb.Listener{
		Name: "listener_hls",
		Address: &corepb.Address{
			Address: &corepb.Address_SocketAddress{
				SocketAddress: &corepb.SocketAddress{
					Address: "0.0.0.0",
					PortSpecifier: &corepb.SocketAddress_PortValue{
						PortValue: 8888,
					},
				},
			},
		},
		FilterChains: []*listenerpb.FilterChain{
			{
				Filters: []*listenerpb.Filter{
					{
						Name: "envoy.filters.network.http_connection_manager",
						ConfigType: &listenerpb.Filter_TypedConfig{
							TypedConfig: mustAny(hcmConfig),
						},
					},
				},
			},
		},
	}

	return cache.NewSnapshot(
		"1",
		map[resource.Type][]types.Resource{
			resource.ClusterType:  {cluster},
			resource.ListenerType: {listener},
			resource.RouteType:    {route},
		},
	)
}

func mustAny(pb any) *anypb.Any {
	a, _ := anypb.New(pb.(interface {
		ProtoReflect() protoreflect.Message
	}))
	return a
}
