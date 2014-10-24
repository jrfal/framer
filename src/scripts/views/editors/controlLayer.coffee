$ = require 'jquery'
Backbone = require 'backbone'
BaseView = require './../baseView.coffee'
PageView = require './../page.coffee'
uiTemplates = require './../../uiTemplates.coffee'
_ = require 'underscore'
Editor = require './../../models/editor.coffee'
components = require './../../../components/components.json'

class ControlLayer extends PageView
  className: 'framer-control-layer'
  editor: null
  selectingFrame: null
  selectingFrameEl: null
  shiftKey: false
  cmdKey: false
  toggling: null
  propertyPanel: null

  initialize: ->
    _.bindAll @, 'startDragHandler', 'moveDragHandler', 'stopDragHandler', 'selectionChange'
    @editor = new Editor()
    @editor.on "change:selection", @selectionChange
    @editor.get('selection').on "add remove", @selectionChange
    @selectingFrameEl = $(uiTemplates.selectingFrame())
    $(@selectingFrameEl).hide()
    $(@el).append @selectingFrameEl
    super()

  render: ->
    super()
    $(@selectingFrameEl).hide()
    $(@el).append @selectingFrameEl

  newElementView: (model) ->
    return new ControlBox {model: model, editor: @editor}

  usableFrame: (frame) ->
    frame = {x: frame.x, y: frame.y, w: frame.w, h: frame.h}
    if frame.w < 0
      frame.x = frame.x + frame.w
      frame.w = frame.w * -1
    if frame.h < 0
      frame.y = frame.y + frame.h
      frame.h = frame.h * -1
    return frame

  updateSelectingFrame: (frame) ->
    frame = @usableFrame frame
    $(@selectingFrameEl).css 'left', frame.x+'px'
    $(@selectingFrameEl).css 'top', frame.y+'px'
    $(@selectingFrameEl).css 'width', frame.w+'px'
    $(@selectingFrameEl).css 'height', frame.h+'px'
    $(@selectingFrameEl).show()

  hideSelectingFrame: ->
    $(@selectingFrameEl).hide()

  startDragHandler: (e) ->
    @shiftKey = e.shiftKey
    @metaKey = e.metaKey
    @selectingFrame = {x: e.clientX, y: e.clientY, w: 0, h: 0}
    @toggling = []
    $(document).on 'mousemove', @moveDragHandler
    $(document).on 'mouseup', @stopDragHandler

  moveDragHandler: (e) ->
    @selectingFrame.w = e.clientX - @selectingFrame.x
    @selectingFrame.h = e.clientY - @selectingFrame.y
    @updateSelectingFrame @selectingFrame

    if @shiftKey or @metaKey
      @toggling = @editor.toggleSelectElements @elementsInFrame(@selectingFrame), @toggling
    else
      @editor.selectOnlyElements @elementsInFrame(@selectingFrame)

  stopDragHandler: ->
    $(document).off 'mousemove', @moveDragHandler
    $(document).off 'mouseup', @stopDragHandler
    @hideSelectingFrame()

  selectionChange: ->
    selected = @editor.get 'selection'
    if selected.length > 0
      element = selected.first()
      if @propertyPanel?
        if element != @propertyPanel.model
          @propertyPanel.slideOut()
          @propertyPanel = null
      if not @propertyPanel?
        @propertyPanel = new PropertyPanel {model: element}
        $("#framer_controls").append @propertyPanel.el
        @propertyPanel.slideIn()
    else if @propertyPanel?
      @propertyPanel.slideOut()
      @propertyPanel = null


  elementsInFrame: (frame) ->
    frame = @usableFrame frame

    inFrame = (rect) ->
      if rect.x > frame.x + frame.w
        return false
      if rect.y > frame.y + frame.h
        return false
      if frame.x > rect.x + rect.w
        return false
      if frame.y > rect.y + rect.h
        return false

      return true

    elements = []
    for elementView in @elementViews
      el_id = elementView.model.get('id')
      elel = $(".framer-page [data-element=#{el_id}]")
      position = elel.position()
      if inFrame {x: position.left, y: position.top, w: elel.width(), h: elel.height()}
        elements.push elementView.model

    return elements

  events:
    # "click"                     : "deselectHandler"
    "mousedown" : "startDragHandler"


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
      el_id = @model.get('id')
      elel = $(".framer-page [data-element=#{el_id}]")
      if elel.length > 0
        viewAttributes.x = elel.position().left
        viewAttributes.y = elel.position().top
        viewAttributes.w = elel.width()
        viewAttributes.h = elel.height()
      @setElement $(@template(_.extend(viewAttributes, {selected: @selected})))
      $(oldEl).replaceWith $(@el)

  select: ->
    @selected = true
    @editor.selectElement @model if @editor?
    @render()

  deselect: ->
    @selected = false
    @editor.deselectElement @model if @editor?
    @render()

  selectHandler: (e) ->
    if e.shiftKey or e.metaKey
      if @editor.isSelected @model
        @editor.deselectElement @model
      else
        @editor.selectElement @model
    else
      @editor.selectOnlyElement @model

  checkSelected: ->
    if @editor.isSelected @model
      if not @selected
        @select()
    else
      if @selected
        @deselect()

  giveModelPosition: ->
    if not @model.has 'x' or not @model has 'y'
      el_id = @model.get('id')
      elel = $(".framer-page [data-element=#{el_id}]")
      position = {}
      if not @model.has 'x'
        position.x = elel.position().left
      if not @model.has 'y'
        position.y = elel.position().top
      @model.set position

  startMoveHandler: (e) ->
    e.stopPropagation()
    @giveModelPosition()
    @grab = {x: e.clientX - @model.get('x'), y: e.clientY - @model.get('y')}
    $(document).on 'mousemove', @moveHandler
    $(document).on 'mouseup', @stopMoveHandler

  moveHandler: (e) ->
    if not @editor.isSelected @model
      @editor.selectOnlyElement @model
    dx =  e.clientX - @grab.x - @model.get 'x'
    dy =  e.clientY - @grab.y - @model.get 'y'
    @editor.moveSelectedBy dx, dy
    # @model.set({'x': x, 'y': y})

  stopMoveHandler: (e) ->
    $(document).off 'mousemove', @moveHandler
    $(document).off 'mouseup', @stopMoveHandler

  startResizeHandler: (e) ->
    e.stopPropagation()
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
    _.bindAll @, 'render', 'textEditCancelHandler', 'textEditSaveHandler', 'remove'
    @render()

  render: ->
    if @model?
      oldEl = @el
      propsFromComponent = (component) ->
        properties = []
        if component.properties?
          for property in component.properties
            if property.inherit?
              inherit = _.findWhere components, {component: property.inherit}
              if inherit?
                properties = _.union properties, propsFromComponent(inherit)
            else
              properties.push property
        return properties

      @setElement $(@template(@model.attributes))

      if @model.get('component')?
        component = _.findWhere components, {component: @model.get('component')}
        if component?
          for property in propsFromComponent(component)
            if property.type == 'paragraph'
              prop_el = $ "<textarea></textarea>"
            else
              prop_el = $ "<input type=\"text\" />"
            prop_el.attr "data-element", @model.get('id')
            prop_el.attr "data-property", property.property
            prop_el.attr "placeholder", property.property
            prop_el.val @model.get(property.property)
            $(@el).find('.framer-fields').append prop_el

      $(oldEl).replaceWith $(@el)

  textEditCancelHandler: ->
    @slideOut()

  textEditSaveHandler: ->
    updates = {}
    fields = $(@el).find(".framer-fields > *")
    for field in fields
      updates[$(field).data("property")] = $(field).val()
    @model.set updates

  slideIn: ->
    $(@el).css("margin-left", $(document).width() + "px")
    $(@el).animate({marginLeft: 0}, 400)

  slideOut: ->
    $(@el).removeClass "showing"
    $(@el).animate({marginLeft: $(document).width() + "px"}, 400, @remove)

  events:
    "click .cancel" : "textEditCancelHandler"
    "click .save"   : "textEditSaveHandler"

module.exports = ControlLayer
