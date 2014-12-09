$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
Element = require './element.coffee'

class Editor extends Backbone.Model
  defaults:
    selection: null
    translate: {x: 0, y: 0}
    scale: {w: 1, h: 1}
    anchor: null

  initialize: ->
    @set 'selection', new Backbone.Collection [], {model: Element}

  selectElement: (element) ->
    elements = @get 'selection'
    if not elements.contains element
      elements.add element

  selectElements: (elements) ->
    selected = @get 'selection'
    adding = []
    for element in elements
      if not selected.contains element
        adding.push element
    if adding.length > 0
      selected.add adding

  toggleSelectElements: (elements, toggled) ->
    selected = @get 'selection'
    adding = []
    removing = []
    keepToggled = []
    if not toggled?
      toggled = []
    for element in elements
      if _.contains toggled, element
        keepToggled.push element
      else
        if selected.contains element
          removing.push element
        else
          adding.push element

    for element in toggled
      if not _.contains keepToggled, element
        if selected.contains element
          removing.push element
        else
          adding.push element

    if adding.length > 0
      selected.add adding
    if removing.length > 0
      selected.remove removing

    elements

  deselectElement: (element) ->
    elements = @get 'selection'
    if elements.contains element
      elements.remove element

  selectOnlyElement: (element) ->
    @unselectAll()
    @selectElement element

  selectOnlyElements: (elements) ->
    selected = @get 'selection'

    adding = []
    for element in elements
      if not selected.contains element
        adding.push element
    if adding.length > 0
      selected.add adding

    removing = []
    selected.each (element) ->
      if not _.contains elements, element
        removing.push element
    if removing.length > 0
      selected.remove removing

  unselectAll: ->
    elements = @get 'selection'
    elements.reset()

  isSelected: (element) ->
    return @get('selection').contains element

  isSelectedID: (id) ->
    element = @get('selection').findWhere {id: id}
    if element?
      return true
    else
      return false

  setTranslation: (dx, dy) ->
    @translate = {x: dx, y: dy}
    for model in @get('selection').models
      model.trigger 'change'

  setScale: (dw, dh, anchor) ->
    @scale = {w: dw, h: dh}
    @anchor = anchor
    for model in @get('selection').models
      model.trigger 'change'

  resetMods: ->
    @translate = {x: 0, y: 0}
    @scale = {w: 1, h: 1}

  applyMods: ->
    translate = @translate
    scale = @scale
    @resetMods()
    if scale.w != 1 or scale.h != 1
      @scaleSelectedBy scale.w, scale.h, @anchor
    if translate.x != 0 or translate.y != 0
      @moveSelectedBy translate.x, translate.y

  moveSelectedBy: (dx, dy) ->
    selected = @get 'selection'
    selected.each (element) ->
      element.moveBy dx, dy

  scaleSelectedBy: (dw, dh, anchor) ->
    selected = @get 'selection'
    selected.each (element) ->
      where = {}
      if anchor.x?
        if element.has 'x'
          where.x = (element.get('x') - anchor.x) * dw + anchor.x
      else
        where.x = element.get('x')
      if anchor.y?
        if element.has 'y'
          where.y = (element.get('y') - anchor.y) * dh + anchor.y
      else
        where.y = element.get('y')
      where.x = 0 if not where.x?
      where.y = 0 if not where.y?

      element.moveAndScaleBy where.x, where.y, dw, dh

  getSelectedGeos: ->
    geos = []
    selected = @get 'selection'
    for element in selected.models
      for geo in element.getGeos()
        geos.push geo
    return geos

  modifyViewAttributes: (element, viewAttributes) ->
    if @isSelected element
      if viewAttributes.x?
        if @scale.w != 1
          viewAttributes.x = (viewAttributes.x - @anchor.x) * @scale.w + @anchor.x
        viewAttributes.x = viewAttributes.x + @translate.x
      if viewAttributes.y?
        if @scale.h != 1
          viewAttributes.y = (viewAttributes.y - @anchor.y) * @scale.h + @anchor.y
        viewAttributes.y = viewAttributes.y + @translate.y
      if viewAttributes.w?
        if @scale.w != 1
          viewAttributes.w = viewAttributes.w * @scale.w
      if viewAttributes.h?
        if @scale.h != 1
          viewAttributes.h = viewAttributes.h * @scale.h

module.exports = Editor
