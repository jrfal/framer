global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView
$ = require 'jquery'

assert = require "assert"
Page = require "../src/scripts/models/page.coffee"
Element = require "../src/scripts/models/element.coffee"
MenuBar = require '../src/scripts/views/helpers/menubar.coffee'

plugins = require '../src/plugins/plugins.coffee'
components = plugins.components

setup = require './setups.coffee'

# describe "Set up app and zoom in", ->
#   data = setup.appSetup()
#   menubar = new MenuBar data.app, data.app_view
#
#   menubar.zoomInHandler()
