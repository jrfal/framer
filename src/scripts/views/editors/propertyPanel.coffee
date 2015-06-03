$ = require 'jquery'
Backbone = require 'backbone'
Panel = require './panel.coffee'
uiTemplates = require './../../uiTemplates.coffee'
plugins = require './../../../plugins/plugins.coffee'
components = plugins.components
_ = require 'underscore'

class PropertyPanel extends Panel
  template: uiTemplates.propertyPanel

  initialize: (options) ->
    super()
    _.bindAll @, 'render', 'saveHandler', 'remove',
      'alignTopHandler',
      'alignRightHandler', 'alignBottomHandler', 'alignLeftHandler',
      'alignCenterHandler', 'alignMiddleHandler', 'inputMouseHandler'
    @previous = {}
    @editor = options.editor if options.editor?
    if @editor?
      @setCollection @editor.get("selection")
    @render()

  templateAttributes: ->
    if @collection?
      properties = []

      for model in @collection.models
        if model.get('component')?
          component = _.findWhere components, {component: model.get('component')}
          if component?
            for property in model.allProperties()
              previous = _.findWhere properties, {propName: property.property}
              if previous?
                if previous.value != model.get(property.property)
                  previous.value = ''
              else
                value = model.get property.property
                value = '' if not value?
                newProp = {propName: property.property, property: property, value: value}

                input = plugins.propertyTypes[property.type].input
                newProp.typeTextarea = true if input == 'textarea'
                newProp.typeCheckbox = true if input == 'checkbox'
                newProp.typeNumber = true if input == 'number'
                newProp.typeColor = true if input == 'color'

                properties.push newProp

      @setElement $(@template())
      @previous = {}
      for property in properties
        @previous[property.property.property] = property.value
        property.label = property.property.property
        property.label = plugins.labels[property.label] if plugins.labels[property.label]?

    return {properties: properties}

  saveHandler: ->
    fields = $(@el).find(".framer-fields > *")
    updates = {}
    for field in fields
      newValue = null
      property = $(field).data "property"
      if $(field).is("[type=checkbox]")
        if $(field).is(":checked")
          newValue = true
        else
          newValue = false
      else
        newValue = $(field).val()
      if newValue != @previous[property]
        updates[property] = newValue
    for model in @collection.models
      modelUpdates = model.validateProperties updates
      model.set modelUpdates

  alignTopHandler: (e) ->
    e.preventDefault()
    @editor.alignSelectedTop()

  alignRightHandler: (e) ->
    e.preventDefault()
    @editor.alignSelectedRight()

  alignBottomHandler: (e) ->
    e.preventDefault()
    @editor.alignSelectedBottom()

  alignLeftHandler: (e) ->
    e.preventDefault()
    @editor.alignSelectedLeft()

  alignCenterHandler: (e) ->
    e.preventDefault()
    @editor.alignSelectedCenter()

  alignMiddleHandler: (e) ->
    e.preventDefault()
    @editor.alignSelectedMiddle()

  distributeTopHandler: (e) ->
    e.preventDefault()
    @editor.distributeSelectedTop()

  distributeRightHandler: (e) ->
    e.preventDefault()
    @editor.distributeSelectedRight()

  distributeBottomHandler: (e) ->
    e.preventDefault()
    @editor.distributeSelectedBottom()

  distributeLeftHandler: (e) ->
    e.preventDefault()
    @editor.distributeSelectedLeft()

  distributeCenterHandler: (e) ->
    e.preventDefault()
    @editor.distributeSelectedCenter()

  distributeMiddleHandler: (e) ->
    e.preventDefault()
    @editor.distributeSelectedMiddle()

  groupHandler: (e) ->
    e.preventDefault()
    @editor.groupSelected()

  ungroupHandler: (e) ->
    e.preventDefault()
    @editor.ungroupSelected()

  componentizeHandler: (e) ->
    e.preventDefault()
    @editor.componentizeSelected()

  inputMouseHandler: (e) ->
    e.stopPropagation()

  events:
    "click .save"   : "saveHandler"

    "click .framer-align-top"     : "alignTopHandler"
    "click .framer-align-right"   : "alignRightHandler"
    "click .framer-align-bottom"  : "alignBottomHandler"
    "click .framer-align-left"    : "alignLeftHandler"
    "click .framer-align-center"  : "alignCenterHandler"
    "click .framer-align-middle"  : "alignMiddleHandler"

    "click .framer-distribute-top"     : "distributeTopHandler"
    "click .framer-distribute-right"   : "distributeRightHandler"
    "click .framer-distribute-bottom"  : "distributeBottomHandler"
    "click .framer-distribute-left"    : "distributeLeftHandler"
    "click .framer-distribute-center"  : "distributeCenterHandler"
    "click .framer-distribute-middle"  : "distributeMiddleHandler"

    "click .framer-group"   : "groupHandler"
    "click .framer-ungroup" : "ungroupHandler"

    "click .framer-componentize" : "componentizeHandler"

    "mousedown input": "inputMouseHandler"
    "mousedown textarea": "inputMouseHandler"

module.exports = PropertyPanel
