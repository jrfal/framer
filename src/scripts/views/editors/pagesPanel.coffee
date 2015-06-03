$ = require 'jquery'
Backbone = require 'backbone'
Panel = require './panel.coffee'
uiTemplates = require './../../uiTemplates.coffee'
plugins = require './../../../plugins/plugins.coffee'
_ = require 'underscore'

class PagesPanel extends Panel
  template: uiTemplates.pagesPanel
  collection: null

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
    attributes = {pages: []}
    if @collection?
      for page in @collection.models
        attributes.pages.push {slug: page.get("slug")}
    attributes

  pageClickHandler: (e) ->
    e.preventDefault()
    e.stopPropagation()

    slug = $(e.target).data("slug")
    @trigger "pageSwitch", slug

  events:
    "click a": 'pageClickHandler'

module.exports = PagesPanel
