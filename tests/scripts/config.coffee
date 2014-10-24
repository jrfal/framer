module.exports.templateDir = '../src/components/templates/'
module.exports.guiTemplateDir = '../src/templates/'
module.exports.transformations = {
  'comma-delimited' : require('../../src/scripts/transformations/commaDelimited.coffee'),
  'table-meta'      : require('../../src/scripts/transformations/tableMeta.coffee')
}
module.exports.settings = '../src/scripts/settings.json'
