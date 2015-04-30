Backbone = require 'backbone'
_ = require 'underscore'
plugins = require '../../plugins/plugins.coffee'
Element = require './element.coffee'

class Group extends Element
  defaults:
    x: 0
    y: 0
    w: 1.0
    h: 1.0

  initialize: ->
    super()
    @set 'component', 'group'
    # _.bindAll @, 'changeHandler'
    # @on 'change', @changeHandler

  # addElement: (data) ->
  #   elements = @get 'elements'
  #   elements.add data
  #   data.set 'parent', @

  # modifyFullElementList: (list) ->
  #   if @has 'elements'
  #     elements = @get 'elements'
  #     for element in elements.models
  #       element.modifyFullElementList(list)

  # changeHandler: ->
  #   for element in @get("elements").models
  #     element.trigger 'change'

  # saveObject: ->
  #   groupObject = super()
  #   elements = []
  #   for element in groupObject.elements.models
  #     elements.push element.saveObject()
  #   groupObject.elements = elements
  #   return groupObject

module.exports = Group
