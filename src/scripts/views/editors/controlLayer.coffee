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
  transformBox: null

  initialize: ->
    _.bindAll @, 'startDragHandler', 'moveDragHandler', 'stopDragHandler', 'selectionChange'
    @editor = new Editor()
    @editor.on "change:selection", @selectionChange
    @editor.get('selection').on "add remove", @selectionChange
    @selectingFrameEl = $(uiTemplates.selectingFrame())
    $(@selectingFrameEl).hide()
    $(@el).append @selectingFrameEl
    @transformBox = new TransformBox {collection:@editor.get('selection')}
    super()

  render: ->
    super()
    $(@selectingFrameEl).hide()
    $(@el).append @transformBox.el
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

  stopDragHandler: (e) ->
    @moveDragHandler(e)
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

  selectAll: ->
    elements = @model.get 'elements'
    @editor.selectElements(elements.models)

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
    "mousedown" : "startDragHandler"


class ControlBox extends BaseView
  template: uiTemplates.controlBox
  selected: false
  editor: null

  initialize: (options) ->
    _.bindAll @, 'render', 'selectHandler', 'checkSelected', 'startMoveHandler',
      'moveHandler', 'stopMoveHandler'
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
        viewAttributes.w = elel.outerWidth()
        viewAttributes.h = elel.outerHeight()
        # viewAttributes.w = elel.width() + parseInt(elel.css("border-left-width")) + parseInt(elel.css("border-right-width"))
        # viewAttributes.h = elel.height() + parseInt(elel.css("border-top-width")) + parseInt(elel.css("border-bottom-width"))
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
    e.stopPropagation()
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
    e.stopPropagation()
    if not @editor.isSelected @model
      @editor.selectOnlyElement @model
    dx =  e.clientX - @grab.x - @model.get 'x'
    dy =  e.clientY - @grab.y - @model.get 'y'
    @editor.moveSelectedBy dx, dy
    # @model.set({'x': x, 'y': y})

  stopMoveHandler: (e) ->
    e.stopPropagation()
    $(document).off 'mousemove', @moveHandler
    $(document).off 'mouseup', @stopMoveHandler

  events:
    "click"                     : "selectHandler"
    "mousedown .control-border" : "startMoveHandler"

class TransformBox extends BaseView
  template: uiTemplates.transformBox
  editor: null
  box: {}

  initialize: (options) ->
    _.bindAll @, 'render', 'startResizeHandler', 'resizeHandler', 'stopResizeHandler',
      'changeSelection'
    if 'editor' of options
      @editor = options.editor
      @editor.get('selection').on "add remove reset", @checkSelected if @editor?
    if @collection?
      @setCollection @collection

  modelBoundaries: ->
    modelBoundaries = {}
    if @collection?
      for model in @collection.models
        if model.has 'x'
          modelBoundaries.left = model.get('x') if not modelBoundaries.left?
          modelBoundaries.left = _.min [model.get('x'), modelBoundaries.left]
          if model.has 'w'
            modelBoundaries.right = model.get('x') + model.get('w') if not modelBoundaries.right?
            modelBoundaries.right = _.max [model.get('x') + model.get('w'), modelBoundaries.right]
        if model.has 'y'
          modelBoundaries.top = model.get('y') if not modelBoundaries.top?
          modelBoundaries.top = _.min [model.get('y'), modelBoundaries.top]
          if model.has 'h'
            modelBoundaries.bottom = model.get('y') + model.get('h') if not modelBoundaries.bottom?
            modelBoundaries.bottom = _.max [model.get('y') + model.get('h'), modelBoundaries.bottom]
    return modelBoundaries

  visibleBoundaries: ->
    boundaries = {}
    if @collection?
      for model in @collection.models
        visible = true
        el_id = model.get('id')
        elel = $(".framer-page [data-element=#{el_id}]")
        if elel.length > 0

          boundaries.left = elel.position().left if not boundaries.left?
          boundaries.top = elel.position().top if not boundaries.top?
          boundaries.right = elel.width() + elel.position().left if not boundaries.right?
          boundaries.bottom = elel.height() + elel.position().top if not boundaries.bottom?

          boundaries.left = _.min([elel.position().left, boundaries.left])
          boundaries.top = _.min([elel.position().top, boundaries.top])
          boundaries.right = _.max([elel.width() + elel.position().left, boundaries.right])
          boundaries.bottom = _.max([elel.height() + elel.position().top, boundaries.bottom])
    return boundaries

  render: ->
    oldEl = @el
    visible = false
    viewAttributes =
      x: 0
      y: 0
      w: 0
      h: 0
    if @collection?
      @box = @visibleBoundaries()
      if @box.left?
        visible = true
        viewAttributes =
          x: @box.left
          y: @box.top
          w: @box.right - @box.left
          h: @box.bottom - @box.top
    @setElement $(@template(viewAttributes))
    if visible
      $(@el).show()
    else
      $(@el).hide()
    $(oldEl).replaceWith $(@el)

  makeStartState: ->
    @startState = {}
    @startState.box = @visibleBoundaries()
    @startState.corner = {}
    @startState.elements = {}
    if @collection?
      for model in @collection.models
        data = {id: model.get 'id'}
        data.x = model.get 'x' if model.has 'x'
        data.y = model.get 'y' if model.has 'y'
        data.w = model.get 'w' if model.has 'w'
        data.h = model.get 'h' if model.has 'h'
        @startState.elements[model.get('id')] = data

        if data.x?
          if !@startState.corner.x?
            @startState.corner.x = data.x
          else
            if data.x < @startState.corner.x
              @startState.corner.x = data.x
        if data.y?
          if !@startState.corner.y?
            @startState.corner.y = data.y
          else
            if data.y < @startState.corner.y
              @startState.corner.y = data.y

  changeSelection: ->
    @render()

  setCollection: (collection) ->
    @collection = collection
    @collection.on 'add remove change', @changeSelection
    @render()

  startResizeHandler: (e) ->
    e.stopPropagation()
    @makeStartState()
    @grab = {x: e.clientX, y: e.clientY}
    @resizeEdge = $(e.target).data 'edge'
    if @resizeEdge in ['tl', 't', 'tr']
      @grab.y =  @box.top - @grab.y
    if @resizeEdge in ['tr', 'r', 'br']
      @grab.x = @box.right - @grab.x
    if @resizeEdge in ['bl', 'b', 'br']
      @grab.y =  @box.bottom - @grab.y
    if @resizeEdge in ['tl', 'l', 'bl']
      @grab.x =  @box.left - @grab.x
    $(document).on 'mousemove', @resizeHandler
    $(document).on 'mouseup', @stopResizeHandler

  resizeHandler: (e) ->
    e.stopPropagation()
    modified = _.clone @startState.box
    if @resizeEdge in ['tl', 't', 'tr']
      modified.top = e.clientY + @grab.y
      if modified.top > modified.bottom
        @grab.y = @grab.y - (modified.top - modified.bottom)
        modified.top = modified.bottom
        @resizeEdge = 'bl' if @resizeEdge == 'tl'
        @resizeEdge = 'b' if @resizeEdge == 't'
        @resizeEdge = 'br' if @resizeEdge == 'tr'
    if @resizeEdge in ['tr', 'r', 'br']
      modified.right = e.clientX + @grab.x
      if modified.left > modified.right
        @grab.x = @grab.x + (modified.left - modified.right)
        modified.right = modified.left
        @resizeEdge = 'tl' if @resizeEdge == 'tr'
        @resizeEdge = 'l' if @resizeEdge == 'r'
        @resizeEdge = 'bl' if @resizeEdge == 'br'
    if @resizeEdge in ['bl', 'b', 'br']
      modified.bottom = e.clientY + @grab.y
      if modified.top > modified.bottom
        @grab.y = @grab.y + (modified.top - modified.bottom)
        modified.top = modified.bottom
        @resizeEdge = 'tl' if @resizeEdge == 'bl'
        @resizeEdge = 't' if @resizeEdge == 'b'
        @resizeEdge = 'tr' if @resizeEdge == 'br'
    if @resizeEdge in ['tl', 'l', 'bl']
      modified.left = e.clientX + @grab.x
      if modified.left > modified.right
        @grab.x = @grab.x - (modified.left - modified.right)
        modified.left = modified.right
        @resizeEdge = 'tr' if @resizeEdge == 'tl'
        @resizeEdge = 'r' if @resizeEdge == 'l'
        @resizeEdge = 'br' if @resizeEdge == 'bl'

    scaleX = (modified.right - modified.left) / (@startState.box.right - @startState.box.left)
    scaleY = (modified.bottom - modified.top) / (@startState.box.bottom - @startState.box.top)

    newPosition =
      x: @startState.corner.x + modified.left - @startState.box.left
      y: @startState.corner.y + modified.top - @startState.box.top
    for model in @collection.models
      mine = @startState.elements[model.get 'id']
      if mine?
        change =
          x: ((mine.x - @startState.corner.x) * scaleX) + newPosition.x
          y: ((mine.y - @startState.corner.y) * scaleY) + newPosition.y
          w: mine.w * scaleX
          h: mine.h * scaleY
        model.set change

  stopResizeHandler: (e) ->
    e.stopPropagation()
    $(document).off 'mousemove', @resizeHandler
    $(document).off 'mouseup', @stopResizeHandler

  events:
    "mousedown .resize-handle"  : "startResizeHandler"

class PropertyPanel extends BaseView
  template: uiTemplates.propertyPanel

  initialize: ->
    _.bindAll @, 'render', 'textEditCancelHandler', 'textEditSaveHandler', 'remove',
      'startDragHandler', 'dragHandler', 'stopDragHandler'
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
            else if property.type == 'boolean'
              prop_el = $ '<input type="checkbox" value="true" />'
            else
              prop_el = $ "<input type=\"text\" />"
            prop_el.attr "data-element", @model.get('id')
            prop_el.attr "data-property", property.property
            prop_el.attr "placeholder", property.property
            if property.type == "boolean"
              if @model.get property.property
                prop_el.attr "checked", "checked"
            else
              prop_el.val @model.get(property.property)
            $(@el).find('.framer-fields').append prop_el

      $(oldEl).replaceWith $(@el)

  textEditCancelHandler: ->
    @slideOut()

  textEditSaveHandler: ->
    updates = {}
    fields = $(@el).find(".framer-fields > *")
    for field in fields
      if $(field).is("[type=checkbox]")
        if $(field).is(":checked")
          updates[$(field).data("property")] = true
        else
          updates[$(field).data("property")] = false
      else
        updates[$(field).data("property")] = $(field).val()
    @model.set updates

  slideIn: ->
    $(@el).css("margin-left", $(document).width() + "px")
    $(@el).animate({marginLeft: 0}, 400)

  slideOut: ->
    $(@el).removeClass "showing"
    $(@el).animate({marginLeft: $(document).width() + "px"}, 400, @remove)

  startDragHandler: (e) ->
    e.stopPropagation()
    $(document).on 'mousemove', @dragHandler
    $(document).on 'mouseup', @stopDragHandler
    @grab = {x: e.clientX - $(@el).position().left, y: e.clientY - $(@el).position().top}

  dragHandler: (e) ->
    e.stopPropagation()
    x =  e.clientX - @grab.x
    y =  e.clientY - @grab.y
    $(@el).css "left", x
    $(@el).css "top", y

  stopDragHandler: (e) ->
    e.stopPropagation()
    $(document).off 'mousemove', @dragHandler
    $(document).off 'mouseup', @stopDragHandler

  events:
    "click .cancel" : "textEditCancelHandler"
    "click .save"   : "textEditSaveHandler"
    "mousedown"     : "startDragHandler"

module.exports = ControlLayer
