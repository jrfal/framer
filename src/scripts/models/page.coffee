Backbone = require 'backbone'
_ = require 'underscore'
Element = require './element.coffee'

class Page extends Backbone.Model
  defaults:
    slug: 'page'

  initialize: ->
    _.bindAll @, 'getElementByID'
    @set 'elements', new Backbone.Collection([], {model: Element})

  getElementByID: (id) ->
    return @get('elements').findWhere {id: id}

  addElement: (data) ->
    elements = @get 'elements'
    newModel = elements.add data
    newModel.set {'parent': @}

  removeElement: (data) ->
    @get('elements').remove data

  fullElementList: ->
    elements = @get 'elements'
    list = []
    for element in elements.models
      element.modifyFullElementList list
    return list

  saveObject: ->
    pageObject = _.clone @attributes
    elements = []
    for element in pageObject.elements.models
      elements.push element.saveObject()
    pageObject.elements = elements
    return pageObject

module.exports = Page
