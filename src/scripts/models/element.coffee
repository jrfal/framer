# $ = require 'jquery'
Backbone = require 'backbone'
# Backbone.$ = $
_ = require 'underscore'
components = require '../../components/components.json'
plugins = require '../plugins.coffee'

id = 1;

class Element extends Backbone.Model
  initialize: ->
    _.bindAll @, 'set'
    @set 'id', id++

  addMoveUpdates: (updates, x, y) ->
    updates.x = x
    updates.y = y
    return updates

  moveBy: (dx, dy) ->
    updates = @addMoveUpdates {}, @get('x') + dx, @get('y') + dy
    @set updates

  moveTo: (x, y) ->
    updates = @addMoveUpdates {}, x, y
    @set updates

  addScaleUpdates: (updates, dw, dh) ->
    updates.w = @get('w') * dw
    updates.h = @get('h') * dh
    return updates

  scaleBy: (dw, dh) ->
    updates = @addScaleUpdates {}, dw, dh
    @set updates

  moveAndScaleBy: (x, y, dw, dh) ->
    updates = @addScaleUpdates {}, dw, dh
    updates = @addMoveUpdates updates, x, y
    @set updates

  allProperties: ->
    propsFromComponent = (component) ->
      properties = []
      if component.properties?
        for property in component.properties
          if property.inherit?
            inherit = _.findWhere components, {component: property.inherit}
            if inherit?
              properties = _.union properties, propsFromComponent(inherit)
          else
            properties.push property
      return properties

    component = _.findWhere components, {component: @get('component')}
    return propsFromComponent component

  validateValue: (property, value) ->
    data = _.findWhere @allProperties(), {property: property}
    return null if not data?
    validation = plugins.propertyTypes[data.type].validation
    return plugins.validations[validation](value)

  validateProperties: (properties) ->
    returnProperties = {}
    for key, value of properties
      validated = @validateValue key, value
      if validated?
        returnProperties[key] = validated
    return returnProperties

  getGeos: ->
    geos = []
    if @attributes.x? and @attributes.y?
      geos.push {x: @attributes.x, y: @attributes.y}
      if @attributes.w? and @attributes.h?
        geos.push {x: @attributes.x + @attributes.w, y: @attributes.y + @attributes.h}

    return geos

module.exports = Element
