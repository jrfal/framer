$ = require 'jquery'
Backbone = require 'backbone'
Panel = require './panel.coffee'
uiTemplates = require './../../uiTemplates.coffee'
plugins = require './../../../plugins/plugins.coffee'
components = plugins.components
_ = require 'underscore'

class ArrangementPanel extends Panel
  template: uiTemplates.arrangementPanel

  initialize: (options) ->
    super()
    _.bindAll @, 'render',
      'alignTopHandler',
      'alignRightHandler', 'alignBottomHandler', 'alignLeftHandler',
      'alignCenterHandler', 'alignMiddleHandler', 'inputMouseHandler'
    @previous = {}
    @editor = options.editor if options.editor?
    if @editor?
      @setCollection @editor.get("selection")
    @render()

  alignTopHandler: (e) ->
    e.preventDefault()
    @editor.alignSelectedTop()

  alignRightHandler: (e) ->
    e.preventDefault()
    @editor.alignSelectedRight()

  alignBottomHandler: (e) ->
    e.preventDefault()
    @editor.alignSelectedBottom()

  alignLeftHandler: (e) ->
    e.preventDefault()
    @editor.alignSelectedLeft()

  alignCenterHandler: (e) ->
    e.preventDefault()
    @editor.alignSelectedCenter()

  alignMiddleHandler: (e) ->
    e.preventDefault()
    @editor.alignSelectedMiddle()

  distributeTopHandler: (e) ->
    e.preventDefault()
    @editor.distributeSelectedTop()

  distributeRightHandler: (e) ->
    e.preventDefault()
    @editor.distributeSelectedRight()

  distributeBottomHandler: (e) ->
    e.preventDefault()
    @editor.distributeSelectedBottom()

  distributeLeftHandler: (e) ->
    e.preventDefault()
    @editor.distributeSelectedLeft()

  distributeCenterHandler: (e) ->
    e.preventDefault()
    @editor.distributeSelectedCenter()

  distributeMiddleHandler: (e) ->
    e.preventDefault()
    @editor.distributeSelectedMiddle()

  groupHandler: (e) ->
    e.preventDefault()
    @editor.groupSelected()

  ungroupHandler: (e) ->
    e.preventDefault()
    @editor.ungroupSelected()

  componentizeHandler: (e) ->
    e.preventDefault()
    @editor.componentizeSelected()

  inputMouseHandler: (e) ->
    e.stopPropagation()

  events:
    "click .framer-align-top"     : "alignTopHandler"
    "click .framer-align-right"   : "alignRightHandler"
    "click .framer-align-bottom"  : "alignBottomHandler"
    "click .framer-align-left"    : "alignLeftHandler"
    "click .framer-align-center"  : "alignCenterHandler"
    "click .framer-align-middle"  : "alignMiddleHandler"

    "click .framer-distribute-top"     : "distributeTopHandler"
    "click .framer-distribute-right"   : "distributeRightHandler"
    "click .framer-distribute-bottom"  : "distributeBottomHandler"
    "click .framer-distribute-left"    : "distributeLeftHandler"
    "click .framer-distribute-center"  : "distributeCenterHandler"
    "click .framer-distribute-middle"  : "distributeMiddleHandler"

    "click .framer-group"   : "groupHandler"
    "click .framer-ungroup" : "ungroupHandler"

    "click .framer-componentize" : "componentizeHandler"

module.exports = ArrangementPanel
