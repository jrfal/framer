$ = require 'jquery'
Backbone = require 'backbone'
BaseView = require '../baseView.coffee'
_ = require 'underscore'

class MinimizeButton extends BaseView
  tagName: "a"

  init: ->
    super()
    _.bindAll @, "clickHandler", "mousedownHandler"

  clickHandler: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @trigger "click"

  mousedownHandler: (e) ->
    e.stopPropagation()
    e.preventDefault()

  events:
    "click": "clickHandler"
    "mousedown": "mousedownHandler"

module.exports = MinimizeButton
