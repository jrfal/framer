$ = require 'jquery'
Backbone = require 'backbone'
PageView = require './../page.coffee'
ControlLayer = require './controlLayer.coffee'
uiTemplates = require './../../uiTemplates.coffee'
_ = require 'underscore'

class PageEditor extends PageView
  controlLayer: null

  initialize: ->
    super()
    @controlLayer = new ControlLayer {model: @model}

  setModel: (model) ->
    super model
    @controlLayer.setModel model

  render: ->
    if @model?
      $(@el).attr("id", @model.get 'slug')

    super()

    @controlLayer.setElement '#framer_controls'
    @controlLayer.render()

module.exports = PageEditor
