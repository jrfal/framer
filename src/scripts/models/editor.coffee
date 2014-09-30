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

  deselectElement: (element) ->
    elements = @get 'selection'
    if elements.contains element
      elements.remove element

  selectOnlyElement: (element) ->
    @unselectAll()
    @selectElement element

  unselectAll: ->
    elements = @get 'selection'
    elements.reset()

  isSelected: (element) ->
    return @get('selection').contains element

module.exports = Editor
