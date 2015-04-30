$ = require 'jquery'
# uiTemplates = require './../uiTemplates.coffee'
Backbone = require 'backbone'
# Backbone.$ = $
_ = require 'underscore'
Project = require './../models/project.coffee'
BaseView = require './baseView.coffee'
PageView = require './page.coffee'

class ProjectView extends BaseView
  pageView: null
  controlView: null
  currentPage: null

  initialize: ->
    _.bindAll @, 'render'
    @pageView = @newPageView()

  newPageView: ->
    return new PageView()

  showPageSlug: (slug) ->
    @showPage @model.getPageBySlug(slug)

  showPage: (page) ->
    @currentPage = page
    @render()

  render: ->
    if not @model?
      return
    page = null
    if @currentPage?
      page = @currentPage
    else
      pages = @model.get('pages')
      page = pages.at(0)
      @currentPage = page

    if page?
      @pageView.setModel page
      $(@el).empty()
      $(@el).append(@pageView.el)
      @pageView.render()

module.exports = ProjectView
