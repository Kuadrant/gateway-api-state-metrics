local g = import 'lib/g.libsonnet';
local gwapi = import 'lib/gwapi/gwapi.libsonnet';
local var = import 'lib/gwapi/variables.libsonnet';

gwapi.dashboard('UDPRoutes', 'gatewayapiudproutes', [
  var.routes('udproute', 'UDPRoute')
])
+ g.dashboard.withPanels([
  gwapi.row('UDPRoutes', 1, 24, 0, 0),
  gwapi.stat('Total', 3, 2, 0, 1, 'Total number of UDPRoutes across all namespaces', 'count(gatewayapi_udproute_created{name=~"${udproute}"})'),
  gwapi.stat('Tar. Parents', 3, 2, 2, 1, 'Total number of parents (e.g. Gateways) targeted by UDPRoutes', 'count(gatewayapi_udproute_parent_info{name=~"${udproute}"})'),
  gwapi.routePanel('UDPRoutes',6,10,4,1,'gatewayapi_udproute_created{name=~"${udproute}"}'),
  gwapi.routePanelReferences('UDPRoute *targeted* Parent References', 6, 10, 14, 1, 'gatewayapi_udproute_parent_info{name=~"${udproute}"}'),
  gwapi.stat('Att. Parents', 3, 2, 0, 4, 'Total number of parents (e.g. Gateways) attached to UDPRoutes', 'count(gatewayapi_udproute_status_parent_info{name=~\"${udproute}\"})'),
  gwapi.routePanelReferences('UDPRoute *attached* Parent References', 6, 10, 4, 7, 'gatewayapi_udproute_status_parent_info{name=~\"${udproute}\"}')
])
