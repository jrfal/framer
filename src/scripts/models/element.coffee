# $ = require 'jquery'
Backbone = require 'backbone'
# Backbone.$ = $
_ = require 'underscore'

class Element extends Backbone.Model
  defaults:
    template: 'rectangle'
    x: 0
    y: 0
    width: 100
    height: 100


module.exports = Element
