global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView
setup = require './setups.coffee'
assert = require "assert"
$ = require "jquery"

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
