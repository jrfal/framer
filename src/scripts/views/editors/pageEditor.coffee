$ = require 'jquery'
Backbone = require 'backbone'
PageView = require './../page.coffee'
ControlLayer = require './controlLayer.coffee'
uiTemplates = require './../../uiTemplates.coffee'
_ = require 'underscore'
Editor = require './../../models/editor.coffee'
ElementEditor = require './elementEditor.coffee'

class PageEditor extends PageView
  controlLayer: null
  editor: null

  initialize: ->
    @editor = new Editor()
    @controlLayer = new ControlLayer {model: null, editor: @editor}    
    super()

  setModel: (model) ->
    super model
    @controlLayer.setModel model
    if (@editor)
      @editor.set 'context', @model

  render: ->
    if @model?
      $(@el).attr("id", @model.get 'slug')

    super()

    @controlLayer.setElement '#framer_controls'
    @controlLayer.render()

  setAppData: (appData) ->
    @appData = appData
    @controlLayer.setAppData appData

  newElementView: (model) ->
    element = new ElementEditor {model: model}
    if @editor?
      element.editor = @editor
    return element

module.exports = PageEditor
