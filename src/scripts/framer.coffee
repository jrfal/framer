require './views/appView.coffee'

Handlebars = require 'handlebars'
fs = require 'fs'
path = require 'path'
$ = require 'jquery'
# controlBox = require './controlBox.coffee'

# build main menu
makeMenu = ->
  main_menu = new global.gui.Menu({ type: 'menubar'})
  # main_menu.createMacBuiltin("framer");

  file_menu = new global.gui.Menu()
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

  # $("#framer_controls").on 'dragstart', '.control-box', controlBox.controlDragHandler
  # $("#framer_controls").on 'dragend', '.control-box', controlBox.controlDragStopHandler
  #
  # $("#framer_controls").on 'dragstart', '.control-box .resize-handle', controlBox.resizeDragHandler
  # $("#framer_controls").on 'dragend', '.control-box .resize-handle', controlBox.resizeDragStopHandler
  #
  # $("#framer_controls").on 'click', '.control-box .text-edit-handle', controlBox.textEditHandler
  # $("#framer_controls").on 'click', '.text-update .cancel', (e) ->
  #   $(e.target).closest('.framer-modal').remove()
  # $("#framer_controls").on 'click', '.text-update .save', (e) ->
  #   input = $(e.target).closest('.text-update').find('input[type="text"].content')
  #   newText = input.val()
  #   controlBox.updateText input.data("element"), newText
  #
  #   input = $(e.target).closest('.text-update').find('input[type="text"].font-family')
  #   newFont = input.val()
  #   if newFont != ''
  #     controlBox.updateFontFamily input.data("element"), newFont
  #
  #   input = $(e.target).closest('.text-update').find('input[type="text"].font-size')
  #   newSize = input.val()
  #   if newSize != ''
  #     controlBox.updateFontSize input.data("element"), newSize
  #
  #   $(e.target).closest('.framer-modal').remove()

  # $("body").on 'dragover', (e) ->
  #   e.preventDefault()
  #
  # $("body").on 'drop', controlBox.controlDropHandler

makeMenu()
init()

nextPageHandler = ->
  currentPage = $("#framer_pages .framer-page:visible")
  nextPage = $(currentPage).next();
  $("#framer_pages .framer-page").hide()
  if nextPage.length > 0
    $(nextPage).show()
  else
    $("#framer_pages .framer-page:first-child").show()

localLinkHandler = (href) ->
  targetPage = $("#{href}")
  if targetPage.length > 0
    $("#framer_pages .framer-page").hide()
    $(targetPage).show()
    controlBox.renderControls()
