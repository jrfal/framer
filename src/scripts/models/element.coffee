Backbone = require 'backbone'
_ = require 'underscore'
plugins = require '../../plugins/plugins.coffee'
components = plugins.components

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

  top: (value) ->
    if value?
      @set 'y', value
      return value
    return @get 'y' if @has 'y'
    return 0

  right: (value) ->
    if value?
      if @has 'w'
        @set 'x', value - @get('w')
        return value
      return @left value
    return @get('x') + @get('w') if @has('x') and @has('w')
    return @left()

  bottom: (value) ->
    if value?
      if @has 'h'
        @set 'y', value - @get('h')
        return value
      return @top value
    return @get('y') + @get('h') if @has('y') and @has('h')
    return @top()

  left: (value) ->
    if value?
      @set 'x', value
      return value
    return @get 'x' if @has 'x'
    return 0

  center: (value) ->
    if value?
      if @has('x') and @has('w')
        @set 'x', value - (@get('w')/2)
        return value
      else
        return @left(value)
    if @has('x') and @has('w')
      return @get('x') + (@get('w')/2)
    return @left()

  middle: (value) ->
    if value?
      if @has('y') and @has('h')
        @set 'y', value - (@get('h')/2)
        return value
      else
        return @top(value)
    if @has('y') and @has('h')
      return @get('y') + (@get('h')/2)
    return @top()

module.exports = Element
