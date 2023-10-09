local g = import 'lib/g.libsonnet';
local gwapi = import 'lib/gwapi/gwapi.libsonnet';
local var = import 'lib/gwapi/variables.libsonnet';

gwapi.dashboard('GatewayClasses', 'gatewayapigatewayclass', [
  var.gateways('gatewayclass', '', 'GatewayClass')
])
+ g.dashboard.withPanels([
  gwapi.row('Gateway Classes', 1, 24, 0, 0),
  gwapi.stat('Total', 3, 2, 0, 1, 'Total number of GatewayClasses across all clusters', 'count(gatewayapi_gatewayclass_info)'),
  gwapi.stat('Accepted', 3, 2, 2, 1, 'Total GatewayClasses with an Accepted state of True', 'count(gatewayapi_gatewayclass_status{type="Accepted"} > 0)'),
  gwapi.table('GatewayClasses', 6, 10, 4, 1, 'gatewayapi_gatewayclass_created')
  + var.withOverrides([
    var.overrideNameWithProp('Created At', 'unit', 'dateTimeAsIso')
  ])
  + g.panel.table.queryOptions.withTransformations([
    g.panel.table.transformation.withId('filterFieldsByName')
    + g.panel.table.transformation.withOptions({
      include: {
        names: [
          'customresource_version',
          'name',
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
        name: 'Name',
        namespace: 'Namespace',
      },
    }),
  ]),
  gwapi.table('Gateways (by GatewayClass)', 6, 10, 14, 1, 'gatewayapi_gateway_info')
  + var.withOverrides([
    var.overrideName('Name')
    + var.overrideProp('links', [
      {
        title: 'Gateway Details',
        url: '/d/gatewayapigateways/gateway-api-state-gateways?var-gateway=${__value.text}',
      }
    ])
    + var.overrideProp('custom.displayMode', 'color-text')
  ])
  + g.panel.table.queryOptions.withTransformations([
    g.panel.table.transformation.withId('filterFieldsByName')
    + g.panel.table.transformation.withOptions({
      include: {
        names: [
          'gatewayclass_name',
          'name',
          'namespace',
        ],
      },
    }),
    g.panel.table.transformation.withId('organize')
    + g.panel.table.transformation.withOptions({
      excludeByName: {
        Value: false,
        customresource_kind: true,
      },
      indexByName: {
        Value: 3,
        gatewayclass_name: 2,
        name: 0,
        namespace: 1,
      },
      renameByName: {
        Value: '# Instances',
        customresource_kind: 'Kind',
        customresource_version: 'Version',
        gatewayclass_name: 'GatewayClass',
        name: 'Name',
        namespace: 'Namespace',
      },
    }),
  ]),
  gwapi.table('Supported Features (by GatewayClass)', 6, 20, 4, 7, 'gatewayapi_gatewayclass_status_supported_features{name="$gatewayclass"}')
  + var.withOverrides([
    var.overrideNameWithProp('name', 'custom.width', 333)
  ])
  + g.panel.table.queryOptions.withTransformations([
    g.panel.table.transformation.withId('filterFieldsByName')
    + g.panel.table.transformation.withOptions({
      include: {
        names: [
          'features',
          'name',
        ],
      },
    }),
    g.panel.table.transformation.withId('groupBy')
    + g.panel.table.transformation.withOptions({
      fields: {
        features: {
          aggregations: [
            'allValues',
          ],
          operation: 'aggregate',
        },
        name: {
          aggregations: [],
          operation: 'groupby',
        },
      },
    }),
    g.panel.table.transformation.withId('organize')
    + g.panel.table.transformation.withOptions({
      excludeByName: {},
      indexByName: {},
      renameByName: {
        'features (allValues)': 'Features',
        name: 'GatewayClass',
      },
    }),
  ]),
])
