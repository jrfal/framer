$ = require 'jquery'
templates = require './../componentTemplates.coffee'
components = require './../../components/components.json'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
uiTemplates = require './../uiTemplates.coffee'
jsonPath = require 'json-path'
jsonPtr = require 'json-ptr'

class ElementView extends Backbone.View
  className: 'framer-element'

  template: templates.getTemplate 'rectangle'
  transformations: []

  initialize: ->
    if @model.has 'component'
      component = _.findWhere components, {component: @model.get('component')}

      if component?
        if component.template?
          template = component.template
        if 'transformations' of component
          @transformations = component.transformations
      if not template?
        template = @model.get('component')
      @template = templates.getTemplate template
    _.bindAll @, 'render', 'setElement'
    @model.on "change", @render
    @render()

  render: ->
    if @model?
      oldEl = @el
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
      @setElement $(@template(viewAttributes))
      @$el.attr("data-element", @model.get('id'))
      $(oldEl).replaceWith $(@el)

  modelData: ->
    return model.attributes


module.exports = ElementView
