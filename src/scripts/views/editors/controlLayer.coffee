$ = require 'jquery'
Backbone = require 'backbone'
BaseView = require './../baseView.coffee'
PageView = require './../page.coffee'
uiTemplates = require './../../uiTemplates.coffee'
_ = require 'underscore'
Editor = require './../../models/editor.coffee'

class ControlLayer extends PageView
  className: 'framer-control-layer'
  editor: null

  initialize: ->
    @editor = new Editor()
    super()

  newElementView: (model) ->
    return new ControlBox {model: model, editor: @editor}

class ControlBox extends BaseView
  template: uiTemplates.controlBox
  selected: false
  editor: null

  initialize: (options) ->
    _.bindAll @, 'render', 'selectHandler', 'checkSelected', 'startMoveHandler',
      'moveHandler', 'stopMoveHandler', 'startResizeHandler', 'resizeHandler',
      'stopResizeHandler'
    @model.on "change", @render
    if 'editor' of options
      @editor = options.editor
      @editor.get('selection').on "add remove reset", @checkSelected if @editor?
    @render()

  render: ->
    if @model?
      oldEl = @el
      viewAttributes = _.clone @model.attributes
      @setElement $(@template(_.extend(viewAttributes, {selected: @selected})))
      $(oldEl).replaceWith $(@el)

  showPropertyPanel: (id) ->
    box = new PropertyPanel {model: @model}
    $("#framer_controls").append box.el
    box.slideIn()

  select: ->
    @selected = true
    @editor.selectElement @model if @editor?
    @render()

  deselect: ->
    @selected = false
    @editor.deselectElement @model if @editor?
    @render()

  selectHandler: (e) ->
    @editor.selectOnlyElement @model
    @showPropertyPanel($(e.target).closest('.control-box').data('element'))

  checkSelected: ->
    if @editor.isSelected @model
      if !@selected
        @select()
    else
      if @selected
        @deselect()

  startMoveHandler: (e) ->
    @grab = {x: e.clientX - @model.get('x'), y: e.clientY - @model.get('y')}
    $(document).on 'mousemove', @moveHandler
    $(document).on 'mouseup', @stopMoveHandler

  moveHandler: (e) ->
    x =  e.clientX - @grab.x
    y =  e.clientY - @grab.y
    @model.set({'x': x, 'y': y})

  stopMoveHandler: (e) ->
    $(document).off 'mousemove', @moveHandler
    $(document).off 'mouseup', @stopMoveHandler

  startResizeHandler: (e) ->
    @grab = {x: e.clientX, y: e.clientY - @model.get('y')}
    @resizeEdge = $(e.target).data 'edge'
    if @resizeEdge in ['tl', 't', 'tr']
      @grab.y =  @model.get('y') - @grab.y
    if @resizeEdge in ['tr', 'r', 'br']
      @grab.x =  @model.get('x') + @model.get('w') - @grab.x
    if @resizeEdge in ['bl', 'b', 'br']
      @grab.y =  @model.get('y') + @model.get('h') - @grab.y
    if @resizeEdge in ['tl', 'l', 'bl']
      @grab.x =  @model.get('x') - @grab.x
    @grab = {x: 0, y: 0}
    $(document).on 'mousemove', @resizeHandler
    $(document).on 'mouseup', @stopResizeHandler

  resizeHandler: (e) ->
    top = @model.get('y')
    left = @model.get('x')
    right = left + @model.get('w')
    bottom = top + @model.get('h')
    if @resizeEdge in ['tl', 't', 'tr']
      top = e.clientY + @grab.y
    if @resizeEdge in ['tr', 'r', 'br']
      right = e.clientX + @grab.x
    if @resizeEdge in ['bl', 'b', 'br']
      bottom = e.clientY + @grab.y
    if @resizeEdge in ['tl', 'l', 'bl']
      left = e.clientX + @grab.x
    if (left > right)
      swap = left
      left = right
      right = swap
    if (top > bottom)
      swap = top
      top = bottom
      bottom = swap
    @model.set({'x': left, 'y': top, 'w': right - left, 'h': bottom - top})


  stopResizeHandler: (e) ->
    $(document).off 'mousemove', @resizeHandler
    $(document).off 'mouseup', @stopResizeHandler

  events:
    "click"                     : "selectHandler"
    "mousedown .control-border" : "startMoveHandler"
    "mousedown .resize-handle"  : "startResizeHandler"

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

  slideIn: ->
    $(@el).css("margin-left", $(document).width() + "px")
    $(@el).animate({marginLeft: 0}, 400)

  slideOut: ->
    $(@el).animate({marginLeft: $(document).width() + "px"}, 400)

  events:
    "click .cancel" : "textEditCancelHandler"
    "click .save"   : "textEditSaveHandler"

module.exports = ControlLayer
