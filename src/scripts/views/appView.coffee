require 'jquery'
$ = require 'jquery'
uiTemplates = require './../uiTemplates.coffee'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
App = require './../models/app.coffee'
ProjectView = require './project.coffee'
BaseView = require './baseView.coffee'
ElementPaletteView = require './elementPalette.coffee'

class AppView extends BaseView
  el: '#app'

  projectView: null
  elementPalette: null

  initialize: ->
    _.bindAll @, 'render', 'loadFile', 'newProject'
    @model.on "change:project", @newProject
    @projectView = new ProjectView()
    @elementPalette = new ElementPaletteView()

    @render()

  render: ->
    $(@el).html uiTemplates.app({})
    @assign @projectView, '#framer_pages'
    @assign @elementPalette, '#framer_elementPalette'

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

  showMessage: (message) ->
    if ($ '#framer_message')
      @hideMessage

  hideMessage: ->


  events:
    "change #dataFile"   : "loadFile"

module.exports = AppView
