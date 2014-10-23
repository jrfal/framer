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
    _.bindAll @, 'createElementHandler', 'closeHandler'

    $(@el).html @template()

  createElement: (componentName) ->
    component = _.findWhere components, {component: componentName}
    if component?
      @trigger 'createElement', component

  createElementHandler: (e) ->
    e.preventDefault()
    @createElement $(e.target).data('template')

  closeHandler: (e) ->
    e.preventDefault()
    @trigger 'close'

  events:
    "click a.create":       "createElementHandler"
    "click a.close":        "closeHandler"

module.exports = ElementView
