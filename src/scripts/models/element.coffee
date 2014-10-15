# $ = require 'jquery'
Backbone = require 'backbone'
# Backbone.$ = $
_ = require 'underscore'

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


module.exports = Element
