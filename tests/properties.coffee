global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView
$ = require 'jquery'

assert = require "assert"
Page = require "../src/scripts/models/page.coffee"
Element = require "../src/scripts/models/element.coffee"

plugins = require '../src/plugins/plugins.coffee'
components = plugins.components

setup = require './setups.coffee'

describe "Show property panel for paragraph text", ->
  data = null
  element = null

  before ->
    data = setup.appSetup()
    element = setup.addComponent data.page, "textBlock"
    data.app_view.projectView.pageView.editor.selectElement element

  it "should have a number field for font size", ->
    assert.equal $("#property-panel-fontSize").attr("type"), "number"
