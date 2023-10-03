local g = import 'lib/g.libsonnet';
local gwapi = import 'lib/gwapi/gwapi.libsonnet';
local var = import 'lib/gwapi/variables.libsonnet';

gwapi.dashboard('GRPCRoutes', 'gatewayapigrpcroutes', [
  var.routes('grpcroute', 'GRPCRoute')
])
+ g.dashboard.withPanels([
  gwapi.row('GRPCRoutes', 1, 24, 0, 0),
  gwapi.stat('Total', 3, 2, 0, 1, 'Total number of GRPCRoutes across all namespaces', 'count(gatewayapi_grpcroute_created{name=~"${grpcroute}"})'),
  gwapi.stat('Tar. Parents', 3, 2, 2, 1, 'Total number of parents (e.g. Gateways) targeted by GRPCRoutes', 'count(gatewayapi_grpcroute_parent_info{name=~"${grpcroute}"})'),
  gwapi.routePanel('GRPCRoutes',6,10,4,1,'gatewayapi_grpcroute_created{name=~"${grpcroute}"}'),
  gwapi.routePanelReferences('GRPCRoute *targeted* Parent References', 6, 10, 14, 1, 'gatewayapi_grpcroute_parent_info{name=~"${grpcroute}"}'),
  gwapi.stat('Att. Parents', 3, 2, 0, 4, 'Total number of parents (e.g. Gateways) attached to GRPCRoutes', 'count(gatewayapi_grpcroute_status_parent_info{name=~\"${grpcroute}\"})'),
  gwapi.routePanelReferences('GRPCRoute *attached* Parent References', 6, 10, 4, 7, 'gatewayapi_grpcroute_status_parent_info{name=~\"${grpcroute}\"}')
])