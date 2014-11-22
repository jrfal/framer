module.exports.templateDir = './components/templates/'
module.exports.guiTemplateDir = './templates/'
module.exports.transformations = {
  'form-elements'   : require('./transformations/formElements.coffee'),
  'comma-delimited' : require('./transformations/commaDelimited.coffee'),
  'line-list'       : require('./transformations/lineList.coffee'),
  'table-meta'      : require('./transformations/tableMeta.coffee')
}
module.exports.settings = './scripts/settings.json'
