$ = require 'jquery'
Backbone = require 'backbone'
ProjectView = require './../project.coffee'
PageEditor = require './pageEditor.coffee'
uiTemplates = require './../../uiTemplates.coffee'
_ = require 'underscore'

class ProjectEditor extends ProjectView
  saved: true
  filename: ""

  initialize: ->
    super()
    _.bindAll @, 'projectChanged', 'checkNewPage'
    if @model?
      @setModel @model

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

module.exports = ProjectEditor
