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
  afterSaving: null

  initialize: ->
    _.bindAll @, 'loadFile', 'saveFile', 'loadFileCmd', 'newProject', 'newProjectCmd', 'createElementHandler', 'showError',
      'closeElementPaletteHandler', 'showHideElementPalette', 'savedProject', 'saveAndLoad',
      'saveAndNew', 'makeNewProject'
    @model.on "change:project", @newProject
    @model.on "error", @showError
    @model.on "saved", @savedProject
    @model.get('settings').on "change:elementPalette", @showHideElementPalette
    @projectView = new ProjectEditor({model: @model.get 'project'})
    @elementPalette = new ElementPaletteView()
    @elementPalette.on 'createElement', @createElementHandler
    @elementPalette.on 'close', @closeElementPaletteHandler

    @render()

  render: ->
    $(@el).html uiTemplates.app({})
    @assign @projectView, '#framer_pages'
    @assign @elementPalette, '#framer_elementPalette'
    @showHideElementPalette()

    # trigger css file load
    $("#cssFile").change ->
      cssFile = $("#cssFile").val()
      $("#cssLink").attr "href", cssFile

  loadFile: (e) ->
    filename = $("#dataFile").val()
    if filename == ''
      return
    @model.loadFile filename
    @projectView.filename = filename
    $('#dataFile').val('')

  saveAndLoad: ->
    @afterSaving = @loadFileCmd
    @saveFileCmd()

  saveAndNew: ->
    @afterSaving = @newProjectCmd
    @saveFileCmd()

  loadFileCmd: ->
    if not @projectView.saved
      question = Dialog.question messages["unsaved title"], messages["load while unsaved"], [{label: messages["no-save label"], class: "no-save"}, {label: messages["save label"], class: "save"}]
      $(question.el).find(".save").on "click", @saveAndLoad
      $(question.el).find(".no-save").on "click", ->
        $("#dataFile").click()
    else
      $("#dataFile").click()

  saveFile: (e, filename) ->
    if not filename?
      filename = $("#saveFile").val()
    if filename == ''
      return
    @model.saveFile filename
    @projectView.saved = true
    if @afterSaving?
      @afterSaving()
      @afterSaving = null
    $('#saveFile').val('')

  saveFileCmd: ->
    $("#saveFile").click()

  makeNewProject: ->
    if @model?
      @model.newProject()

  newProjectCmd: ->
    if not @projectView.saved
      question = Dialog.question messages["unsaved title"], messages["load while unsaved"], [{label: messages["no-save label"], class: "no-save"}, {label: messages["save label"], class: "save"}]
      $(question.el).find(".save").on "click", @saveAndNew
      $(question.el).find(".no-save").on "click", @makeNewProject
    else
      @makeNewProject()

  newProject: ->
    if @model?
      @projectView.setModel @model.get 'project'
      @projectView.currentPage = null
      @projectView.render()

  savedProject: ->
    @projectView.projectSaved()

  createElementHandler: (data) ->
    @projectView.pageView.model.addElement data

  showError: (e) ->
    Dialog.message messages['error title'], messages[e.type]

  closeElementPaletteHandler: ->
    @model.hideElementPalette()
    $(@elementPalette.el).hide()

  showHideElementPalette: ->
    if @model.get('settings').get 'elementPalette'
      $(@elementPalette.el).show()
    else
      $(@elementPalette.el).hide()

  getSelected: ->
    return @projectView.pageView.controlLayer.editor.get 'selection'

  events:
    "change #dataFile"   : "loadFile"
    "change #saveFile"   : "saveFile"

module.exports = AppView
