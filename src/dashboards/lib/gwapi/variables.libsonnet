local g = import '../g.libsonnet';
local var = g.dashboard.variable;
local table = g.panel.table;

{
    datasource:
        var.datasource.new(
            'datasource',
            'prometheus',
        )
        + var.datasource.generalOptions.withLabel('Data Source'),

    gateways(name, regex, label):
        var.query.new(name, {
            query: 'label_values(gatewayapi_'+name+'_info, name)',
            refId: 'StandardVariableQuery',
        })
        + var.query.withRegex(regex)
        + var.query.withDatasource('prometheus', '${datasource}')
        + var.query.selectionOptions.withIncludeAll(true)
        + var.query.selectionOptions.withMulti(true)
        + var.query.generalOptions.withLabel(label),

    routes(name, label):
        var.query.new(name, {
            query: 'label_values(gatewayapi_'+name+'_created, name)',
            refId: 'StandardVariableQuery',
        })
        + var.query.withRegex('/(.*)/')
        + var.query.withDatasource('prometheus', '${datasource}')
        + var.query.selectionOptions.withIncludeAll(true)
        + var.query.selectionOptions.withMulti(true)
        + var.query.generalOptions.withLabel(label),

    withOverrides(fieldOverride):
        table.standardOptions.withOverrides(
            fieldOverride
        ),

    overrideNameWithProp(name, id, value):
        table.fieldOverride.byName.new(name)
        + table.fieldOverride.byName.withProperty(id, value),

    overrideName(name):
        table.fieldOverride.byName.new(name),

    overrideProp(id, value):
        table.fieldOverride.byName.withProperty(id, value),
}