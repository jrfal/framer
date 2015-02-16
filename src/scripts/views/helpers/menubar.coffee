_ = require 'underscore'

class MenuBar
  constructor: (app, app_view) ->
    _.bindAll @, 'toggleGridLinesHandler', 'showElementPaletteHandler', 'newPageHandler',
      'newProjectHandler', 'loadFileHandler', 'saveFileHandler', 'selectAllHandler',
      'nextPageHandler', 'renamePageHandler', 'updateShowGridCheck', 'editGridHandler',
      'toggleSnappingHandler', 'updateSnapping', 'setMasterPageHandler'
    @app = app
    @app_view = app_view
    @main_menu = new global.gui.Menu({ type: 'menubar'})
    try
      @main_menu.createMacBuiltin "framer", {hideEdit:true}

    file_menu = new global.gui.Menu()
    file_menu.append new gui.MenuItem({
      label: "New Project",
      click: @newProjectHandler
      key: "n",
      modifiers: "cmd",
    })
    file_menu.append new gui.MenuItem({
      label: "Open File",
      click: @loadFileHandler,
      key: "o",
      modifiers: "cmd",
    })
    file_menu.append new gui.MenuItem({
      label: "Save File",
      click: @saveFileHandler,
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
      click: @selectAllHandler
      key: "a",
      modifiers: "cmd"
    })
    @snapping_menuitem = new gui.MenuItem({
      type: "checkbox",
      label: "Snapping",
      checked: true,
      click: @toggleSnappingHandler
    })
    edit_menu.append @snapping_menuitem

    pages_menu = new global.gui.Menu()
    pages_menu.append new gui.MenuItem({
      label: "Add New Page",
      click: @newPageHandler
      key: "p",
      modifiers: "cmd"
    })
    pages_menu.append new gui.MenuItem({
      label: "Next Page",
      click: @nextPageHandler
    })
    pages_menu.append new gui.MenuItem({
      label: "Rename Page",
      click: @renamePageHandler
    })
    pages_menu.append new gui.MenuItem({
      label: "Set Master Page",
      click: @setMasterPageHandler
    })

    view_menu = new global.gui.Menu()
    @showgrid_menuitem = new gui.MenuItem({
      type: "checkbox",
      label: "Show Grid",
      checked: true,
      click: @toggleGridLinesHandler
    })
    view_menu.append @showgrid_menuitem
    view_menu.append new gui.MenuItem({
      label: "Edit Grid",
      click: @editGridHandler
    })
    view_menu.append new gui.MenuItem({
      label: "Show Element Palette",
      click: @showElementPaletteHandler
    })

    sub_menu = new global.gui.MenuItem({label: 'File'})
    sub_menu.submenu = file_menu
    @main_menu.insert(sub_menu, 1)

    sub_menu = new global.gui.MenuItem({label: 'Edit'})
    sub_menu.submenu = edit_menu
    @main_menu.insert(sub_menu, 2)

    sub_menu = new global.gui.MenuItem({label: 'View'})
    sub_menu.submenu = view_menu
    @main_menu.append sub_menu

    sub_menu = new global.gui.MenuItem({label: 'Pages'})
    sub_menu.submenu = pages_menu
    @main_menu.append sub_menu

    global.gui.Window.get().menu = @main_menu

    if not @app.get('settings').get('gridLines')
      @updateShowGridCheck null, false
    @app.get('settings').on "change:gridLines", @updateShowGridCheck

    if not @app.get('settings').get('snapping')
      @updateSnapping null, false
    @app.get('settings').on "change:snapping", @updateSnapping

  updateShowGridCheck: (model, value) ->
    if value
      @showgrid_menuitem.checked = true
    else
      @showgrid_menuitem.checked = false

  updateSnapping: (model, value) ->
    if value
      @snapping_menuitem.checked = true
    else
      @snapping_menuitem.checked = false

  editGridHandler: ->
    @app_view.editGrid()

  newPageHandler: ->
    @app_view.projectView.showPage @app.get('project').addPage()

  nextPageHandler: ->
    index = 1 + @app.get('project').get('pages').models.indexOf(@app_view.projectView.currentPage)
    index = 0 if index >= @app.get('project').get('pages').size()
    @app_view.projectView.showPage @app.get('project').get('pages').at(index)

  renamePageHandler: ->
    @app_view.renamePage()

  setMasterPageHandler: ->
    @app_view.setMasterPage()

  toggleGridLinesHandler: ->
    if @showgrid_menuitem.checked
      @app.showGridLines()
    else
      @app.hideGridLines()

  showElementPaletteHandler: ->
    @app.showElementPalette()

  selectAllHandler: ->
    @app_view.projectView.pageView.controlLayer.selectAll()

  toggleSnappingHandler: ->
    @app.setSnapping @snapping_menuitem.checked

  newProjectHandler: ->
    @app_view.newProjectCmd()

  loadFileHandler: ->
    @app_view.loadFileCmd()

  saveFileHandler: ->
    @app_view.saveFileCmd()


module.exports = MenuBar
