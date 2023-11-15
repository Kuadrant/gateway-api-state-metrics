local g = import 'lib/g.libsonnet';
local gwapi = import 'lib/gwapi/gwapi.libsonnet';
local var = import 'lib/gwapi/variables.libsonnet';

gwapi.dashboard('Policies', 'gatewayapipolicies', [
  var.routes('tlspolicy', 'TLSPolicy'),
  var.routes('dnspolicy', 'DNSPolicy'),
  var.routes('ratelimitpolicy', 'RateLimitPolicy'),
  var.routes('authpolicy', 'AuthPolicy'),
  var.routes('backendtlspolicy', 'BackendTLSPolicy')
])
+ g.dashboard.withPanels([
  gwapi.row('TLSPolicy', 1, 24, 0, 0),
  gwapi.stat('Total', 3, 2, 0, 0, 'Total number of TLSPolicy across all clusters', 'count(gatewayapi_tlspolicy_status{name=~"${tlspolicy}"})'),
  gwapi.stat('Ready', 3, 2, 2, 0, 'Total TLSPolicy with an Ready state', 'count(gatewayapi_tlspolicy_status{type="Ready", name=~"${tlspolicy}"})'),
  gwapi.policyPanel('TLSPolicy',6,10,4,0,'gatewayapi_tlspolicy_target_info{name=~"${tlspolicy}"}', 'Target Name', 'Gateway Details', '/d/gatewayapigateways/gateway-api-state-gateways?var-gateway=${__value.text}'),
  gwapi.row('DNSPolicy', 1, 24, 0, 2),
  gwapi.stat('Total', 3, 2, 0, 2, 'Total number of DNSPolicy across all clusters', 'count(gatewayapi_dnspolicy_status{name=~"${dnspolicy}"})'),
  gwapi.stat('Ready', 3, 2, 2, 2, 'Total DNSPolicy with an Ready state', 'count(gatewayapi_dnspolicy_status{type="Ready", name=~"${dnspolicy}"})'),
  gwapi.policyPanel('DNSPolicy',6,10,4,2,'gatewayapi_dnspolicy_target_info{name=~"${dnspolicy}"}', 'Target Name', 'Gateway Details', '/d/gatewayapigateways/gateway-api-state-gateways?var-gateway=${__value.text}'),
  gwapi.row('RateLimitPolicy', 1, 24, 0, 4),
  gwapi.stat('Total', 3, 2, 0, 4, 'Total number of RateLimitPolicy across all clusters', 'count(gatewayapi_ratelimitpolicy_status{name=~"${ratelimitpolicy}"})'),
  gwapi.stat('Available', 3, 2, 2, 4, 'Total RateLimitPolicy with an Available state', 'count(gatewayapi_ratelimitpolicy_status{type="Available", name=~"${ratelimitpolicy}"})'),
  gwapi.policyPanel('RateLimitPolicy',6,10,4,4,'gatewayapi_ratelimitpolicy_target_info{name=~"${ratelimitpolicy}"}', 'Target Name', 'HTTPRoute Details', '/d/gatewayapihttproutes/gateway-api-state-httproutes?var-httproute=${__value.text}'),
  gwapi.row('AuthPolicy', 1, 24, 0, 6),
  gwapi.stat('Total', 3, 2, 0, 6, 'Total number of AuthPolicy across all clusters', 'count(gatewayapi_authpolicy_status{name=~"${authpolicy}"})'),
  gwapi.stat('Available', 3, 2, 2, 6, 'Total AuthPolicy with an Available state', 'count(gatewayapi_authpolicy_status{type="Available", name=~"${authpolicy}"})'),
  gwapi.policyPanel('AuthPolicy',6,10,4,6,'gatewayapi_authpolicy_target_info{name=~"${authpolicy}"}', 'Target Name', 'HTTPRoute Details', '/d/gatewayapihttproutes/gateway-api-state-httproutes?var-httproute=${__value.text}'),
  gwapi.row('BackendTLSPolicy', 1, 24, 0, 8),
  gwapi.policyPanel('BackendTLSPolicy',6,10,4,8,'gatewayapi_backendtlspolicy_target_info{name=~"${backendtlspolicy}"}'),
])