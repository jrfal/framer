App = require './models/app.coffee'
AppView = require './views/appView.coffee'

Handlebars = require 'handlebars'
fs = require 'fs'
path = require 'path'
$ = require 'jquery'

app = new App()
app_view = new AppView {model: app}

# build main menu
makeMenu = ->
  main_menu = new global.gui.Menu({ type: 'menubar'})
  try
    main_menu.createMacBuiltin("framer");

  file_menu = new global.gui.Menu()
  file_menu.append new gui.MenuItem({
    label: "New Project",
    click: ->
      app.newProject()
    ,
    key: "n",
    modifiers: "cmd",
  })
  file_menu.append new gui.MenuItem({
    label: "Open File",
    click: ->
      $("#dataFile").click()
    ,
    key: "o",
    modifiers: "cmd",
  })
  file_menu.append new gui.MenuItem({
    label: "Save File",
    click: ->
      $("#saveFile").click()
    ,
    key: "s",
    modifiers: "cmd",
  })
  file_menu.append new gui.MenuItem({
    label: "Change CSS",
    click: ->
      $("#cssFile").click()
  })

  view_menu = new global.gui.Menu()
  view_menu.append new gui.MenuItem({
    label: "Next Page",
    click: ->
      nextPageHandler()
  })
  view_menu.append new gui.MenuItem({
    label: "Show Element Palette",
    click: ->
      showElementPaletteHandler()
  })

  sub_menu = new global.gui.MenuItem({label: 'File'})
  sub_menu.submenu = file_menu
  main_menu.insert(sub_menu, 1)

  sub_menu = new global.gui.MenuItem({label: 'View'})
  sub_menu.submenu = view_menu
  main_menu.append sub_menu

  global.gui.Window.get().menu = main_menu

init = ->
  $("#framer_pages").on 'click', 'a[href^="#"]', ->
    localLinkHandler $(this).attr 'href'

nextPageHandler = ->
  currentPage = $("#framer_pages .framer-page:visible")
  nextPage = $(currentPage).next();
  $("#framer_pages .framer-page").hide()
  if nextPage.length > 0
    $(nextPage).show()
  else
    $("#framer_pages .framer-page:first-child").show()

showElementPaletteHandler = ->
  app.showElementPalette()

localLinkHandler = (href) ->
  targetPage = $("#{href}")
  if targetPage.length > 0
    $("#framer_pages .framer-page").hide()
    $(targetPage).show()
    controlBox.renderControls()

module.exports = app

makeMenu()
init()
