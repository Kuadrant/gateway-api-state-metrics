local g = import 'lib/g.libsonnet';
local gwapi = import 'lib/gwapi/gwapi.libsonnet';
local var = import 'lib/gwapi/variables.libsonnet';

gwapi.dashboard('TCPRoutes', 'gatewayapitcproutes', [
  var.routes('tcproute', 'TCPRoute')
])
+ g.dashboard.withPanels([
  gwapi.row('TCPRoutes', 1, 24, 0, 0),
  gwapi.stat('Total', 3, 2, 0, 1, 'Total number of TCPRoutes across all namespaces', 'count(gatewayapi_tcproute_created{name=~"${tcproute}"})'),
  gwapi.stat('Tar. Parents', 3, 2, 2, 1, 'Total number of parents (e.g. Gateways) targeted by TCPRoutes', 'count(gatewayapi_tcproute_parent_info{name=~"${tcproute}"})'),
  gwapi.routePanel('TCPRoutes',6,10,4,1,'gatewayapi_tcproute_created{name=~"${tcproute}"}'),
  gwapi.routePanelReferences('TCPRoute *targeted* Parent References', 6, 10, 14, 1, 'gatewayapi_tcproute_parent_info{name=~"${tcproute}"}'),
  gwapi.stat('Att. Parents', 3, 2, 0, 4, 'Total number of parents (e.g. Gateways) attached to TCPRoutes', 'count(gatewayapi_tcproute_status_parent_info{name=~\"${tcproute}\"})'),
  gwapi.routePanelReferences('TCPRoute *attached* Parent References', 6, 10, 4, 7, 'gatewayapi_tcproute_status_parent_info{name=~\"${tcproute}\"}')
])
