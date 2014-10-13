require 'jquery'
$ = require 'jquery'
uiTemplates = require './../uiTemplates.coffee'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
App = require './../models/app.coffee'
ProjectEditor = require './editors/projectEditor.coffee'
BaseView = require './baseView.coffee'
ElementPaletteView = require './elementPalette.coffee'
Dialog = require './dialog.coffee'
messages = require './../../content/messages.en.json'

class AppView extends BaseView
  el: '#app'

  projectView: null
  elementPalette: null

  initialize: ->
    _.bindAll @, 'loadFile', 'saveFile', 'newProject', 'createElementHandler', 'showError'
    @model.on "change:project", @newProject
    @model.on "error", @showError
    @projectView = new ProjectEditor({model: @model.get 'project'})
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

  saveFile: (e) ->
    @model.saveFile $("#saveFile").val()

  newProject: ->
    if @model?
      @projectView.model = @model.get 'project'
      @projectView.currentPage = null
      @projectView.render()

  createElementHandler: (data) ->
    @projectView.pageView.model.addElement data

  showError: (e) ->
    Dialog.dialog messages[e.type]

  events:
    "change #dataFile"   : "loadFile"
    "change #saveFile"   : "saveFile"

module.exports = AppView
