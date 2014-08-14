# $ = require 'jquery'
Backbone = require 'backbone'
# Backbone.$ = $
_ = require 'underscore'
Element = require './element.coffee'

class Page extends Backbone.Model
  defaults:
    elements: new Backbone.Collection({model: Element})
    slug: 'model'

  initialize: ->
    true

module.exports = Page
