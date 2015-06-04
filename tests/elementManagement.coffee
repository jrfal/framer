global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView

assert = require "assert"
App = require '../src/scripts/models/app.coffee'
AppView = require "../src/scripts/views/appView.coffee"
MenuBar = require '../src/scripts/views/helpers/menubar.coffee'
Page = require "../src/scripts/models/page.coffee"
Element = require "../src/scripts/models/element.coffee"

plugins = require '../src/plugins/plugins.coffee'
components = plugins.components

setup = require './setups.coffee'

$ = require 'jquery'

describe "Create element and remove element", ->
  page = new Page()
  element = new Element()
  page.addElement element
  assert.equal page.get("elements").length, 1
  element.removeFromParent()

  it "should have zero elements in the page", ->
    assert.equal page.get("elements").length, 0

describe "Create and copy element", ->
  data = setup.appSetup()
  menubar = new MenuBar data.app, data.app_view

  element = setup.addComponent data.page, "rectangle"

  data.editor.selectElement element
  menubar.copyHandler()

  reference = _.findWhere components, {component: "rectangle"}

  menubar.pasteHandler()

  it "should have the appropriate object representation in the clipboard", ->
    assert.deepEqual [reference], JSON.parse([menubar.clipboard.get()])

  it "should have two objects on the page", ->
    assert.equal 2, data.page.get("elements").length

describe "Create and cut element", ->
  data = setup.appSetup()
  menubar = new MenuBar data.app, data.app_view

  element = setup.addComponent data.page, "rectangle"

  data.editor.selectElement element
  menubar.cutHandler()

  reference = _.findWhere components, {component: "rectangle"}

  it "should have no selected items", ->
    assert.equal data.editor.get("selection").size(), 0

describe "Create, cut, and paste element", ->
  data = setup.appSetup()
  menubar = new MenuBar data.app, data.app_view

  element = setup.addComponent data.page, "rectangle"

  data.editor.selectElement element
  menubar.cutHandler()

  reference = _.findWhere components, {component: "rectangle"}

  menubar.pasteHandler()

  it "should have the appropriate object representation in the clipboard", ->
    assert.deepEqual [reference], JSON.parse([menubar.clipboard.get()])

  it "should have one object on the page", ->
    assert.equal 1, data.page.get("elements").length

describe "Create and duplicate element", ->
  data = setup.appSetup()
  menubar = new MenuBar data.app, data.app_view

  element = setup.addComponent data.page, "rectangle"

  data.editor.selectElement element
  menubar.duplicateHandler()

  it "should have two objects on the page", ->
    assert.equal 2, data.page.get("elements").length

describe "Create two elements", ->
  data = null
  element = null
  element2 = null

  before ->
    data = setup.appSetup()
    element = setup.addComponent data.page, "rectangle"
    element2 = setup.addComponent data.page, "rectangle"

  it "should have put the second element in front of the first", ->
    pageView = data.app_view.projectView.pageView
    assert $(pageView.getElementView(element2).el).index() > $(pageView.getElementView(element).el).index()

  it "should have the control box for the second in front of the first", ->
    first = $ "#framer_controls .control-box[data-element=#{element.get("id")}]"
    second = $ "#framer_controls .control-box[data-element=#{element2.get("id")}]"
    assert second.index() > first.index()
