$ = require 'jquery'
Backbone = require 'backbone'
BaseView = require './../baseView.coffee'
uiTemplates = require './../../uiTemplates.coffee'
plugins = require './../../../plugins/plugins.coffee'
_ = require 'underscore'

class PagesPanel extends BaseView
  template: uiTemplates.pagesPanel
  shown: false

  initialize: ->
    super()
    _.bindAll @, 'collectionChangeHandler', 'pageClickHandler'
    if @collection?
      @setCollection @collection

  setCollection: (collection) ->
    if @collection != collection
      collection.off "add remove reset", @collectionChangeHandler
      @collection = collection
    collection.on "add remove reset", @collectionChangeHandler

  collectionChangeHandler: ->
    @render()

  templateAttributes: ->
    attributes = []
    if @collection?
      for page in @collection.models
        attributes.push {slug: page.get("slug")}
    attributes

  render: ->
    if @collection?
      oldEl = @el
      @setElement $(@template({pages: @templateAttributes()}))
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

  pageClickHandler: (e) ->
    e.preventDefault()
    e.stopPropagation()

    slug = $(e.target).data("slug")
    @trigger "pageSwitch", slug

  events:
    "click a": 'pageClickHandler'

module.exports = PagesPanel
