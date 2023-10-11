local g = import 'lib/g.libsonnet';
local gwapi = import 'lib/gwapi/gwapi.libsonnet';
local var = import 'lib/gwapi/variables.libsonnet';

gwapi.dashboard('Policies', 'gatewayapipolicies', [
  var.routes('tlspolicy', 'TLSPolicy'),
  var.routes('ratelimitpolicy', 'RateLimitPolicy'),
  var.routes('backendtlspolicy', 'BackendTLSPolicy')
])
+ g.dashboard.withPanels([
  gwapi.row('TLSPolicy', 1, 24, 0, 0),
  gwapi.stat('Total', 3, 2, 0, 1, 'Total number of TLSPolicy across all clusters', 'count(gatewayapi_tlspolicy_status)'),
  gwapi.stat('Ready', 3, 2, 2, 1, 'Total TLSPolicy with an Ready state', 'count(gatewayapi_tlspolicy_status{type="Ready"})'),
  gwapi.policyPanel('TLSPolicy',6,10,4,1,'gatewayapi_tlspolicy_target_info'),
  gwapi.row('RateLimitPolicy', 1, 24, 0, 2),
  gwapi.stat('Total', 3, 2, 0, 3, 'Total number of RateLimitPolicy across all clusters', 'count(gatewayapi_ratelimitpolicy_status)'),
  gwapi.stat('Available', 3, 2, 2, 3, 'Total RateLimitPolicy with an Available state', 'count(gatewayapi_ratelimitpolicy_status{type="Available"})'),
  gwapi.policyPanel('RateLimitPolicy',6,10,4,7,'gatewayapi_ratelimitpolicy_target_info'),
  gwapi.row('BackendTLSPolicy', 1, 24, 0, 8),
  gwapi.policyPanel('BackendTLSPolicy',6,10,4,9,'gatewayapi_backendtlspolicy_target_info'),
])