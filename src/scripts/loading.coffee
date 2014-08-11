Handlebars = require 'handlebars'
framer = require './framer.coffee'
controlBox = require './controlBox.coffee'
fs = require 'fs'
path = require 'path'
$ = require 'jquery'

projectObj = ''

loadFile = (filename) ->
  try
    project = JSON.parse(fs.readFileSync(filename).toString())
  catch
    return

  projectObj = project

  if "pages" of project
    pages = project.pages
  else
    pages = []

  pageEls = []
  for page in pages
    elements = page.elements
    pageEl = $ "<div class=\"framer-page\" id=\"#{page.slug}\"></div>"

    for data in elements
      source = "{{> #{data.template}}}"
      template = Handlebars.compile(source)

      pageEl.append template(data)

    $(pageEl).hide()
    pageEls.push pageEl

  $("#framer_pages").empty()
  $("#framer_pages").append pageEl for pageEl in pageEls
  if pageEls.length > 0
    $(pageEls[0]).show()
    controlBox.renderControls()

  if ("css" of project)
    $("#cssLink").attr "href", path.dirname(filename) + project.css

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
