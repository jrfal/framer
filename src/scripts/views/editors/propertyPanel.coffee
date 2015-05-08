$ = require 'jquery'
Backbone = require 'backbone'
BaseView = require './../baseView.coffee'
uiTemplates = require './../../uiTemplates.coffee'
plugins = require './../../../plugins/plugins.coffee'
components = plugins.components
_ = require 'underscore'

class PropertyPanel extends BaseView
  template: uiTemplates.propertyPanel

  initialize: (options) ->
    _.bindAll @, 'render', 'cancelHandler', 'saveHandler', 'remove',
      'startDragHandler', 'dragHandler', 'stopDragHandler', 'alignTopHandler',
      'alignRightHandler', 'alignBottomHandler', 'alignLeftHandler',
      'alignCenterHandler', 'alignMiddleHandler', 'inputMouseHandler'
    @previous = {}
    @editor = options.editor if options.editor
    @render()

  render: ->
    getPropEl = (property, modelProperty) ->
      input = plugins.propertyTypes[property.type].input
      if input == 'textarea'
        prop_el = $ "<textarea></textarea>"
      else if input == 'checkbox'
        prop_el = $ '<input type="checkbox" value="true" />'
      else
        prop_el = $ "<input type=\"text\" />"
      prop_el.attr "id", "property-panel-#{property.property}"
      prop_el.attr "name", "property-panel-#{property.property}"
      prop_el.attr "data-property", property.property
      prop_el.attr "placeholder", property.property
      if property.type == "boolean"
        if modelProperty
          prop_el.attr "checked", "checked"
      else
        prop_el.val modelProperty
      return prop_el

    if @collection?
      oldEl = @el
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
                properties.push {propName: property.property, property: property, value: value}

      @setElement $(@template())
      @previous = {}
      for property in properties
        @previous[property.property.property] = property.value
        $(@el).find('.framer-fields').append $("<label for=\"property-panel-#{property.property.property}\">#{property.property.property}</label>")
        $(@el).find('.framer-fields').append getPropEl(property.property, property.value)

      $(oldEl).replaceWith $(@el)

  cancelHandler: ->
    @slideOut()

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

  slideIn: ->
    $(@el).css("margin-left", $(document).width() + "px")
    $(@el).animate({marginLeft: 0}, 400)

  slideOut: ->
    $(@el).removeClass "showing"
    $(@el).animate({marginLeft: $(document).width() + "px"}, 400, @remove)

  startDragHandler: (e) ->
    e.stopPropagation()
    $(document).on 'mousemove', @dragHandler
    $(document).on 'mouseup', @stopDragHandler
    @grab = {x: e.screenX - $(@el).position().left, y: e.screenY - $(@el).position().top}

  dragHandler: (e) ->
    e.stopPropagation()
    e.preventDefault()
    x =  e.screenX - @grab.x
    y =  e.screenY - @grab.y
    $(@el).css "left", x
    $(@el).css "top", y

  stopDragHandler: (e) ->
    e.stopPropagation()
    $(document).off 'mousemove', @dragHandler
    $(document).off 'mouseup', @stopDragHandler

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
    "click .cancel" : "cancelHandler"
    "click .save"   : "saveHandler"
    "mousedown"     : "startDragHandler"
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
