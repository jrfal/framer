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
GuideView = require './guide.coffee'

class AppView extends BaseView
  el: '#app'

  projectView: null
  elementPalette: null
  afterSaving: null
  gridView: null

  initialize: ->
    _.bindAll @, 'loadFile', 'saveFile', 'loadFileCmd', 'newProject', 'newProjectCmd', 'createElementHandler', 'showError',
      'closeElementPaletteHandler', 'showHideElementPalette', 'savedProject', 'saveAndLoad',
      'saveAndNew', 'makeNewProject', 'renamePage', 'renamePageHandler', 'showHideGridLines',
      'editGridHandler'
    @model.on "change:project", @newProject
    @model.on "error", @showError
    @model.on "saved", @savedProject

    settings = @model.get 'settings'
    settings.on "change:elementPalette", @showHideElementPalette
    settings.on "change:gridLines", @showHideGridLines
    @projectView = new ProjectEditor({model: @model.get 'project'})
    @projectView.setAppData {settings: settings, grid: @model.grid}
    @elementPalette = new ElementPaletteView()
    @elementPalette.on 'createElement', @createElementHandler
    @elementPalette.on 'close', @closeElementPaletteHandler
    @gridView = new GuideView {model: @model.grid}

    @render()

  render: ->
    $(@el).html uiTemplates.app({})
    @assign @projectView, '#framer_pages'
    @assign @elementPalette, '#framer_elementPalette'
    @showHideElementPalette()
    @assign @gridView, "#framer_grid"
    @showHideGridLines()

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

  showHideGridLines: ->
    if @model.get('settings').get 'gridLines'
      $(@gridView.el).show()
    else
      $(@gridView.el).hide()

  showHideElementPalette: ->
    if @model.get('settings').get 'elementPalette'
      $(@elementPalette.el).show()
    else
      $(@elementPalette.el).hide()

  renamePage: ->
    edit = Dialog.edit messages["rename page header"], [{class: "rename-page", value: @projectView.currentPage.get('slug')}], messages["rename page submit"]
    $(edit.el).find(".submit").on "click", @renamePageHandler

  renamePageHandler: (e) ->
    newPageName = $(e.target).closest('.bbm-modal').find('.edit-value.rename-page').val()
    @projectView.currentPage.set({'slug': newPageName})

  editGrid: ->
    edit = Dialog.edit messages["edit grid header"], [{class: "grid-cell", value: @model.get('settings').get('gridCellSize')}, {class: "grid-group", value: @model.get('settings').get('gridCellGroup')}], messages["edit grid submit"]
    $(edit.el).find(".submit").on "click", @editGridHandler

  editGridHandler: (e) ->
    newCellSize = $(e.target).closest('.bbm-modal').find('.edit-value.grid-cell').val()
    newCellGroup = $(e.target).closest('.bbm-modal').find('.edit-value.grid-group').val()
    @model.get('settings').set({gridCellSize: newCellSize, gridCellGroup: newCellGroup})

  getSelected: ->
    return @projectView.pageView.controlLayer.editor.get 'selection'

  events:
    "change #dataFile"   : "loadFile"
    "change #saveFile"   : "saveFile"

module.exports = AppView
