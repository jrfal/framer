global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView
setup = require './setups.coffee'
assert = require "assert"
$ = require "jquery"
plugins = require '../src/plugins/plugins.coffee'
components = plugins.components

Page = require '../src/scripts/models/page.coffee'

describe "Initial Setup", ->
  data = null
  element = null

  before ->
    data = setup.appSetup()
    element = setup.addElement data.page

    data.app_view.projectView.pageView.editor.selectElement element

  it "should have a property panel icon", ->
    assert.equal $("#wirekit_properties_button").length, 1

  it "should have a pages icon", ->
    assert.equal $("#wirekit_pages_button").length, 1

  it "should have an arrangement icon", ->
    assert.equal $("#wirekit_arrange_button").length, 1

  it "should have the arrangement panel", ->
    assert.equal $("#wg_arrangement_panel").length, 1

  it "should not be showing the property panel", ->
    assert.equal $(".property-panel").css("display"), "none"

describe "Doesn't hit property panel button", ->
  data = null
  element = null

  before ->
    data = setup.appSetup()
    element = setup.addElement data.page

    data.app_view.projectView.pageView.editor.selectElement element

  it "should not be showing the property panel now", ->
    assert.equal $(".property-panel").css("display"), "none"

describe "Hits property panel button", ->
  data = null
  element = null

  before ->
    data = setup.appSetup()
    element = setup.addElement data.page

    data.app_view.projectView.pageView.editor.selectElement element
    $("#wirekit_properties_button").trigger "click"

  it "should be showing the property panel now", ->
    assert.notEqual $(".property-panel").css("display"), "none"

describe "Hits pages panel button", ->
  data = null

  before ->
    data = setup.appSetup()
    $("#wirekit_pages_button").trigger "click"

  it "should be showing the pages panel now", ->
    pagesPanel = $(".pages-panel")
    assert.equal pagesPanel.length, 1
    assert.notEqual pagesPanel.css("display"), "none"

  it "should have one li element in the pages panel", ->
    assert.equal $(".pages-panel li").length, 1

describe "Hits arrangement panel button", ->
  data = null

  before ->
    data = setup.appSetup()
    $("#wirekit_arrange_button").trigger "click"

  it "should be showing the arrangement panel now", ->
    assert.notEqual $("#wg_arrangement_panel").css("display"), "none"

describe "Hits pages panel button twice", ->
  data = null

  before ->
    data = setup.appSetup()
    $("#wirekit_pages_button").trigger "click"
    $("#wirekit_pages_button").trigger "click"

  it "should not be showing the pages panel now", ->
    pagesPanel = $(".pages-panel")
    assert.equal pagesPanel.length, 1
    assert.equal pagesPanel.css("display"), "none"

describe "Add a page", ->
  data = null

  before ->
    data = setup.appSetup()
    data.app.get("project").get("pages").add new Page()

  it "should have 2 elements in the pages property", ->
    assert.equal data.app.get("project").get("pages").length, 2

  it "should have two li elements in the pages panel", ->
    assert.equal $(".pages-panel li").length, 2

  it "should not be showing the pages panel now", ->
    pagesPanel = $(".pages-panel")
    assert.equal pagesPanel.length, 1
    assert.equal pagesPanel.css("display"), "none"

describe "Click a page on the page panel", ->
  data = null
  project = null
  fourthPage = null

  before ->
    data = setup.appSetup()
    firstPage = data.app.get("project").get("pages").first()
    project = data.app.get("project")
    project.get("pages").add new Page()
    project.get("pages").add new Page()
    fourthPage = new Page()
    project.get("pages").add fourthPage
    assert.equal firstPage, data.app_view.projectView.currentPage
    $(".pages-panel li:last a").trigger "click"

  it "should be showing 4th page", ->
    assert.equal fourthPage, data.app_view.projectView.currentPage

describe "Labels on the property panel", ->
  data = null
  element = null

  before ->
    data = setup.appSetup()
    element = setup.addComponent data.page, "rectangle"

    data.app_view.projectView.pageView.editor.selectElement element
    data.app_view.projectView.propertyPanel.show()

  it "should show English labels", ->
    assert.equal $(".property-panel label[for=property-panel-text]").text(), "Text"
    assert.equal $(".property-panel label[for=property-panel-fontSize]").text(), "Font Size"
    assert.equal $(".property-panel label[for=property-panel-fontFamily]").text(), "Font Family"
    assert.equal $(".property-panel label[for=property-panel-fontColor]").text(), "Font Color"
    assert.equal $(".property-panel label[for=property-panel-borderColor]").text(), "Border Color"
    assert.equal $(".property-panel label[for=property-panel-borderWidth]").text(), "Border Width"
    assert.equal $(".property-panel label[for=property-panel-fillColor]").text(), "Fill Color"

describe "Property panel exists without element", ->
  data = null

  before ->
    data = setup.appSetup()

  it "should have the property panel", ->
    assert.equal $(".property-panel").length, 1

describe "Property panel without element", ->
  data = null

  before ->
    data = setup.appSetup()
    $("#wirekit_properties_button").click()

  it "should be showing the property panel", ->
    assert.notEqual $(".property-panel").css("display"), "none"
