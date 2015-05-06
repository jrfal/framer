Backbone = require 'backbone'
_ = require 'underscore'
plugins = require '../../plugins/plugins.coffee'
components = plugins.components

id = 1;

class Element extends Backbone.Model
  initialize: ->
    @set 'id', id++
    _.bindAll @, 'changeHandler', 'changeMasterHandler', 'masterChangedHandler'
    @on 'change', @changeHandler

    @changeMasterHandler()
    @on 'change:master', @changeMasterHandler

  removeFromParent: ->
    if @has "parent"
      @get("parent").removeElement @

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
    if not @has 'w'
      if @has "naturalW"
        @set "w", @get("naturalW")
      else
        @set 'w', 1
    if not @has 'h'
      if @has "naturalH"
        @set "h", @get("naturalH")
      else
        @set 'h', 1
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

  modifyFullElementList: (list) ->
    if @has 'elements'
      elements = @get 'elements'
      for element in elements.models
        element.modifyFullElementList(list)
    else if @get("component") != "group"
      list.push @

  saveObject: ->
    elementObject = _.clone @attributes
    delete elementObject.naturalW
    delete elementObject.naturalH
    delete elementObject.parent

    if elementObject.elements?
      elements = []
      for element in elementObject.elements.models
        elements.push element.saveObject()
      elementObject.elements = elements

    return elementObject

  addElement: (data) ->
    if not @has 'elements'
      @set 'elements', new Backbone.Collection([], {model: Element})
    elements = @get 'elements'
    newModel = elements.add data
    newModel.set 'parent', @

    if newModel.has "elements"
      if not newModel.get("elements").models?
        children = newModel.get("elements")
        newModel.unset "elements"
        for child in children
          newModel.addElement child

  removeElement: (data) ->
    if @has "elements"
      @get("elements").remove data

  changeHandler: ->
    if @has "elements"
      if @get("elements").models?
        for element in @get("elements").models
          element.trigger 'change', element

  changeMasterHandler: ->
    if @has "master"
      if @has "elements"
        for element in @get("elements").models
          element.removeFromParent()

      master = @get "master"
      if master.has "elements"
        for element in master.get("elements").models
          @addElement new Element({master: element})

      master.on "change", @masterChangedHandler

  masterChangedHandler: (master) ->
    if master == @get("master")
      @trigger "change", @
    else
      master.off "change", @masterChangeHandler

  orMasterHas: (key) ->
    if @has key
      return true
    if @has "master"
      if @get("master").orMasterHas key
        return true
    return false

  orMasterGet: (key) ->
    if @has key
      return @get key
    if @has "master"
      return @get("master").orMasterGet key
    return @get key

module.exports = Element
