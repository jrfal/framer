global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView
setup = require './setups.coffee'
assert = require "assert"
$ = require "jquery"

describe "Initial Setup", ->
  data = null
  element = null

  before ->
    data = setup.appSetup()
    element = setup.addElement data.page

    data.app_view.projectView.pageView.editor.selectElement element

  it "should have a property panel icon", ->
    assert.equal $("#wirekit_properties_button").length, 1

  it "should be showing the property panel", ->
    assert.equal $(".property-panel.showing").length, 1

describe "Hits property panel button", ->
  data = null
  element = null

  before ->
    data = setup.appSetup()
    element = setup.addElement data.page

    data.app_view.projectView.pageView.editor.selectElement element
    $("#wirekit_properties_button").trigger "click"

  it "should not be showing the property panel now", ->
    assert.equal $(".property-panel.showing").length, 0
