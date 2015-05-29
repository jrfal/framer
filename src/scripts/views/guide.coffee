$ = require 'jquery'
_ = require 'underscore'
global.Backbone = require 'backbone'
uiTemplates = require './../uiTemplates.coffee'
BaseView = require './baseView.coffee'
Guide = require './../models/guide.coffee'

class GuideView extends BaseView
  template: uiTemplates.gridLines

  initialize: ->
    _.bindAll @, 'render'
    if @model?
      @model.on "change", @render

  render: ->
    if @model.get('type') == 'grid'
      $(@el).html @template({smallCell: @model.get('cellSize'), bigCell: @model.get('cellSize') * @model.get('cellGroup'), lineColor: @model.get('lineColor')})

module.exports = GuideView
