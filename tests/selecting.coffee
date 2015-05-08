global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView

assert = require "assert"
App = require '../src/scripts/models/app.coffee'
AppView = require "../src/scripts/views/appView.coffee"
MenuBar = require '../src/scripts/views/helpers/menubar.coffee'
Element = require "../src/scripts/models/element.coffee"

setup = require './setups.coffee'

describe "Selecting none", ->
  data = setup.appSetup()
  menubar = new MenuBar data.app, data.app_view

  element = setup.addElement data.page
  element2 = setup.addElement data.page

  data.editor.selectElement element
  data.editor.selectElement element2

  assert.equal data.editor.get("selection").length, 2

  menubar.deselectHandler()

  it "should have none selected", ->
    assert.equal data.editor.get("selection").length, 0
