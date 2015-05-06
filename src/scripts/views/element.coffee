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
  needNaturalSize: true

  initialize: ->
    @transformations = []
    @renderers = []

    if @model?
      if @model.orMasterHas 'component'
        component = _.findWhere components, {component: @model.orMasterGet('component')}
        if component?
          for renderer in component.renderers
            @renderers.push new plugins.renderers[renderer](@model)

          if 'transformations' of component
            @transformations = component.transformations

      _.bindAll @, 'changeHandler', 'setElement', 'render'
      @model.on "change", @changeHandler
      @model.on "modifying", @render
      @render()

  viewAttributes: ->
    viewAttributes = {}
    if @model.has 'master'
      _.extend viewAttributes, @model.get('master').attributes
    _.extend viewAttributes, @model.attributes

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
      if viewAttributes.x? and step.orMasterHas "w"
        viewAttributes.x *= step.orMasterGet("w")
      if viewAttributes.y? and step.orMasterHas "h"
        viewAttributes.y *= step.orMasterGet("h")
      if viewAttributes.x? and step.orMasterHas "x"
        viewAttributes.x += step.orMasterGet("x")
      if viewAttributes.y? and step.orMasterHas "y"
        viewAttributes.y += step.orMasterGet("y")
      if viewAttributes.w? and step.orMasterHas "w"
        viewAttributes.w *= step.orMasterGet("w")
      if viewAttributes.h? and step.orMasterHas "h"
        viewAttributes.h *= step.orMasterGet("h")
    # eliminate some high precision error
    if viewAttributes.x?
      viewAttributes.x = Math.round(viewAttributes.x * 1000)/1000
    if viewAttributes.y?
      viewAttributes.y = Math.round(viewAttributes.y * 1000)/1000
    if viewAttributes.w?
      viewAttributes.w = Math.round(viewAttributes.w * 1000)/1000
    if viewAttributes.h?
      viewAttributes.h = Math.round(viewAttributes.h * 1000)/1000
    return viewAttributes

  modifyQueue: (queue) ->
    queue.push @

  changeHandler: ->
    @needNaturalSize = true
    @render()

  render: ->
    if @model?
      for renderer in @renderers
        oldEl = @el
        @setElement renderer.render(@viewAttributes())
        $(oldEl).replaceWith $(@el)
      @$el.attr("data-element", @model.get('id'))
      if @needNaturalSize
        naturalW = $(@el).width()
        naturalH = $(@el).height()
        if naturalW == 0
          if not @model.has "naturalW"
            @model.set "naturalW", 1
        else
          @model.set "naturalW", naturalW
        if naturalH == 0
          if not @model.has "naturalH"
            @model.set "naturalH", 1
        else
          @model.set "naturalH", naturalH
        @needNaturalSize = false
        if @model.get("w") < naturalW
          @model.set "w", naturalW
        if @model.get("h") < naturalH
          @model.set "h", naturalH

  modelData: ->
    return model.attributes


module.exports = ElementView
