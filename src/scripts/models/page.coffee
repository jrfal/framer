# $ = require 'jquery'
Backbone = require 'backbone'
# Backbone.$ = $
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
    elements.add data

module.exports = Page
