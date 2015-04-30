$ = require 'jquery'
Backbone = require 'backbone'
# Backbone.$ = $
_ = require 'underscore'
fs = require 'fs'
path = require 'path'

Project = require './project.coffee'
Page = require './page.coffee'
Element = require './element.coffee'

Guide = require './guide.coffee'

class App extends Backbone.Model
  initialize: ->
    _.bindAll @, 'saveSettings', 'updateGrid'
    settings = new Backbone.Model {elementPalette: true, gridLines: true, gridCellSize: 8, gridCellGroup: 10, snapping: true}
    @set 'settings', settings
    @loadSettings()
    settings.on "change", @saveSettings
    @newProject()

    @grid = new Guide.Grid({cellSize: settings.get('gridCellSize'), cellGroup: settings.get('gridCellGroup')})
    settings.on "change:gridCellSize change:gridCellGroup", @updateGrid

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
      if typeof page == 'object'
        pageModel = new Page()
        if 'slug' of page
          pageModel.set 'slug', page.slug
        if 'title' of page
          pageModel.set 'title', page.title
        pageModels.add pageModel

        elements = page.elements
        for data in elements
          pageModel.addElement data

    # if ("css" of attributes)
    #   $("#cssLink").attr "href", path.dirname(filename)+ '/' + attributes.css

    @set 'project', projectModel

  saveFile: (filename) ->
    projectObj = @get('project').saveObject()
    fs.writeFile(filename, JSON.stringify(projectObj, null, "\t"))
    @trigger 'savedProject'

  showElementPalette: ->
    @get('settings').set 'elementPalette', true

  hideElementPalette: ->
    @get('settings').set 'elementPalette', false

  showGridLines: ->
    @get('settings').set 'gridLines', true

  hideGridLines: ->
    @get('settings').set 'gridLines', false

  setSnapping: (value) ->
    @get('settings').set 'snapping', value

  updateGrid: ->
    settings = @get 'settings'
    @grid.set {cellSize: settings.get('gridCellSize'), cellGroup: settings.get('gridCellGroup')}

  saveSettings: ->
    content = JSON.stringify(@get('settings').attributes)
    fs.writeFile(global.cfg.settings, content)

  loadSettings: (filename) ->
    if not filename?
      filename = global.cfg.settings
    fileContents = fs.readFileSync(filename).toString()
    @set 'settings', @get('settings').set(JSON.parse(fileContents))

module.exports = App
