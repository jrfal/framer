$ = require 'jquery'
templates = require './../componentTemplates.coffee'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
Page = require './../models/page.coffee'
ElementView = require './element.coffee'

class PageView extends Backbone.View
  className: 'framer-page'
  elementViews: []

  model: null

  initialize: ->
    _.bindAll @, 'render'
    @render()

  render: ->
    if @model?
      $(@el).children().detach()
      elements = @model.get 'elements'

      for element in elements.models
        elementView = @getElementView(element)
        $(@el).append(elementView.el)

  getElementView: (element) ->
    elementView = _.find @elementViews, (item) ->
      item.model == element
    if !elementView?
      elementView = new ElementView {model: element}
      @elementViews.push elementView
    return elementView

module.exports = PageView
