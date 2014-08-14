Handlebars = require 'handlebars'
framer = require './framer.coffee'
controlBox = require './controlBox.coffee'
fs = require 'fs'
path = require 'path'
$ = require 'jquery'
templates = require './componentTemplates.coffee'
Project = require './models/project.coffee'
Page = require './models/page.coffee'
Element = require './models/element.coffee'

projectObj = ''

loadFile = (filename) ->
  try
    project = JSON.parse(fs.readFileSync(filename).toString())
  catch
    return

  projectModel = new Project()
  pageModels = projectModel.get 'pages'

  projectObj = project

  if "pages" of project
    pages = project.pages
  else
    pages = []

  pageEls = []
  for page in pages
    pageModel = new Page()
    pageModels.add pageModel
    elementModels = pageModel.get 'elements'

    elements = page.elements
    # pageEl = $ "<div class=\"framer-page\" id=\"#{page.slug}\"></div>"

    for data in elements
      elementModel = new Element(data)
      elementModels.add elementModel

      # template = templates.getTemplate data.template
      # pageEl.append template(data)

    # $(pageEl).hide()
    # pageEls.push pageEl

  # $("#framer_pages").empty()
  # $("#framer_pages").append pageEl for pageEl in pageEls
  # if pageEls.length > 0
  #   $(pageEls[0]).show()
  #   controlBox.renderControls()
  #
  if ("css" of project)
    $("#cssLink").attr "href", path.dirname(filename)+ '/' + project.css

# trigger file load
$("#dataFile").change ->
  loadFile $("#dataFile").val()

# trigger css file load
$("#cssFile").change ->
  cssFile = $("#cssFile").val()

  $("#cssLink").attr "href", cssFile

saveFile = (filename) ->
  fs.writeFile(filename, JSON.stringify(projectObj))

# trigger file save
$("#saveFile").change ->
  saveFile $("#saveFile").val()

module.exports.loadFile = loadFile
module.exports.saveFile = saveFile
