App = require './models/app.coffee'
AppView = require './views/appView.coffee'

Handlebars = require 'handlebars'
fs = require 'fs'
path = require 'path'
$ = require 'jquery'

app = new App()
app_view = new AppView {model: app}

global.plugins = require './plugins.coffee'
MenuBar = require './views/helpers/menubar.coffee'

init = ->
  $("#framer_pages").on 'click', 'a[href^="#"]', ->
    localLinkHandler $(this).attr 'href'

localLinkHandler = (href) ->
  targetPage = $("#{href}")
  if targetPage.length > 0
    $("#framer_pages .framer-page").hide()
    $(targetPage).show()
    controlBox.renderControls()

module.exports = {app: app, app_view: app_view}

menubar = new MenuBar app, app_view

init()
