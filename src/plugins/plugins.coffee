pluginFiles = [
  require('./masterPage/masterPage.coffee')
  require('./handlebars/handlebars.coffee')
  require('./basicPost/basicPost.coffee')
]

plugins = {}
plugins.components = []
plugins.transformations = {
  'form-elements'   : require('./transformations/formElements.coffee'),
  'comma-delimited' : require('./transformations/commaDelimited.coffee'),
  'line-list'       : require('./transformations/lineList.coffee'),
  'table-meta'      : require('./transformations/tableMeta.coffee')
}
plugins.validations = {
  'string'  : require('./validations/string.coffee'),
  'number'  : require('./validations/number.coffee'),
  'boolean' : require('./validations/boolean.coffee')
}
plugins.propertyTypes = require('./propertyTypes.json')
plugins.renderers = {}
plugins.postRenderers = {}

module.exports = plugins

plugins.modifyElementQueue = []
for pluginFile in pluginFiles
  pluginFile.register(plugins)
