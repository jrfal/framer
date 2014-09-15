require 'jquery'
$ = require 'jquery'
uiTemplates = require './../uiTemplates.coffee'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
BaseView = require './baseView.coffee'

class ElementView extends BaseView
  template: uiTemplates.elementPalette

  render: ->
    $(@el).html @template()

  events:
    "click .rectangle":   "createElement"

module.exports = ElementView
