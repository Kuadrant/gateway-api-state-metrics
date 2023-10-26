local g = import '../g.libsonnet';
local var = import './variables.libsonnet';

{
  dashboard(title, uid, variables):
    g.dashboard.new('Gateway API State / ' + title)
    + g.dashboard.withUid(uid)
    + g.dashboard.time.withFrom('now-1h')
    + g.dashboard.withStyle('dark')
    + g.dashboard.withTags(['gateway-api', 'gateway-api-state'],)
    + g.dashboard.withEditable(false)
    + g.dashboard.withLinks([
      g.dashboard.link.dashboards.new('Gateway Dashboards', ['gateway-api-state'],)
      + g.dashboard.link.dashboards.options.withTargetBlank(false)
      + g.dashboard.link.dashboards.options.withKeepTime(true)
      + g.dashboard.link.dashboards.options.withIncludeVars(true)
      + g.dashboard.link.dashboards.options.withAsDropdown(false),
    ])
    + g.dashboard.withVariables([
      var.datasource,
    ] + variables,),

  row(title, h, w, x, y):
    g.panel.row.new(title)
    + g.panel.row.withGridPos({ h: h, w: w, x: x, y: y },),

  stat(title, h, w, x, y, desc, expr):
    g.panel.stat.new(title)
    + g.panel.stat.panelOptions.withGridPos(h, w, x, y)
    + g.panel.stat.panelOptions.withDescription(desc)
    + g.panel.stat.queryOptions.withDatasource('prometheus', '$datasource')
    + g.panel.stat.queryOptions.withTargets([
      g.query.prometheus.new(
        '$datasource',
        expr,
      )
      + g.query.prometheus.withInstant(true),
    ]),

  table(title, h, w, x, y, expr):
    g.panel.table.new(title)
    + g.panel.table.panelOptions.withGridPos(h, w, x, y)
    + g.panel.table.queryOptions.withDatasource('prometheus', '$datasource')
    + g.panel.table.queryOptions.withTargets([
      g.query.prometheus.new(
        '$datasource',
        expr,
      )
      + g.query.prometheus.withInstant(true)
      + g.query.prometheus.withRange(false)
      + g.query.prometheus.withFormat('table'),
    ]),

  tableRouteByGateway(title, h, w, x, y, expr, linkTitle, linkUrl):
    self.table(title, h, w, x, y, expr)
    + g.panel.table.standardOptions.withOverrides([
      g.panel.table.fieldOverride.byName.new('Name')
      + g.panel.table.fieldOverride.byName.withProperty(
        'custom.displayMode',
        'color-text'
      )
      + g.panel.table.fieldOverride.byName.withProperty(
        'links',
        [
          {
            title: linkTitle,
            url: linkUrl,
          },
        ]
      ),
    ])
    + g.panel.table.queryOptions.withTransformations([
      g.panel.table.transformation.withId('filterFieldsByName')
      + g.panel.table.transformation.withOptions({
        include: {
          names: [
            'name',
            'namespace',
            'parent_name',
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
          parent_kind: '',
          parent_name: 'Gateway',
          port: 'Port',
          prometheus: '',
          protocol: 'Protocol',
          tls_mode: 'TLS Mode',
        },
      }),
    ]),

  routePanel(title, h, w, x, y, expr):
    self.table(title, h, w, x, y, expr)
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

  routePanelReferences(title, h, w, x, y, expr):
    self.table(title, h, w, x, y, expr)
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

  policyPanel(title, h, w, x, y, expr, linkName="", linkTitle="", linkUrl=""):
    self.table(title, h, w, x, y, expr)
    + g.panel.table.queryOptions.withTransformations([
      g.panel.table.transformation.withId('filterFieldsByName')
      + g.panel.table.transformation.withOptions({
        include: {
          names: [
            'name',
            'target_kind',
            'target_name',
          ],
        },
      }),
    g.panel.table.transformation.withId('organize')
    + g.panel.table.transformation.withOptions({
      renameByName: {
        name: 'Name',
        target_kind: 'Target Kind',
        target_name: 'Target Name',
      },
    }),
    ])
    + var.withOverrides(
      (if linkTitle != "" && linkUrl != "" then [
        var.overrideName(linkName)
        + var.overrideProp('custom.displayMode', 'color-text')
        + var.overrideProp('links', [
          {
            title: linkTitle,
            url: linkUrl,
          },
        ])
      ]else [])
    )
}