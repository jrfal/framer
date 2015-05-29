global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView
setup = require './setups.coffee'
assert = require "assert"
$ = require "jquery"
MenuBar = require '../src/scripts/views/helpers/menubar.coffee'

Page = require '../src/scripts/models/page.coffee'

describe "Rename page with a click", ->
  data = null
  page = null

  before ->
    data = setup.appSetup()
    page = data.app.get("project").get("pages").first()

    data.app_view.renamePage()
    $(".rename-page").val "new page name"
    $(".bbm-button.submit").click()

  it "should be called 'new page name'", ->
    assert.equal page.get("slug"), "new page name"

describe "Rename page with a submit", ->
  data = null
  page = null

  before ->
    data = setup.appSetup()
    page = data.app.get("project").get("pages").first()

    data.app_view.renamePage()
    $(".rename-page").val "new page name"
    $(".bbm-modal form").submit()

  it "should be called 'new page name'", ->
    assert.equal page.get("slug"), "new page name"

describe "Navigate to next page", ->
  data = null
  page = null

  before ->
    data = setup.appSetup()
    data.app.get("project").addPage()
    page = data.app.get("project").get("pages").first()
    menubar = new MenuBar data.app, data.app_view
    menubar.nextPageHandler()

  it "should be showing the second page", ->
    assert.equal data.app_view.projectView.currentPage, data.app.get("project").get("pages").at(1)

describe "Navigate back to first page with next page", ->
  data = null
  page = null

  before ->
    data = setup.appSetup()
    data.app.get("project").addPage()
    page = data.app.get("project").get("pages").first()
    menubar = new MenuBar data.app, data.app_view
    menubar.nextPageHandler()
    menubar.nextPageHandler()

  it "should be showing the first page", ->
    assert.equal data.app_view.projectView.currentPage, data.app.get("project").get("pages").at(0)

describe "Navigate to previous page", ->
  data = null
  page = null

  before ->
    data = setup.appSetup()
    data.app.get("project").addPage()
    page = data.app.get("project").get("pages").first()
    menubar = new MenuBar data.app, data.app_view
    menubar.nextPageHandler()
    menubar.previousPageHandler()

  it "should be showing the first page", ->
    assert.equal data.app_view.projectView.currentPage, data.app.get("project").get("pages").at(0)

describe "Navigate to last page with previous page", ->
  data = null
  page = null

  before ->
    data = setup.appSetup()
    data.app.get("project").addPage()
    page = data.app.get("project").get("pages").first()
    menubar = new MenuBar data.app, data.app_view
    menubar.previousPageHandler()

  it "should be showing the second page", ->
    assert.equal data.app_view.projectView.currentPage, data.app.get("project").get("pages").at(1)
