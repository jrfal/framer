$ = require 'jquery'
uiTemplates = require './../uiTemplates.coffee'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
App = require './../models/app.coffee'
ProjectView = require './project.coffee'
BaseView = require './baseView.coffee'

class AppView extends BaseView
  el: '#app'

  projectView: new ProjectView()

  initialize: ->
    _.bindAll @, 'render', 'loadFile', 'newProject'
    @model.on "change:project", @newProject

    @render()

  render: ->
    $(@el).html uiTemplates.app({})
    @assign @projectView, '#framer_pages'

    # trigger css file load
    $("#cssFile").change ->
      cssFile = $("#cssFile").val()
      $("#cssLink").attr "href", cssFile

  loadFile: (e) ->
    @model.loadFile $("#dataFile").val()

  newProject: ->
    if @model?
      @projectView.model = @model.get 'project'
      @projectView.currentPage = null
      @projectView.render()

  events:
    "change #dataFile"   : "loadFile"

module.exports = AppView
