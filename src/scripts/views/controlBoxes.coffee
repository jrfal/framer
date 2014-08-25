Backbone = require 'backbone'
BaseView = require './baseView.coffee'
uiTemplates = require './../uiTemplates.coffee'

class ControlLayer extends BaseView
  el: '#framer_controls'
  controlBoxes: []

  render: ->
    if @model?
      $(@el).children().detach()
      elements = @model.get 'elements'

      for element in elements.models
        elementView = @getControlBox(element)
        $(@el).append(elementView.el)

  getControlBox: (element) ->
    controlBox = _.find @controlBoxes, (item) ->
      item.model == element
    if !controlBox?
      controlBox = new ControlBox {model: element}
      @controlBoxes.push controlBox
    return controlBox

class ControlBox extends BaseView
  template: uiTemplates.controlBox

  initialize: ->
    _.bindAll @, 'render'
    @render()

  render: ->
    @setElement $(@template(@model.attributes))

module.exports = ControlLayer
