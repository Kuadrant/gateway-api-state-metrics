local g = import 'lib/g.libsonnet';
local gwapi = import 'lib/gwapi/gwapi.libsonnet';
local var = import 'lib/gwapi/variables.libsonnet';

gwapi.dashboard('HTTPRoutes', 'gatewayapihttproutes', [
  var.routes('httproute', 'HTTPRoute')
])
+ g.dashboard.withPanels([
  gwapi.row('HTTPRoutes', 1, 24, 0, 0),
  gwapi.stat('Total', 3, 2, 0, 1, 'Total number of HTTPRoutes across all namespaces', 'count(gatewayapi_httproute_created{name=~"${httproute}"})'),
  gwapi.stat('Tar. Parents', 3, 2, 2, 1, 'Total number of parents (e.g. Gateways) targeted by HTTPRoutes', 'count(gatewayapi_httproute_parent_info{name=~"${httproute}"})'),
  gwapi.routePanel('HTTPRoutes',6,10,4,1,'gatewayapi_httproute_created{name=~"${httproute}"}'),
  gwapi.routePanelReferences('HTTPRoute *targeted* Parent References', 6, 10, 14, 1, 'gatewayapi_httproute_parent_info{name=~"${httproute}"}'),
  gwapi.stat('Att. Parents', 3, 2, 0, 4, 'Total number of parents (e.g. Gateways) attached to HTTPRoutes', 'count(gatewayapi_httproute_status_parent_info{name=~\"${httproute}\"})'),
  gwapi.routePanelReferences('HTTPRoute *attached* Parent References', 6, 10, 4, 7, 'gatewayapi_httproute_status_parent_info{name=~\"${httproute}\"}')
])
