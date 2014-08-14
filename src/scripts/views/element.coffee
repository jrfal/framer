$ = require 'jquery'
templates = require './../componentTemplates.coffee'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'

class ElementView extends Backbone.View
  className: 'framer-element'

  template: templates.getTemplate 'rectangle'

  initialize: ->
    _.bindAll @, 'render'
    @render()

  render: ->
    if @model?
      @setElement $(@template(@model.attributes))

  modelData: ->
    return model.attributes


module.exports = ElementView
