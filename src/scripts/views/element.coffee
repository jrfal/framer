$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
uiTemplates = require './../uiTemplates.coffee'
jsonPath = require 'json-path'
jsonPtr = require 'json-ptr'
plugins = require './../../plugins/plugins.coffee'
components = plugins.components

class ElementView extends Backbone.View
  className: 'framer-element'

  transformations: null
  renderers: null
  componentData: null
  context: null

  initialize: ->
    @transformations = []
    @renderers = []

    if @model?
      if @model.has 'component'
        component = _.findWhere components, {component: @model.get('component')}
        if component?
          for renderer in component.renderers
            @renderers.push new plugins.renderers[renderer](@model)

          if 'transformations' of component
            @transformations = component.transformations

      _.bindAll @, 'render', 'setElement'
      @model.on "change", @render
      @render()

  viewAttributes: ->
    viewAttributes = _.clone @model.attributes
    for transformation in @transformations
      transform = plugins.transformations[transformation[0]]
      path = jsonPath.create transformation[1]
      query = path.resolve viewAttributes
      dataType = "value"
      if transformation[3]?
        dataType = transformation[3]
      for item in query
        pointer = jsonPtr.create transformation[2]
        if pointer?
          if dataType == "array"
            list = pointer.get viewAttributes
            if not list?
              list = []
              pointer.set viewAttributes, list
            list.push transform(item)
          else
            transformed = transform(item)
            pointer.set viewAttributes, transformed
    step = @model
    while step.has "parent"
      step = step.get "parent"
      if viewAttributes.x? and step.has "x"
        viewAttributes.x += step.get("x")
      if viewAttributes.y? and step.has "y"
        viewAttributes.y += step.get("y")
    return viewAttributes

  modifyQueue: (queue) ->
    queue.push @

  render: ->
    if @model?
      for renderer in @renderers
        oldEl = @el
        @setElement renderer.render(@viewAttributes())
        $(oldEl).replaceWith $(@el)
      @$el.attr("data-element", @model.get('id'))

  modelData: ->
    return model.attributes


module.exports = ElementView
