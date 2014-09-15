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
    _.bindAll @, 'loadFile', 'newProject', 'createElementHandler'
    @model.on "change:project", @newProject
    @projectView = new ProjectView({model: @model.get 'project'})
    @elementPalette = new ElementPaletteView()
    @elementPalette.on('createElement', @createElementHandler)

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

  createElementHandler: (data) ->
    @projectView.pageView.model.addElement data

  events:
    "change #dataFile"   : "loadFile"

module.exports = AppView
