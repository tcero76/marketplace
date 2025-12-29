package rds

import (
	routepb "github.com/envoyproxy/go-control-plane/envoy/config/route/v3"
)

func BuildRoutes(streams map[string]string) *routepb.RouteConfiguration {
	routes := []*routepb.Route{}

	for path, node := range streams {
		routes = append(routes, &routepb.Route{
			Match: &routepb.RouteMatch{
				PathSpecifier: &routepb.RouteMatch_Prefix{
					Prefix: "/" + path + "/",
				},
			},
			Action: &routepb.Route_Route{
				Route: &routepb.RouteAction{
					ClusterSpecifier: &routepb.RouteAction_Cluster{
						Cluster: node + "_hls",
					},
				},
			},
		})
	}

	return &routepb.RouteConfiguration{
		Name: "hls_routes",
		VirtualHosts: []*routepb.VirtualHost{
			{
				Name:    "media",
				Domains: []string{"*"},
				Routes:  routes,
			},
		},
	}
}

// func PushRoutes(nodeID string, routes []*routepb.RouteConfiguration) error {
// 	snapshot, err := cache.NewSnapshot(
// 		"v1", // versión (cambia cuando cambia estado)
// 		nil,
// 	)
// 	if err != nil {
// 		return err
// 	}

// 	if err := snapshot.Consistent(); err != nil {
// 		return err
// 	}

// 	return snapshotCache.SetSnapshot(context.Background(), nodeID, snapshot)
// }
