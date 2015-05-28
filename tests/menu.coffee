global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView
setup = require './setups.coffee'

assert = require "assert"
plugins = require '../src/plugins/plugins.coffee'
components = plugins.components

MenuBar = require '../src/scripts/views/helpers/menubar.coffee'

_ = require 'underscore'
$ = require 'jquery'

describe "Toggle Element Palette", ->
  data = null
  menu = null

  before ->
    data = setup.appSetup()
    menubar = new MenuBar data.app, data.app_view

    data.app.showElementPalette()
    menubar.showelementpalette_menuitem = {checked: false}
    menubar.toggleElementPaletteHandler()

  it "should not be showing the element palette", ->
    palette = $ '#framer_elementPalette'
    assert.equal palette.css("display"), "none"

describe "Toggle Element Palette Twice", ->
  data = null
  menu = null

  before ->
    data = setup.appSetup()
    menubar = new MenuBar data.app, data.app_view

    data.app.showElementPalette()
    menubar.showelementpalette_menuitem = {checked: false}
    menubar.toggleElementPaletteHandler()
    menubar.showelementpalette_menuitem = {checked: true}
    menubar.toggleElementPaletteHandler()

  it "should be showing the element palette", ->
    palette = $ '#framer_elementPalette'
    assert.notEqual palette.css("display"), "none"
