$ = require 'jquery'
Backbone = require 'backbone'
# Backbone.$ = $
_ = require 'underscore'
fs = require 'fs'
path = require 'path'

Project = require './project.coffee'
Page = require './page.coffee'
Element = require './element.coffee'

class App extends Backbone.Model
  defaults:
    project: new Project()
  initialize: ->
    # _.bindAll @, 'set'
    true

  loadFile: (filename) ->
    try
      project = JSON.parse(fs.readFileSync(filename).toString())
    catch
      return

    projectModel = new Project()
    pageModels = projectModel.get 'pages'

    if "pages" of project
      pages = project.pages
    else
      pages = []

    for page in pages
      pageModel = new Page()
      pageModels.add pageModel
      elementModels = pageModel.get 'elements'

      elements = page.elements
      for data in elements
        elementModel = new Element(data)
        elementModels.add elementModel

    if ("css" of project)
      $("#cssLink").attr "href", path.dirname(filename)+ '/' + project.css

    @set 'project', projectModel

module.exports = App
