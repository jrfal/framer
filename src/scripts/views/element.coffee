$ = require 'jquery'
templates = require './../componentTemplates.coffee'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
uiTemplates = require './../uiTemplates.coffee'

class ElementView extends Backbone.View
  className: 'framer-element'

  template: templates.getTemplate 'rectangle'

  controlBox: null

  initialize: ->
    @controlLayer = $ '#framer_controls'

    _.bindAll @, 'render', 'setElement'
    @render()

  render: ->
    if @model?
      @setElement $(@template(@model.attributes))

      if !@controlBox?
        @controlBox = uiTemplates.controlBox()
        @controlLayer.append @controlBox

  modelData: ->
    return model.attributes


module.exports = ElementView
