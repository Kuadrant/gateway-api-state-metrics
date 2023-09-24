local g = import '../g.libsonnet';

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
      g.dashboard.variable.datasource.new(
        'datasource',
        'prometheus',
      )
      + g.dashboard.variable.datasource.generalOptions.withLabel('Data Source'),
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
}
