global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView

assert = require "assert"
App = require '../src/scripts/models/app.coffee'
AppView = require "../src/scripts/views/appView.coffee"
MenuBar = require '../src/scripts/views/helpers/menubar.coffee'
Element = require "../src/scripts/models/element.coffee"

describe "Selecting none", ->
  app = new App()
  app_view = new AppView {model: app}
  menubar = new MenuBar app, app_view
  page = app.get("project").get("pages").first()

  element = new Element()
  page.addElement element

  element2 = new Element()
  page.addElement element2

  editor = app_view.projectView.pageView.editor

  editor.selectElement element
  editor.selectElement element2

  assert.equal editor.get("selection").length, 2

  menubar.deselectHandler()

  it "should have none selected", ->
    assert.equal editor.get("selection").length, 0
