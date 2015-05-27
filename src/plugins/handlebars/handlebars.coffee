# Handlebars
_ = require "underscore"

module.exports.register = (plugins) ->
  plugins.renderers.handlebars = require './renderer/handlebars.coffee'
  plugins.components.push.apply plugins.components, require('./components.json')
  labelsEn =
    "text":         "Text"
    "fontSize":     "Font Size"
    "fontFamily":   "Font Family"
    "fontColor":    "Font Color"
    "borderWidth":  "Border Width"
    "borderColor":  "Border Color"
    "fillColor":    "Fill Color"
    "href":         "Link"
    "oddColor":     "Odd Color"
    "evenColor":    "Even Color"
    "selected":     "Selected"
    "indeterminate":"Indeterminate"
  if not plugins.labels?
    plugins.labels = {}
  _.extend plugins.labels, labelsEn
