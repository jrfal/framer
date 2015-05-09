# Markdown
_ = require "underscore"

module.exports.register = (plugins) ->
  plugins.transformations.markdown = require './transformation/markdown.coffee'
  textBlock = _.findWhere plugins.components, {component: "textBlock"}
  if textBlock?
    if not textBlock.transformations?
      textBlock.transformations = []
    textBlock.transformations.push ["markdown", "/text", "/html"]
