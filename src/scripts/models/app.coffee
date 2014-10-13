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
    elementPalette: true

  initialize: ->
    @newProject()

  newProject: ->
    newProject = new Project()
    newProject.addPage()
    @set 'project', newProject

  loadFile: (filename) ->
    if (!fs.existsSync(filename))
      @trigger('error', {type: 'no file'})
      return
    try
      fileContents = fs.readFileSync(filename).toString()
    catch
      @trigger('error', {type: 'file problem'})
      return

    try
      attributes = JSON.parse(fileContents)
    catch
      @trigger('error', {type: 'bad file'})
      return

    pages = []
    if ('pages' of attributes)
      pages = attributes.pages
      delete attributes.pages

    projectModel = new Project(attributes)
    pageModels = projectModel.get 'pages'

    for page in pages
      pageModel = new Page()
      if 'slug' of page
        pageModel.set 'slug', page.slug
      if 'title' of page
        pageModel.set 'title', page.title
      pageModels.add pageModel

      elements = page.elements
      for data in elements
        pageModel.addElement data

    if ("css" of attributes)
      $("#cssLink").attr "href", path.dirname(filename)+ '/' + attributes.css

    @set 'project', projectModel

  saveFile: (filename) ->
    projectString = JSON.stringify(@get 'project')
    projectObj = JSON.parse(projectString)
    if 'pages' of projectObj and projectObj?
      for page in projectObj.pages
        if 'elements' of page and page?
          for element in page.elements
            delete element.id
    fs.writeFile(filename, JSON.stringify(projectObj, null, "\t"))

  showElementPalette: ->
    @set 'elementPalette', true

  hideElementPalette: ->
    @set 'elementPalette', false

module.exports = App
