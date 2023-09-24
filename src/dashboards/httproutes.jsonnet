local g = import 'lib/g.libsonnet';
local gwapi = import 'lib/gwapi/gwapi.libsonnet';

gwapi.dashboard('HTTPRoutes', 'gatewayapihttproutes', [
  g.dashboard.variable.query.new(
    'httproute',
    {
      query: 'label_values(gatewayapi_httproute_created, name)',
      refId: 'StandardVariableQuery',
    },
  )
  + g.dashboard.variable.query.withRegex('/(.*)/')
  + g.dashboard.variable.query.withDatasource('prometheus', '${datasource}')
  + g.dashboard.variable.query.selectionOptions.withIncludeAll(true)
  + g.dashboard.variable.query.selectionOptions.withMulti(true)
  + g.dashboard.variable.query.generalOptions.withLabel('HTTPRoute'),
])
+ g.dashboard.withPanels([
  gwapi.row('HTTPRoutes', 1, 24, 0, 0),
  gwapi.stat('Total', 3, 2, 0, 1, 'Total number of HTTPRoutes across all namespaces', 'count(gatewayapi_httproute_created{name=~"${httproute}"})'),
  gwapi.stat('Tar. Parents', 3, 2, 2, 1, 'Total number of parents (e.g. Gateways) targeted by HTTPRoutes', 'count(gatewayapi_httproute_parent_info{name=~"${httproute}"})'),
  gwapi.table('HTTPRoutes', 6, 10, 4, 1, 'gatewayapi_httproute_created{name=~"${httproute}"}')
  + g.panel.table.standardOptions.withOverrides([
    g.panel.table.fieldOverride.byName.new('Created At')
    + g.panel.table.fieldOverride.byName.withProperty(
      'unit',
      'dateTimeAsIso'
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
      },
      indexByName: {},
      renameByName: {
        Value: 'Created',
        customresource_kind: 'Kind',
        customresource_version: 'Version',
        name: 'Name',
        namespace: 'Namespace',
      },
    }),
  ]),
  gwapi.table('HTTPRoute *targeted* Parent References', 6, 10, 14, 1, 'gatewayapi_httproute_parent_info{name=~"${httproute}"}')
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
      '85'
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
      '98'
    ),
    g.panel.table.fieldOverride.byName.new('Parent Kind')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '103'
    ),
    g.panel.table.fieldOverride.byName.new('Parent Name')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '118'
    ),
    g.panel.table.fieldOverride.byName.new('Namespace')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '124'
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
          'parent_kind',
          'parent_name',
          'parent_namespace',
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
        parent_kind: 'Parent Kind',
        parent_name: 'Parent Name',
        parent_namespace: 'Parent Namespace',
        port: 'Port',
        prometheus: '',
        protocol: 'Protocol',
        tls_mode: 'TLS Mode',
        type: 'Address Type',
        value: 'Address Value',
      },
    }),
  ]),
  gwapi.stat('Att. Parents', 3, 2, 0, 4, 'Total number of parents (e.g. Gateways) attached to HTTPRoutes', 'count(gatewayapi_httproute_status_parent_info{name=~\"${httproute}\"})'),
  gwapi.table('HTTPRoute *attached* Parent References', 6, 10, 4, 7, 'gatewayapi_httproute_status_parent_info{name=~\"${httproute}\"}')
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
      '85'
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
      '98'
    ),
    g.panel.table.fieldOverride.byName.new('Parent Kind')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '103'
    ),
    g.panel.table.fieldOverride.byName.new('Parent Name')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '118'
    ),
    g.panel.table.fieldOverride.byName.new('Namespace')
    + g.panel.table.fieldOverride.byName.withProperty(
      'custom.width',
      '124'
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
          'parent_kind',
          'parent_name',
          'parent_namespace',
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
        parent_kind: 'Parent Kind',
        parent_name: 'Parent Name',
        parent_namespace: 'Parent Namespace',
        port: 'Port',
        prometheus: '',
        protocol: 'Protocol',
        tls_mode: 'TLS Mode',
        type: 'Address Type',
        value: 'Address Value',
      },
    }),
  ]),
])
