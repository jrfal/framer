require 'jquery'
$ = require 'jquery'
uiTemplates = require './../uiTemplates.coffee'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
BaseView = require './baseView.coffee'
components = require './../../components/components.json'

class ElementView extends BaseView
  template: uiTemplates.elementPalette

  render: ->
    _.bindAll @, 'createElementHandler'

    $(@el).html @template()

  createElement: (template) ->
    @trigger 'createElement', components[template]

  createElementHandler: (e) ->
    e.preventDefault()
    @createElement $(e.target).data('template')

  events:
    "click a":   "createElementHandler"

module.exports = ElementView
