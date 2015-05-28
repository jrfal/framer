_ = require 'underscore'

class MenuBar
  constructor: (app, app_view) ->
    _.bindAll @, 'toggleGridLinesHandler', 'toggleElementPaletteHandler', 'newPageHandler',
      'newProjectHandler', 'loadFileHandler', 'saveFileHandler', 'selectAllHandler',
      'deselectHandler', 'nextPageHandler', 'renamePageHandler', 'updateShowGridCheck',
      'editGridHandler', 'toggleSnappingHandler', 'updateSnapping', 'setMasterPageHandler',
      'copyHandler', 'cutHandler', 'pasteHandler', 'duplicateHandler', 'zoomInHandler',
      'zoomOutHandler'
    @app = app
    @app_view = app_view
    if global.gui?
      @initMenu()

      @clipboard = global.gui.Clipboard.get()
    else
      @clipboard = new FakeClipboard()


  initMenu: ->
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
      label: "Copy"
      click: @copyHandler
      key: "c"
      modifiers: "cmd"
    })
    edit_menu.append new gui.MenuItem({
      label: "Cut"
      click: @cutHandler
      key: "x"
      modifiers: "cmd"
    })
    edit_menu.append new gui.MenuItem({
      label: "Paste"
      click: @pasteHandler
      key: "v"
      modifiers: "cmd"
    })
    edit_menu.append new gui.MenuItem({
      label: "Duplicate"
      click: @duplicateHandler
      key: "d"
      modifiers: "cmd"
    })
    edit_menu.append new gui.MenuItem({
      label: "Select All",
      click: @selectAllHandler
      key: "a",
      modifiers: "cmd"
    })
    edit_menu.append new gui.MenuItem({
      label: "Deselect",
      click: @deselectHandler
      key: "a",
      modifiers: "cmd-shift"
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
    @showelementpalette_menuitem = new gui.MenuItem({
      type: "checkbox",
      label: "Show Element Palette",
      click: @toggleElementPaletteHandler,
      key: "1"
    })
    view_menu.append @showelementpalette_menuitem
    view_menu.append new gui.MenuItem({
      label: "Zoom In",
      click: @zoomInHandler,
      key: "+"
    })
    view_menu.append new gui.MenuItem({
      label: "Zoom Out",
      click: @zoomOutHandler,
      key: "-"
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

  toggleElementPaletteHandler: ->
    if @showelementpalette_menuitem.checked
      @app.showElementPalette()
    else
      @app.hideElementPalette()

  selectAllHandler: ->
    @app_view.projectView.pageView.controlLayer.selectAll()

  deselectHandler: ->
    @app_view.projectView.pageView.editor.unselectAll()

  toggleSnappingHandler: ->
    @app.setSnapping @snapping_menuitem.checked

  newProjectHandler: ->
    @app_view.newProjectCmd()

  loadFileHandler: ->
    @app_view.loadFileCmd()

  saveFileHandler: ->
    @app_view.saveFileCmd()

  copyHandler: ->
    activeElement = global.window.document.activeElement
    if global.window.getSelection?
      textSelection = global.window.getSelection().toString()
    else
      textSelection = ""
    if activeElement?
      if textSelection != "" or activeElement.tagName == "INPUT" or activeElement.tagName == "TEXTAREA"
        @clipboard.set textSelection
        return

    selection = @app_view.projectView.pageView.editor.selectedData()
    @clipboard.set JSON.stringify(selection)

  pasteText: (text) ->
    activeElement = global.window.document.activeElement
    if activeElement?
      if activeElement.tagName == "INPUT" or activeElement.tagName == "TEXTAREA"
        startPos = 0
        endPos = 0
        if activeElement.selectionStart?
          startPos = activeElement.selectionStart
          endPos = activeElement.selectionEnd
        activeElement.value = activeElement.value.substring(0, startPos)+text+activeElement.value.substring(endPos,activeElement.value.length);
        activeElement.selectionStart = startPos + text.length
        activeElement.selectionEnd = activeElement.selectionStart
        return true

    false

  cutHandler: ->
    @copyHandler()
    activeElement = global.window.document.activeElement
    if activeElement? and global.window.getSelection?
      textSelection = global.window.getSelection().toString()
      if textSelection != "" or activeElement.tagName == "INPUT" or activeElement.tagName == "TEXTAREA"
        @pasteText ""
        return

    @app_view.projectView.pageView.editor.deleteSelected()

  pasteHandler: ->
    pasteElement = true
    try
      data = JSON.parse @clipboard.get()
    catch e
      data = @clipboard.get()
      pasteElement = false

    if @pasteText data
      return

    if pasteElement
      for item in data
        @app_view.projectView.pageView.model.addElement item

  duplicateHandler: ->
    data = @app_view.projectView.pageView.editor.selectedData()
    for item in data
      @app_view.projectView.pageView.model.addElement item

  zoomInHandler: ->
    @app_view.projectView.pageView.zoomIn()

  zoomOutHandler: ->
    @app_view.projectView.pageView.zoomOut()

class FakeClipboard
  data: ''

  set: (data) ->
    @data = data

  get: ->
    return @data


module.exports = MenuBar
