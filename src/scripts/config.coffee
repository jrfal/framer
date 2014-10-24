module.exports.templateDir = './components/templates/'
module.exports.guiTemplateDir = './templates/'
module.exports.transformations = {
  'comma-delimited' : require('./transformations/commaDelimited.coffee'),
  'table-meta'      : require('./transformations/tableMeta.coffee')
}
module.exports.settings = './scripts/settings.json'
