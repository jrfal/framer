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

describe "Create a checkbox", ->
  data = setup.appSetup()
  $("body").append $(data.app_view.projectView.pageView.el)

  element = setup.addComponent data.page, "checkbox"

  it "should be an input[type=checkbox] element", ->
    assert.equal $("input[type=checkbox]").length, 1

  it "should be indeterminate if I set it that way", ->
    element.set "indeterminate", true
    assert $("input[type=checkbox]").prop("indeterminate")

describe "Create a text input", ->
  data = setup.appSetup()
  $("body").append data.app_view.projectView.pageView.el

  element = setup.addComponent data.page, "text-input"

  it "should be an input[type=text] element", ->
    assert.equal $("input[type=text]").length, 1
