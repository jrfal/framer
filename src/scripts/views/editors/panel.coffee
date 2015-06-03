$ = require 'jquery'
Backbone = require 'backbone'
BaseView = require './../baseView.coffee'
uiTemplates = require './../../uiTemplates.coffee'
plugins = require './../../../plugins/plugins.coffee'
_ = require 'underscore'

class Panel extends BaseView
  template: null
  shown: false

  initialize: ->
    _.bindAll @, "collectionChangeHandler"

  setCollection: (collection) ->
    if @collection != collection
      collection.off "add remove reset", @collectionChangeHandler
      @collection = collection
    collection.on "add remove reset", @collectionChangeHandler

  collectionChangeHandler: ->
    @render()

  templateAttributes: ->
    return {}

  render: ->
    if @template?
      oldEl = @el
      @setElement $(@template(@templateAttributes()))
      if @shown
        @show()
      else
        @hide()
      $(oldEl).replaceWith @el

  hide: ->
    @shown = false
    $(@el).hide()

  show: ->
    @shown = true
    $(@el).show()

  toggle: ->
    if @shown
      @hide()
    else
      @show()

module.exports = Panel
