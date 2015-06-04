$ = require 'jquery'
Backbone = require 'backbone'
BaseView = require '../baseView.coffee'
_ = require 'underscore'

class MinimizeButton extends BaseView
  tagName: "a"
  panel: null

  initialize: (options) ->
    super(options)
    if options.panel?
      @panel = options.panel
    _.bindAll @, "clickHandler", "mousedownHandler"

  clickHandler: (e) ->
    e.stopPropagation()
    e.preventDefault()
    if @panel?
      @panel.toggle()
    @trigger "click"

  mousedownHandler: (e) ->
    e.stopPropagation()
    e.preventDefault()

  events:
    "click": "clickHandler"
    "mousedown": "mousedownHandler"

module.exports = MinimizeButton
