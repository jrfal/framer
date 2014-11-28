App = require './models/app.coffee'
AppView = require './views/appView.coffee'

Handlebars = require 'handlebars'
fs = require 'fs'
path = require 'path'
$ = require 'jquery'

app = new App()
app_view = new AppView {model: app}

global.plugins = require './plugins.coffee'

# build main menu
makeMenu = ->
  main_menu = new global.gui.Menu({ type: 'menubar'})
  try
    main_menu.createMacBuiltin "framer", {hideEdit:true}

  file_menu = new global.gui.Menu()
  file_menu.append new gui.MenuItem({
    label: "New Project",
    click: ->
      app_view.newProjectCmd()
    ,
    key: "n",
    modifiers: "cmd",
  })
  file_menu.append new gui.MenuItem({
    label: "Open File",
    click: ->
      app_view.loadFileCmd()
    ,
    key: "o",
    modifiers: "cmd",
  })
  file_menu.append new gui.MenuItem({
    label: "Save File",
    click: ->
      app_view.saveFileCmd()
    ,
    key: "s",
    modifiers: "cmd",
  })
  file_menu.append new gui.MenuItem({
    label: "Change CSS",
    click: ->
      $("#cssFile").click()
  })

  edit_menu = new global.gui.Menu()
  edit_menu.append new gui.MenuItem({
    label: "Select All",
    click: ->
      selectAllHandler()
    key: "a",
    modifiers: "cmd"
  })

  pages_menu = new global.gui.Menu()
  pages_menu.append new gui.MenuItem({
    label: "Add New Page",
    click: ->
      newPageHandler()
    key: "p",
    modifiers: "cmd"
  })
  pages_menu.append new gui.MenuItem({
    label: "Next Page",
    click: ->
      nextPageHandler()
  })

  view_menu = new global.gui.Menu()
  view_menu.append new gui.MenuItem({
    label: "Show Element Palette",
    click: ->
      showElementPaletteHandler()
  })

  sub_menu = new global.gui.MenuItem({label: 'File'})
  sub_menu.submenu = file_menu
  main_menu.insert(sub_menu, 1)

  sub_menu = new global.gui.MenuItem({label: 'Edit'})
  sub_menu.submenu = edit_menu
  main_menu.insert(sub_menu, 2)

  sub_menu = new global.gui.MenuItem({label: 'View'})
  sub_menu.submenu = view_menu
  main_menu.append sub_menu

  sub_menu = new global.gui.MenuItem({label: 'Pages'})
  sub_menu.submenu = pages_menu
  main_menu.append sub_menu

  global.gui.Window.get().menu = main_menu

init = ->
  $("#framer_pages").on 'click', 'a[href^="#"]', ->
    localLinkHandler $(this).attr 'href'

newPageHandler = ->
  app_view.projectView.showPage app.get('project').addPage()

nextPageHandler = ->
  index = 1 + app.get('project').get('pages').models.indexOf(app_view.projectView.currentPage)
  index = 0 if index >= app.get('project').get('pages').size()
  app_view.projectView.showPage app.get('project').get('pages').at(index)

showElementPaletteHandler = ->
  app.showElementPalette()

selectAllHandler = ->
  app_view.projectView.pageView.controlLayer.selectAll()

localLinkHandler = (href) ->
  targetPage = $("#{href}")
  if targetPage.length > 0
    $("#framer_pages .framer-page").hide()
    $(targetPage).show()
    controlBox.renderControls()

module.exports = {app: app, app_view: app_view}

makeMenu()
init()
