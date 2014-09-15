$ = require 'jquery'
# uiTemplates = require './../uiTemplates.coffee'
Backbone = require 'backbone'
# Backbone.$ = $
_ = require 'underscore'
Project = require './../models/project.coffee'
BaseView = require './baseView.coffee'
PageView = require './page.coffee'
ControlLayer = require './controlLayer.coffee'

class ProjectView extends BaseView
  pageView: null
  controlView: null
  currentPage: null

  initialize: ->
    _.bindAll @, 'render'
    @pageView = new PageView()
    @controlView = new ControlLayer()

  render: ->
    if not @model?
      return
    page = null
    if @currentPage?
      page = @currentPage
    else
      pages = @model.get('pages')
      page = pages.at(0)

    if page?
      @pageView.setModel page
      @pageView.render()
      $(@el).empty()
      $(@el).append(@pageView.el)

      @controlView.setModel page
      @controlView.setElement '#framer_controls'
      @controlView.render()


module.exports = ProjectView
