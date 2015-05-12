$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
Page = require './../models/page.coffee'
ElementView = require './element.coffee'
BaseView = require './baseView.coffee'
plugins = require './../../plugins/plugins.coffee'

class PageView extends BaseView
  className: 'framer-page'
  model: null
  zoomFactor: 1

  initialize: ->
    _.bindAll @, 'render', 'addElementHandler', 'removeElementHandler', 'sortElementsHandler',
      'pageChangedHandler'
    if @model?
      @setModel @model

    @elementViews = []

  render: ->
    if @model?
      $(@el).children().detach()
      elements = @model.get 'elements'

      unused = []
      for elementView in @elementViews
        if not elements.contains elementView.model
          unused.push elementView
      @elementViews = _.difference @elementViews, unused

      elementQueue = @model.fullElementList()
      for plugin in plugins.modifyElementQueue
        plugin @, elementQueue

      @renderElements(elementQueue)

  renderElements: (queue) ->
    for element in queue
      elementView = @getElementView(element)
      $(@el).append(elementView.el)
      elementView.render()

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
    @model.on 'change', @pageChangedHandler
    elements = @model.get 'elements'
    elements.on 'add', @addElementHandler
    elements.on 'remove', @removeElementHandler
    elements.on 'sort', @sortElementsHandler

  pageChangedHandler: () ->
    @render()

  addElementHandler: (model, collection) ->
    queue = []
    model.modifyFullElementList(queue)
    @renderElements(queue)
    if collection.last() != model
      @updateElementOrder()

  removeElementHandler: (model, collection) ->
    workingCopy = @elementViews.slice 0

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

  changeZoom: (factor) ->
    @zoomFactor = factor
    $(@el).css "transform", "scale(#{@zoomFactor})"

  zoomIn: ->
    @changeZoom @zoomFactor * 1.5

  zoomOut: ->
    @changeZoom @zoomFactor * 2 / 3

module.exports = PageView
