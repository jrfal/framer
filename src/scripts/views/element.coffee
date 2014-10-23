$ = require 'jquery'
templates = require './../componentTemplates.coffee'
components = require './../../components/components.json'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
uiTemplates = require './../uiTemplates.coffee'
config = require './../config.coffee'

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
        viewAttributes[transformation[2]] = config.transformations[transformation[0]](viewAttributes[transformation[1]])
      @setElement $(@template(viewAttributes))
      @$el.attr("data-element", @model.get('id'))
      $(oldEl).replaceWith $(@el)

  modelData: ->
    return model.attributes


module.exports = ElementView
