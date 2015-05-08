$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
Element = require './element.coffee'
Group = require './group.coffee'

class Editor extends Backbone.Model
  defaults:
    selection: null
    translate: {x: 0, y: 0}
    scale: {w: 1, h: 1}
    anchor: null
    context: null # usually the page

  initialize: ->
    @set 'selection', new Backbone.Collection [], {model: Element}

  isElementWithin: (needle, haystack) ->
    if haystack.has 'elements'
      if haystack.get('elements').contains needle
        return true
      for element in haystack.get('elements').models
        if @isElementWithin needle, element
          return true

    return false

  selectableElement: (element) ->
    if @has 'context'
      elements = @get('context').get 'elements'
      if elements.contains element
        return element
      for searchElement in elements.models
        if @isElementWithin element, searchElement
          return searchElement
    return element

  selectElement: (element) ->
    element = @selectableElement element
    elements = @get 'selection'
    if not elements.contains element
      elements.add element

  selectElements: (elements) ->
    selected = @get 'selection'
    adding = []
    for element in elements
      element = @selectableElement element
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
      element = @selectableElement element
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
      element = @selectableElement element
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
    elements.trigger "remove"

  isSelected: (element) ->
    if element.has 'parent'
      if @isSelected element.get('parent')
        return true
    return @get('selection').contains element

  isSelectedID: (id) ->
    element = @get('selection').findWhere {id: id}
    if element?
      return true
    else
      return false

  selectedData: ->
    data = []
    for element in @get("selection").models
      data.push element.copyObject()
    return data

  setTranslation: (dx, dy) ->
    @set 'translate', {x: dx, y: dy}
    for model in @get('selection').models
      model.trigger 'modifying', model

  setScale: (dw, dh, anchor) ->
    @set 'scale', {w: dw, h: dh}
    @set 'anchor', anchor
    for model in @get('selection').models
      model.trigger 'modifying', model

  resetMods: ->
    @set 'translate', {x: 0, y: 0}
    @set 'scale', {w: 1, h: 1}

  applyMods: ->
    translate = @get 'translate'
    scale = @get 'scale'
    @resetMods()
    if scale.w != 1 or scale.h != 1
      @scaleSelectedBy scale.w, scale.h, @get 'anchor'
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

  selectionTopBoundary: ->
    return null if @get('selection').size() <= 0
    topElement = @get('selection').min (element) ->
      if element.has 'y'
        return element.get 'y'
      else
        return null
    if topElement?
      if topElement.has 'y'
        return topElement.get 'y'
    return null

  alignSelectedTop: ->
    top = @selectionTopBoundary()
    if top?
      for element in @get('selection').models
        element.set {y: top}

  selectionRightBoundary: ->
    return null if @get('selection').size() <= 0
    rightElement = @get('selection').max (element) ->
      if element.has 'x'
        if element.has 'w'
          return element.get('x') + element.get('w')
      return null
    if rightElement?
      if rightElement.has 'x'
        if rightElement.has 'w'
          return rightElement.get('x') + rightElement.get('w')
    return null

  alignSelectedRight: ->
    right = @selectionRightBoundary()
    if right?
      for element in @get('selection').models
        if element.has 'w'
          element.set {x: right - element.get('w')}

  selectionBottomBoundary: ->
    return null if @get('selection').size() <= 0
    bottomElement = @get('selection').max (element) ->
      if element.has 'y'
        if element.has 'h'
          return element.get('y') + element.get('h')
      return null
    if bottomElement?
      if bottomElement.has 'y'
        if bottomElement.has 'h'
          return bottomElement.get('y') + bottomElement.get('h')
    return null

  alignSelectedBottom: ->
    bottom = @selectionBottomBoundary()
    if bottom?
      for element in @get('selection').models
        if element.has 'h'
          element.set {y: bottom - element.get('h')}

  selectionLeftBoundary: ->
    return null if @get('selection').size() <= 0
    leftElement = @get('selection').min (element) ->
      if element.has 'x'
        return element.get 'x'
      else
        return null
    if leftElement?
      if leftElement.has 'x'
        return leftElement.get 'x'
    return null

  alignSelectedLeft: ->
    left = @selectionLeftBoundary()
    if left?
      for element in @get('selection').models
        element.set {x: left}

  alignSelectedCenter: ->
    right = @selectionRightBoundary()
    left = @selectionLeftBoundary()
    if left? and right?
      for element in @get('selection').models
        if element.has 'w'
          element.set {x: (left + right)/2 - element.get('w')/2}

  alignSelectedMiddle: ->
    bottom = @selectionBottomBoundary()
    top = @selectionTopBoundary()
    if top? and bottom?
      for element in @get('selection').models
        if element.has 'h'
          element.set {y: (top + bottom)/2 - element.get('h')/2}

  distribute: (fn) ->
    getFn = (element) -> element[fn]()
    order = @get('selection').sortBy getFn
    return null if order.length < 3

    place = _.min(order, getFn)[fn]()
    total = _.max(order, getFn)[fn]() - place
    step = total/(order.length - 1)

    for element in order
      element[fn](place)
      place = place + step

  distributeSelectedTop: ->
    return @distribute('top')
  distributeSelectedRight: ->
    return @distribute('right')
  distributeSelectedBottom: ->
    return @distribute('bottom')
  distributeSelectedLeft: ->
    return @distribute('left')
  distributeSelectedCenter: ->
    return @distribute('center')
  distributeSelectedMiddle: ->
    return @distribute('middle')

  getSelectedGeos: ->
    geos = []
    selected = @get 'selection'
    for element in selected.models
      for geo in element.getGeos()
        geos.push geo
    return geos

  groupSelected: ->
    group = new Group()
    index = -1
    for element in @get('selection').models
      group.addElement element
      if @has 'context'
        options = {}
        @get('context').get('elements').remove element, options
        if options.index?
          index = options.index
    if index >= 0
      @get('context').get('elements').add group, {at: index}
    @selectOnlyElement group

  ungroupSelected: ->
    for element in @get('selection').models
      if element.has 'elements'
        newSelected = []
        for subElement in element.get('elements').models
          @get('context').addElement subElement
          newSelected.push subElement
          updates = {}
          if subElement.has 'x'
            updates.x = subElement.get 'x'
            if element.has 'w'
              updates.x *= element.get 'w'
            if element.has 'x'
              updates.x += element.get 'x'
          if subElement.has 'y'
            updates.y = subElement.get 'y'
            if element.has 'h'
              updates.y *= element.get 'h'
            if element.has 'y'
              updates.y += element.get 'y'
          if subElement.has('w') and element.has('w')
            updates.w = subElement.get('w') * element.get('w')
          if subElement.has('h') and element.has('h')
            updates.h = subElement.get('h') * element.get('h')
          subElement.set updates
        @get('context').removeElement element
        @deselectElement element
        @selectElements newSelected

  componentizeSelected: ->
    instance = null
    for element in @get('selection').models
      instance = new Element({master: element})
      @get('context').addElement instance
      instance.set 'x', element.get('x')
      instance.set 'y', element.get('y')

    return instance

  modifyViewAttributes: (element, viewAttributes) ->
    if @isSelected element
      scale = @get 'scale'
      translate = @get 'translate'
      anchor = @get 'anchor'
      if viewAttributes.x?
        if scale.w != 1
          viewAttributes.x = (viewAttributes.x - anchor.x) * scale.w + anchor.x
        viewAttributes.x = viewAttributes.x + translate.x
      if viewAttributes.y?
        if scale.h != 1
          viewAttributes.y = (viewAttributes.y - anchor.y) * scale.h + anchor.y
        viewAttributes.y = viewAttributes.y + translate.y
      if scale.w != 1
        if not viewAttributes.w?
          if viewAttributes.naturalW?
            viewAttributes.w = viewAttributes.naturalW
          else
            viewAttributes.w = 1
        viewAttributes.w = viewAttributes.w * scale.w
      if scale.h != 1
        if not viewAttributes.h?
          if viewAttributes.naturalH?
            viewAttributes.h = viewAttributes.naturalH
          else
            viewAttributes.h = 1
        viewAttributes.h = viewAttributes.h * scale.h

module.exports = Editor
