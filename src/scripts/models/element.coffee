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

  moveBy: (dx, dy) ->
    updates = {}
    updates.x = @get('x') + dx
    updates.y = @get('y') + dy
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

module.exports = Element
