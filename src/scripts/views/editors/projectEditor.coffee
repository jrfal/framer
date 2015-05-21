$ = require 'jquery'
Backbone = require 'backbone'
ProjectView = require './../project.coffee'
PageEditor = require './pageEditor.coffee'
uiTemplates = require './../../uiTemplates.coffee'
_ = require 'underscore'
MinimizeButton = require './minimizeButton.coffee'
PagesPanel = require './pagesPanel.coffee'

class ProjectEditor extends ProjectView
  saved: true
  filename: ""
  pagesPanelButton: null
  pagesPanel: null

  initialize: ->
    super()
    _.bindAll @, 'projectChanged', 'checkNewPage', 'togglePagesPanel', 'pageSwitchHandler'
    if @model?
      @setModel @model
    @pagesPanelButton = new MinimizePagesButton()
    @pagesPanelButton.on "click", @togglePagesPanel
    @pagesPanel = new PagesPanel {collection: @model.get("pages")}
    @pagesPanel.render()
    @pagesPanel.hide()
    @pagesPanel.on "pageSwitch", @pageSwitchHandler

  render: ->
    super()
    $("#wire_panels").append @pagesPanelButton.el
    $("#wire_panels").append @pagesPanel.el

  checkNewPage: (page) ->
    page.on 'change', @projectChanged
    page.get('elements').on 'change add remove', @projectChanged

  newPageView: ->
    pageView = new PageEditor()
    if @appData?
      pageView.appData = @appData
    return pageView

  projectChanged: ->
    @saved = false

  projectSaved: ->
    @saved = true

  setModel: (model) ->
    @model = model
    pages = @model.get 'pages'
    pages.each @checkNewPage
    pages.on 'add', @checkNewPage

  setAppData: (appData) ->
    @appData = appData
    @pageView.setAppData appData

  togglePagesPanel: ->
    @pagesPanel.toggle()

  pageSwitchHandler: (slug) ->
    @showPageSlug slug

class MinimizePagesButton extends MinimizeButton
  id: "wirekit_pages_button"

module.exports = ProjectEditor
