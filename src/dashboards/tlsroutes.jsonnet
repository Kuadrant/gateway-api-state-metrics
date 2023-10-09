local g = import 'lib/g.libsonnet';
local gwapi = import 'lib/gwapi/gwapi.libsonnet';
local var = import 'lib/gwapi/variables.libsonnet';

gwapi.dashboard('TLSRoutes', 'gatewayapitlsroutes', [
  var.routes('tlsroute', 'TLSRoute')
])
+ g.dashboard.withPanels([
  gwapi.row('TLSRoutes', 1, 24, 0, 0),
  gwapi.stat('Total', 3, 2, 0, 1, 'Total number of TLSRoutes across all namespaces', 'count(gatewayapi_tlsroute_created{name=~"${tlsroute}"})'),
  gwapi.stat('Tar. Parents', 3, 2, 2, 1, 'Total number of parents (e.g. Gateways) targeted by TLSRoutes', 'count(gatewayapi_tlsroute_parent_info{name=~"${tlsroute}"})'),
  gwapi.routePanel('TLSRoutes',6,10,4,1,'gatewayapi_tlsroute_created{name=~"${tlsroute}"}'),
  gwapi.routePanelReferences('TLSRoute *targeted* Parent References', 6, 10, 14, 1, 'gatewayapi_tlsroute_parent_info{name=~"${tlsroute}"}'),
  gwapi.stat('Att. Parents', 3, 2, 0, 4, 'Total number of parents (e.g. Gateways) attached to TLSRoutes', 'count(gatewayapi_tlsroute_status_parent_info{name=~\"${tlsroute}\"})'),
  gwapi.routePanelReferences('TLSRoute *attached* Parent References', 6, 10, 4, 7, 'gatewayapi_tlsroute_status_parent_info{name=~\"${tlsroute}\"}')
])
