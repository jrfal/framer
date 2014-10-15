$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
Page = require './page.coffee'
Element = require './element.coffee'

class Editor extends Backbone.Model
  defaults:
    selection: null
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

  moveSelectedBy: (dx, dy) ->
    selected = @get 'selection'
    selected.each (element) ->
      element.moveBy dx, dy

module.exports = Editor
