module.exports.transformations = {
  'form-elements'   : require('./transformations/formElements.coffee'),
  'comma-delimited' : require('./transformations/commaDelimited.coffee'),
  'line-list'       : require('./transformations/lineList.coffee'),
  'table-meta'      : require('./transformations/tableMeta.coffee')
}
module.exports.validations = {
  'string':  require('./validations/string.coffee'),
  'number':  require('./validations/number.coffee'),
  'boolean': require('./validations/boolean.coffee')
}
module.exports.propertyTypes = require('../components/propertyTypes.json')
