$ = require 'jquery'
Backbone = require 'backbone'
BaseView = require './../baseView.coffee'
PageView = require './../page.coffee'
uiTemplates = require './../../uiTemplates.coffee'
_ = require 'underscore'

class Editor extends PageView
  className: 'framer-control-layer'
  selected: null

  initialize: ->
    super()
    _.bindAll @, 'controlDragHandler', 'dropHandler', 'resizeDragHandler'

  newElementView: (model) ->
    return new ControlBox {model: model}

  controlDragHandler: (e) ->
    border = $(e.target).parent().find '.control-border'
    startX = e.originalEvent.x - border.offset().left
    startY = e.originalEvent.y - border.offset().top
    dragData = {id: $(e.target).data('element'), action: 'move', startX: startX, startY: startY}
    e.originalEvent.dataTransfer.setData('text/plain', JSON.stringify(dragData))
    $(e.target).addClass 'dragging'

  resizeDragHandler: (e) ->
    target = $(e.target).parent().find '.control-border'
    edge = $(e.target).data 'edge'

    clickX = 0
    clickY = 0

    if edge in ['tl','t','tr']
      clickY = $(e.target).offset().top + $(e.target).height() - e.originalEvent.y
    else if edge in ['bl','b','br']
      clickY = $(e.target).offset().top - e.originalEvent.y

    if edge in ['tl','l','bl']
      clickX = $(e.target).offset().left + $(e.target).width() - e.originalEvent.x
    else if edge in ['tr','r','br']
      clickX = $(e.target).offset().left - e.originalEvent.x

    dragData = {id: $(e.target).closest('.control-box').data('element'), action: 'resize', edge: edge, top: target.offset().top, right: target.offset().left + target.width(), bottom: target.offset().top + target.height(), left: target.offset().left, clickX: clickX, clickY: clickY}
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
      newProps = {}
      element = @model.getElementByID(dragData.id)
      x = e.originalEvent.clientX + dragData.clickX;
      y = e.originalEvent.clientY + dragData.clickY;

      if dragData.edge in ['tl','t','tr']
        newProps.h = Math.abs y - dragData.bottom
        newProps.y = y

      if dragData.edge in ['tr','r','br']
        newProps.w = Math.abs x - dragData.left

      if dragData.edge in ['bl','b','br']
        newProps.h = Math.abs y - dragData.top

      if dragData.edge in ['tl','l','bl']
        newProps.w = Math.abs x - dragData.right
        newProps.x = x

      element.set(newProps)

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
    _.bindAll @, 'render', 'selectHandler'
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

  selectHandler: (e) ->
    @createTextEditBox($(e.target).closest('.control-box').data('element'))

  events:
    "click"                   : "selectHandler"

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

module.exports = Editor
