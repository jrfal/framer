# BasicPost
_ = require "underscore"

module.exports.register = (plugins) ->
  plugins.postRenderers.basicPost = require './postRenderer/basicPost.coffee'
  checkbox = _.findWhere plugins.components, {component: "checkbox"}
  if checkbox?
    if not checkbox.postRenderers?
      checkbox.postRenderers = []
    checkbox.postRenderers.push "basicPost"
    checkbox.properties.push
      property: "indeterminate"
      type: "boolean"
