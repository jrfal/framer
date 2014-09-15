$ = require 'jquery'
Backbone = require 'backbone'
BaseView = require './baseView.coffee'
uiTemplates = require './../uiTemplates.coffee'
_ = require 'underscore'

class ControlLayer extends BaseView
  controlBoxes: []

  initialize: ->
    _.bindAll @, 'render', 'controlDragHandler', 'dropHandler', 'resizeDragHandler'

  setModel: (model) ->
    @model = model
    elements = @model.get 'elements'
    elements.on 'add', @render
    elements.on 'remove', @render
    elements.on 'sort', @render

  render: ->
    if @model?
      $(@el).children().detach()
      elements = @model.get 'elements'

      for element in elements.models
        controlBox = @getControlBox(element)
        $(@el).append(controlBox.el)

  getControlBox: (element) ->
    controlBox = _.find @controlBoxes, (item) ->
      item.model == element
    if !controlBox?
      controlBox = new ControlBox {model: element}
      @controlBoxes.push controlBox
    return controlBox

  controlDragHandler: (e) ->
    dragData = {id: $(e.target).data('element'), action: 'move', startX: e.clientX - e.target.offsetLeft, startY: e.clientY - e.target.offsetTop}
    e.originalEvent.dataTransfer.setData('text/plain', JSON.stringify(dragData))
    $(e.target).addClass 'dragging'

  resizeDragHandler: (e) ->
    target = $(e.target).parent()
    dragData = {id: $(e.target).closest('.control-box').data('element'), action: 'resize', x: target.offset().left, y: target.offset().top}
    e.originalEvent.dataTransfer.setData('text/plain', JSON.stringify(dragData))

    e.stopPropagation()

  dropHandler: (e) ->
    dragData = JSON.parse(e.originalEvent.dataTransfer.getData("text/plain"))

    if dragData.action == 'move'
      x = e.originalEvent.clientX - dragData.startX
      y = e.originalEvent.clientY - dragData.startY
      element = @model.getElementByID(dragData.id)
      element.set({'x': x, 'y': y})
    else if dragData.action == 'resize'
      width = Math.abs e.originalEvent.clientX - dragData.x
      height = Math.abs e.originalEvent.clientY - dragData.y
      element = @model.getElementByID(dragData.id)
      element.set({'w': width, 'h': height})

  dragOverHandler: (e) ->
    e.preventDefault()

  events:
    "dragstart .control-box"     : "controlDragHandler"
    "dragstart .resize-handle"   : "resizeDragHandler"
    "dragover"                   : "dragOverHandler"
    "drop"                       : "dropHandler"

class ControlBox extends BaseView
  template: uiTemplates.controlBox

  initialize: ->
    _.bindAll @, 'render', 'textEditHandler'
    @model.on "change", @render
    @render()

  render: ->
    if @model?
      oldEl = @el
      @setElement $(@template(@model.attributes))
      $(oldEl).replaceWith $(@el)

  createTextEditBox: (id) ->
    box = new PropertyPanel {model: @model}
    $("#framer_controls").append box.el

  textEditHandler: (e) ->
    @createTextEditBox($(e.target).closest('.control-box').data('element'))

  events:
    "click .text-edit-handle" : "textEditHandler"

class PropertyPanel extends BaseView
  template: uiTemplates.propertyPanel

  initialize: ->
    _.bindAll @, 'render', 'textEditCancelHandler', 'textEditSaveHandler'
    @render()

  render: ->
    if @model?
      oldEl = @el
      @setElement $(@template(@model.attributes))
      $(oldEl).replaceWith $(@el)

  textEditCancelHandler: ->
    @remove()

  textEditSaveHandler: ->
    newText =$(@el).find('.content').val()
    newFontFamily =$(@el).find('.font-family').val()
    newFontSize =$(@el).find('.font-size').val()
    if (newText != '')
      @model.set('text': newText)
    if (newFontFamily != '')
      @model.set('fontFamily': newFontFamily)
    if (newFontSize != '')
      @model.set('fontSize': newFontSize)
    @remove()

  events:
    "click .cancel" : "textEditCancelHandler"
    "click .save"   : "textEditSaveHandler"

module.exports = ControlLayer