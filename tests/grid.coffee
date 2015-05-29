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

describe "Showing the grid in a color", ->
  data = null

  before ->
    data = setup.appSetup()
    data.app.get('settings').set 'gridLines', true
    data.app.get('settings').set 'gridLinesColor', "#00ff00"

  it "should be showing the grid", ->
    assert.notEqual $("#framer_grid").css("display"), "none"

  it "should be a green grid", ->
    assert.equal $("#grid path").attr("stroke"), "#00ff00"
    assert.equal $("#smallGrid path").attr("stroke"), "#00ff00"

describe "Not showing the grid", ->
  data = null

  before ->
    data = setup.appSetup()
    data.app.get('settings').set 'gridLines', false

  it "should not be showing the grid", ->
    assert.equal $("#framer_grid").css("display"), "none"
