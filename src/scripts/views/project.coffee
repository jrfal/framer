$ = require 'jquery'
# uiTemplates = require './../uiTemplates.coffee'
Backbone = require 'backbone'
# Backbone.$ = $
_ = require 'underscore'
Project = require './../models/project.coffee'
BaseView = require './baseView.coffee'
PageView = require './page.coffee'
ControlLayer = require './controlBoxes.coffee'

class ProjectView extends BaseView
  model: new Project()
  pageView: new PageView()
  controlView: new ControlLayer()
  currentPage: null

  initialize: ->
    _.bindAll @, 'render'
    @render

  render: ->
    page = null
    if @currentPage?
      page = @currentPage
    else
      pages = @model.get('pages')
      page = pages.at(0)

    @pageView.model = page
    @pageView.render()
    $(@el).append(@pageView.el)


module.exports = ProjectView
