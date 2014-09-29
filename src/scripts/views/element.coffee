$ = require 'jquery'
templates = require './../componentTemplates.coffee'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
uiTemplates = require './../uiTemplates.coffee'

class ElementView extends Backbone.View
  className: 'framer-element'

  template: templates.getTemplate 'rectangle'

  initialize: ->
    if @model.has 'template'
      template = @model.get 'template'
      @template = templates.getTemplate template
    _.bindAll @, 'render', 'setElement'
    @model.on "change", @render
    @render()

  render: ->
    if @model?
      oldEl = @el
      @setElement $(@template(@model.attributes))
      $(oldEl).replaceWith $(@el)

  modelData: ->
    return model.attributes


module.exports = ElementView
