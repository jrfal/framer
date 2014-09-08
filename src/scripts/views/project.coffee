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
  pageView: new PageView()
  controlView: new ControlLayer()
  currentPage: null

  initialize: ->
    _.bindAll @, 'render'

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
      @pageView.model = page
      @pageView.render()
      $(@el).empty()
      $(@el).append(@pageView.el)

      @controlView.model = page
      @controlView.setElement '#framer_controls'
      @controlView.render()
      # @assign @controlView, '#framer_controls'


module.exports = ProjectView
