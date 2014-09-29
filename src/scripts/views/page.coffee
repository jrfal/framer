$ = require 'jquery'
templates = require './../componentTemplates.coffee'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
Page = require './../models/page.coffee'
ElementView = require './element.coffee'

class PageView extends Backbone.View
  className: 'framer-page'
  model: null

  initialize: ->
    _.bindAll @, 'render', 'addElementHandler', 'removeElementHandler', 'sortElementsHandler'
    if @model?
      @setModel @model

    @elementViews = []

  render: ->
    if @model?
      $(@el).children().detach()
      elements = @model.get 'elements'

      for element in elements.models
        elementView = @getElementView(element)
        $(@el).append(elementView.el)

  newElementView: (model) ->
    return new ElementView {model: model}

  getElementView: (element) ->
    elementView = _.find @elementViews, (item) ->
      item.model == element
    if !elementView?
      elementView = @newElementView element
      @elementViews.push elementView
    return elementView

  setModel: (model) ->
    @model = model
    elements = @model.get 'elements'
    elements.on 'add', @addElementHandler
    elements.on 'remove', @removeElementHandler
    elements.on 'sort', @sortElementsHandler

  addElementHandler: (model, collection) ->
    elementView = @getElementView model
    $(@el).append(elementView.el)
    if collection.last() != model
      @updateElementOrder()

  removeElementHandler: (model, collection) ->
    workingCopy = elementViews.slice 0

    for elementView in workingCopy
      if (elementView.model == model)
        $(elementView.el).remove()
        elementViews = _.without elementViews, elementView

  sortElementsHandler: ->
    @updateElementOrder()

  updateElementOrder: ->
    if @model?
      elements = @model.get 'elements'

      clean = false
      while not clean
        clean = true

        for elementView in @elementViews
          found = false
          for element in elements.models
            if not found
              if element == elementView.model
                found = true
              else
                for search in @elementViews
                  if element == search.model
                    $(elementView.el).before(search.el)
                    clean = false

module.exports = PageView
