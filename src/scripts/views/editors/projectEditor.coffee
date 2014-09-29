$ = require 'jquery'
Backbone = require 'backbone'
ProjectView = require './../project.coffee'
PageEditor = require './pageEditor.coffee'
uiTemplates = require './../../uiTemplates.coffee'
_ = require 'underscore'

class ProjectEditor extends ProjectView
  newPageView: ->
    return new PageEditor()

module.exports = ProjectEditor
