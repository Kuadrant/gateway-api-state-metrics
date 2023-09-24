local g = import 'lib/g.libsonnet';
local gwapi = import 'lib/gwapi/gwapi.libsonnet';

gwapi.dashboard('Gateways', 'gatewayapigateways', [
  g.dashboard.variable.query.new(
    'gateway',
    {
      query: 'label_values(gatewayapi_gateway_info, name)',
      refId: 'StandardVariableQuery',
    },
  )
  + g.dashboard.variable.query.withRegex('/(.*)/')
  + g.dashboard.variable.query.withDatasource('prometheus', '${datasource}')
  + g.dashboard.variable.query.selectionOptions.withIncludeAll(true)
  + g.dashboard.variable.query.selectionOptions.withMulti(true)
  + g.dashboard.variable.query.generalOptions.withLabel('Gateway'),
])
+ g.dashboard.withPanels([
  gwapi.row('Gateways', 1, 24, 0, 0),
  gwapi.stat('Total', 3, 2, 0, 1, 'Total number of Gateways across all namespaces', 'count(gatewayapi_gateway_info{name=~"$gateway"})'),
  gwapi.stat('Unhealthy', 3, 2, 2, 1, 'Number of Gateways not in an Accepted and Programmed state', 'count((gatewayapi_gateway_status{name=~"$gateway",type="Accepted"} == 0) or (gatewayapi_gateway_status{name=~"$gateway",type="Programmed"} == 0)) or vector(0)'),
  gwapi.table('Gateways', 6, 10, 4, 1, 'gatewayapi_gateway_created{name=~"$gateway"} * on(name, namespace, instance) group_right gatewayapi_gateway_info{name=~"$gateway"}')
  + g.panel.table.standardOptions.withOverrides([
    g.panel.table.fieldOverride.byName.new('Created At')
    + g.panel.table.fieldOverride.byName.withProperty(
      'unit',
      'dateTimeAsIso'
    ),
    g.panel.table.fieldOverride.byName.new('Kind')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '108'
    ),
    g.panel.table.fieldOverride.byName.new('Version')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '98'
    ),
    g.panel.table.fieldOverride.byName.new('Name')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '125'
    ),
  ])
  + g.panel.table.queryOptions.withTransformations([
    g.panel.table.transformation.withId('filterFieldsByName')
    + g.panel.table.transformation.withOptions({
      include: {
        names: [
          'customresource_version',
          'gatewayclass_name',
          'name',
          'namespace',
          'Value',
        ],
      },
    }),
    g.panel.table.transformation.withId('calculateField')
    + g.panel.table.transformation.withOptions({
      alias: 'Created At',
      binary: {
        left: 'Value',
        operator: '*',
        reducer: 'sum',
        right: '1000',
      },
      mode: 'binary',
      reduce: {
        reducer: 'sum',
      },
      replaceFields: false,
    }),
    g.panel.table.transformation.withId('organize')
    + g.panel.table.transformation.withOptions({
      excludeByName: {
        Value: true,
        customresource_kind: true,
      },
      indexByName: {},
      renameByName: {
        Value: 'Created',
        customresource_kind: 'Kind',
        customresource_version: 'Version',
        gatewayclass_name: 'GatewayClass',
        name: 'Name',
        namespace: 'Namespace',
      },
    }),
  ]),
  gwapi.table('Gateway Listeners', 6, 10, 14, 1, 'gatewayapi_gateway_listener_info{name=~"$gateway"}')
  + g.panel.table.standardOptions.withOverrides([
    g.panel.table.fieldOverride.byName.new('Created At')
    + g.panel.table.fieldOverride.byName.withProperty(
      'unit',
      'dateTimeAsIso'
    ),
    g.panel.table.fieldOverride.byName.new('Kind')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '108'
    ),
    g.panel.table.fieldOverride.byName.new('Version')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '94'
    ),
    g.panel.table.fieldOverride.byName.new('Listener Name')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '112'
    ),
    g.panel.table.fieldOverride.byName.new('Hostname')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '163'
    ),
    g.panel.table.fieldOverride.byName.new('Port')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '59'
    ),
    g.panel.table.fieldOverride.byName.new('Protocol')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '77'
    ),
    g.panel.table.fieldOverride.byName.new('Name')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '91'
    ),
  ])
  + g.panel.table.queryOptions.withTransformations([
    g.panel.table.transformation.withId('filterFieldsByName')
    + g.panel.table.transformation.withOptions({
      include: {
        names: [
          'customresource_version',
          'hostname',
          'listener_name',
          'name',
          'namespace',
          'port',
          'protocol',
          'tls_mode',
          'Value',
        ],
      },
    }),
    g.panel.table.transformation.withId('organize')
    + g.panel.table.transformation.withOptions({
      excludeByName: {
        Value: true,
      },
      indexByName: {
        Value: 9,
        customresource_kind: 0,
        customresource_version: 1,
        hostname: 5,
        listener_name: 4,
        name: 2,
        namespace: 3,
        port: 6,
        protocol: 7,
        tls_mode: 8,
      },
      renameByName: {
        Value: '',
        customresource_kind: 'Kind',
        customresource_version: 'Version',
        hostname: 'Hostname',
        listener_name: 'Listener Name',
        name: 'Name',
        namespace: 'Namespace',
        port: 'Port',
        prometheus: '',
        protocol: 'Protocol',
        tls_mode: 'TLS Mode',
      },
    }),
  ]),
  gwapi.stat('Accepted', 3, 2, 0, 4, 'Total Gateways with an Accepted state of True', 'count(gatewayapi_gateway_status{name=~"$gateway",type="Accepted"} > 0)'),
  gwapi.stat('Programmed', 3, 2, 2, 4, 'Total Gateways with a Programmed state of True', 'count(gatewayapi_gateway_status{name=~"$gateway",type="Programmed"} > 0)'),
  gwapi.stat('Listeners', 3, 2, 0, 7, 'Total number of listeners across all Gateways', 'count(gatewayapi_gateway_listener_info{name=~"$gateway"})'),
  gwapi.stat('Att. Routes', 3, 2, 2, 7, 'Total number of attached routes across all listeners', 'sum(gatewayapi_gateway_status_listener_attached_routes{name=~"$gateway"})'),
  gwapi.table('Gateway Status Addresses', 6, 10, 4, 7, 'gatewayapi_gateway_status_address_info{name=~"$gateway"}')
  + g.panel.table.standardOptions.withOverrides([
    g.panel.table.fieldOverride.byName.new('Created At')
    + g.panel.table.fieldOverride.byName.withProperty(
      'unit',
      'dateTimeAsIso'
    ),
    g.panel.table.fieldOverride.byName.new('Kind')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '108'
    ),
    g.panel.table.fieldOverride.byName.new('Version')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '94'
    ),
    g.panel.table.fieldOverride.byName.new('Listener Name')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '119'
    ),
    g.panel.table.fieldOverride.byName.new('Hostname')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '163'
    ),
    g.panel.table.fieldOverride.byName.new('Port')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '59'
    ),
    g.panel.table.fieldOverride.byName.new('Protocol')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '104'
    ),
    g.panel.table.fieldOverride.byName.new('Name')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '136'
    ),
  ])
  + g.panel.table.queryOptions.withTransformations([
    g.panel.table.transformation.withId('filterFieldsByName')
    + g.panel.table.transformation.withOptions({
      include: {
        names: [
          'customresource_version',
          'name',
          'namespace',
          'type',
          'value',
        ],
      },
    }),
    g.panel.table.transformation.withId('organize')
    + g.panel.table.transformation.withOptions({
      excludeByName: {
        Value: true,
      },
      indexByName: {
        Value: 9,
        customresource_kind: 0,
        customresource_version: 1,
        hostname: 5,
        listener_name: 4,
        name: 2,
        namespace: 3,
        port: 6,
        protocol: 7,
        tls_mode: 8,
      },
      renameByName: {
        Value: '',
        customresource_kind: 'Kind',
        customresource_version: 'Version',
        hostname: 'Hostname',
        listener_name: 'Listener Name',
        name: 'Name',
        namespace: 'Namespace',
        port: 'Port',
        prometheus: '',
        protocol: 'Protocol',
        tls_mode: 'TLS Mode',
        type: 'Address Type',
        value: 'Address Value',
      },
    }),
  ]),
  gwapi.table('Gateway Listener Status - Attached Routes', 6, 10, 14, 7, 'gatewayapi_gateway_status_listener_attached_routes{name=~"$gateway"}')
  + g.panel.table.standardOptions.withOverrides([
    g.panel.table.fieldOverride.byName.new('Created At')
    + g.panel.table.fieldOverride.byName.withProperty(
      'unit',
      'dateTimeAsIso'
    ),
    g.panel.table.fieldOverride.byName.new('Kind')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '113'
    ),
    g.panel.table.fieldOverride.byName.new('Version')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '88'
    ),
    g.panel.table.fieldOverride.byName.new('Name')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '167'
    ),
    g.panel.table.fieldOverride.byName.new('Listener Name')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '167'
    ),
    g.panel.table.fieldOverride.byName.new('# Attached Routes')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '137'
    ),
  ])
  + g.panel.table.queryOptions.withTransformations([
    g.panel.table.transformation.withId('filterFieldsByName')
    + g.panel.table.transformation.withOptions({
      include: {
        names: [
          'customresource_version',
          'listener_name',
          'name',
          'namespace',
          'Value',
        ],
      },
    }),
    g.panel.table.transformation.withId('organize')
    + g.panel.table.transformation.withOptions({
      excludeByName: {
        Value: false,
      },
      indexByName: {
        Value: 9,
        customresource_kind: 0,
        customresource_version: 1,
        hostname: 5,
        listener_name: 4,
        name: 2,
        namespace: 3,
        port: 6,
        protocol: 7,
        tls_mode: 8,
      },
      renameByName: {
        Value: '# Attached Routes',
        customresource_kind: 'Kind',
        customresource_version: 'Version',
        hostname: 'Hostname',
        listener_name: 'Listener Name',
        name: 'Name',
        namespace: 'Namespace',
        port: 'Port',
        prometheus: '',
        protocol: 'Protocol',
        tls_mode: 'TLS Mode',
      },
    }),
  ]),

  gwapi.tableRouteByGateway('HTTPRoutes (by Gateway)', 6, 10, 4, 13, 'gatewayapi_httproute_parent_info{parent_kind="Gateway",parent_name=~"${gateway}"}', 'HTTPRoute Details', '/d/gatewayapihttproutes/gateway-api-state-httproutes?var-httproute=${__value.text}'),
  gwapi.tableRouteByGateway('GRPCRoutes (by Gateway)', 6, 10, 14, 13, 'gatewayapi_grpcroute_parent_info{parent_kind="Gateway",parent_name=~"${gateway}"}', 'GRPCRoute Details', '/d/gatewayapigrpcroutes/gateway-api-state-grpcroutes?var-grpcroute=${__value.text}'),
  gwapi.tableRouteByGateway('TLSRoutes (by Gateway)', 6, 10, 4, 19, 'gatewayapi_tlsroute_parent_info{parent_kind="Gateway",parent_name=~"${gateway}"}', 'TLSRoute Details', '/d/gatewayapitlsroutes/gateway-api-state-tlsroutes?var-tlsroute=${__value.text}'),
  gwapi.tableRouteByGateway('TCPRoutes (by Gateway)', 6, 10, 14, 19, 'gatewayapi_tcproute_parent_info{parent_kind="Gateway",parent_name=~"${gateway}"}', 'TCPRoute Details', '/d/gatewayapitcproutes/gateway-api-state-tcproutes?var-tcproute=${__value.text}'),
  gwapi.tableRouteByGateway('UDPRoutes (by Gateway)', 6, 10, 4, 25, 'gatewayapi_udproute_parent_info{parent_kind="Gateway",parent_name=~"${gateway}"}', 'UDPRoute Details', '/d/gatewayapiudproutes/gateway-api-state-udproutes?var-udproute=${__value.text}'),

])
