$ = require 'jquery'
Backbone = require 'backbone'
BaseView = require './../baseView.coffee'
PageView = require './../page.coffee'
uiTemplates = require './../../uiTemplates.coffee'
_ = require 'underscore'
Editor = require './../../models/editor.coffee'
components = require './../../../components/components.json'
Element = require './../../models/element.coffee'
plugins = require './../../plugins.coffee'
PropertyPanel = require './propertyPanel.coffee'
Snapper = require './../helpers/snapper.coffee'

elBoundaries = (el) ->
  thisBox =
    "left":   parseInt(el.css("margin-left")) + el.position().left
    "top":    parseInt(el.css("margin-top")) + el.position().top
    "right":  el.position().left + el.outerWidth() + parseInt(el.css("margin-right"))
    "bottom": el.position().top + el.outerHeight() + parseInt(el.css("margin-bottom"))
  return thisBox

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
  snapper: null

  initialize: (options) ->
    _.bindAll @, 'startDragHandler', 'moveDragHandler', 'stopDragHandler', 'selectionChange',
      'updateSnapping'
    if options.editor?
      @editor = options.editor
    else
      @editor = new Editor()
    @editor.on "change:selection", @selectionChange
    @editor.get('selection').on "add remove", @selectionChange
    @selectingFrameEl = $(uiTemplates.selectingFrame())
    $(@selectingFrameEl).hide()
    $(@el).append @selectingFrameEl
    @transformBox = new TransformBox {collection:@editor.get('selection'), editor: @editor}
    @snapper = new Snapper()
    @transformBox.snapper = @snapper
    super()

  render: ->
    super()
    $(@selectingFrameEl).hide()
    $(@transformBox.el).hide()
    $(@el).append @transformBox.el
    $(@el).append @selectingFrameEl

  newElementView: (model) ->
    controlBox = new ControlBox {model: model, editor: @editor}
    controlBox.snapper = @snapper
    return controlBox

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
    e.preventDefault()
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
      if @propertyPanel?
        overlap = 0
        if selected.size() == @propertyPanel.collection.size()
          overlap = _.intersection(selected.models, @propertyPanel.collection.models).length
        if overlap <= 0 or overlap < selected.length
          @propertyPanel.slideOut()
          @propertyPanel = null
      if not @propertyPanel?
        collection = new Backbone.Collection [], {model: Element}
        collection.add selected.models
        @propertyPanel = new PropertyPanel {collection: collection, editor: @editor}
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

  updateSnapping: ->
    if @appData?
      @snapper.active = @appData.settings.get('snapping')

  setAppData: (appData) ->
    @appData = appData
    @updateSnapping()
    @appData.settings.on 'change:snapping', @updateSnapping
    @snapper.addGuide appData.grid

  events:
    "mousedown" : "startDragHandler"


class ControlBox extends BaseView
  template: uiTemplates.controlBox
  selected: false
  editor: null
  snapper: null

  initialize: (options) ->
    _.bindAll @, 'render', 'selectHandler', 'checkSelected', 'startMoveHandler',
      'moveHandler', 'stopMoveHandler'
    @model.on "change", @render
    if 'editor' of options
      @editor = options.editor
      @editor.get('selection').on "add remove reset", @checkSelected if @editor?

  render: ->
    if @model?
      oldEl = @el
      viewAttributes = _.clone @model.attributes
      el_id = @model.get('id')
      # console.log "id: #{el_id}"
      elel = $(".framer-page [data-element=#{el_id}]")
      # console.log elel.length
      if elel.length > 0
        thisBox = elBoundaries elel
        viewAttributes.x = thisBox.left
        viewAttributes.y = thisBox.top
        viewAttributes.w = thisBox.right - thisBox.left
        viewAttributes.h = thisBox.bottom - thisBox.top
      # console.log viewAttributes
      @setElement $(@template(_.extend(viewAttributes, {selected: @selected})))
      # console.log @el
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
    e.preventDefault()
    @editor.resetMods()
    @giveModelPosition()
    @grab = {x: e.screenX, y: e.screenY}

    $(document).on 'mousemove', @moveHandler
    $(document).on 'mouseup', @stopMoveHandler

  moveHandler: (e) ->
    e.stopPropagation()
    dx =  e.screenX - @grab.x
    dy =  e.screenY - @grab.y

    if not @editor.isSelected @model
      @editor.selectOnlyElement @model

    # let's do some snapping
    geos = @editor.getSelectedGeos()
    @snapper.moveGeos geos, dx, dy
    snapped = @snapper.getSnap geos

    @editor.setTranslation dx + snapped.x, dy + snapped.y

  stopMoveHandler: (e) ->
    e.stopPropagation()
    @editor.applyMods()
    $(document).off 'mousemove', @moveHandler
    $(document).off 'mouseup', @stopMoveHandler

  events:
    "click"                     : "selectHandler"
    "mousedown .control-border" : "startMoveHandler"

class TransformBox extends BaseView
  template: uiTemplates.transformBox
  editor: null
  box: {}
  snapper: null

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
          thisBox = elBoundaries elel

          boundaries.left = thisBox.left if not boundaries.left?
          boundaries.top = thisBox.top if not boundaries.top?
          boundaries.right = thisBox.right if not boundaries.right?
          boundaries.bottom = thisBox.bottom if not boundaries.bottom?

          boundaries.left = _.min([thisBox.left, boundaries.left])
          boundaries.top = _.min([thisBox.top, boundaries.top])
          boundaries.right = _.max([thisBox.right, boundaries.right])
          boundaries.bottom = _.max([thisBox.bottom, boundaries.bottom])
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
          w: @box.right - @box.left - 2
          h: @box.bottom - @box.top - 2
    @setElement $(@template(viewAttributes))
    if visible
      $(@el).show()
    else
      $(@el).hide()
    $(oldEl).replaceWith $(@el)

  changeSelection: ->
    @render()

  setCollection: (collection) ->
    @collection = collection
    @collection.on 'add remove change', @changeSelection
    @render()

  startResizeHandler: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @grab = {x: e.screenX, y: e.screenY}
    @offset = _.clone @grab
    @anchor = {}
    @resizeEdge = $(e.target).data 'edge'
    if @resizeEdge in ['tl', 't', 'tr']
      @offset.y =  @box.top - @grab.y
      @anchor.y = @box.bottom
    if @resizeEdge in ['tr', 'r', 'br']
      @offset.x = @box.right - @grab.x
      @anchor.x = @box.left
    if @resizeEdge in ['bl', 'b', 'br']
      @offset.y =  @box.bottom - @grab.y
      @anchor.y = @box.top
    if @resizeEdge in ['tl', 'l', 'bl']
      @offset.x =  @box.left - @grab.x
      @anchor.x = @box.right
    $(document).on 'mousemove', @resizeHandler
    $(document).on 'mouseup', @stopResizeHandler

  resizeHandler: (e) ->
    e.stopPropagation()
    x = e.screenX + @offset.x
    y = e.screenY + @offset.y

    # let's do some snapping
    geos = [{x:x, y:y}]
    snapped = @snapper.getSnap geos
    x = x + snapped.x
    y = y + snapped.y

    if @anchor.x?
      w = (x - @anchor.x)/(@grab.x + @offset.x - @anchor.x)
    else
      w = 1
    if @anchor.y?
      h = (y - @anchor.y)/(@grab.y + @offset.y - @anchor.y)
    else
      h = 1

    @editor.setScale w, h, @anchor

  stopResizeHandler: (e) ->
    e.stopPropagation()
    @editor.applyMods()
    $(document).off 'mousemove', @resizeHandler
    $(document).off 'mouseup', @stopResizeHandler

  events:
    "mousedown .resize-handle"  : "startResizeHandler"

module.exports = ControlLayer
