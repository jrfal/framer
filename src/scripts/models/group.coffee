Backbone = require 'backbone'
_ = require 'underscore'
plugins = require '../../plugins/plugins.coffee'
Element = require './element.coffee'

class Group extends Element
  defaults:
    x: 0
    y: 0
    w: 1.0
    h: 1.0

  initialize: ->
    @set 'elements', new Backbone.Collection([], {model: Element})
    _.bindAll @, 'changeHandler'
    @on 'change', @changeHandler

  addElement: (data) ->
    elements = @get 'elements'
    elements.add data
    data.set 'parent', @

  modifyFullElementList: (list) ->
    if @has 'elements'
      elements = @get 'elements'
      for element in elements.models
        element.modifyFullElementList(list)

  changeHandler: ->
    for element in @get("elements").models
      element.trigger 'change'

module.exports = Group
