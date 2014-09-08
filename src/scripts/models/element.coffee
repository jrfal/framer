# $ = require 'jquery'
Backbone = require 'backbone'
# Backbone.$ = $
_ = require 'underscore'

id = 1;

class Element extends Backbone.Model
  initialize: ->
    _.bindAll @, 'set'
    @set 'id', id++


module.exports = Element
