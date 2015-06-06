global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView

assert = require "assert"
Page = require "../src/scripts/models/page.coffee"
Element = require "../src/scripts/models/element.coffee"
Group = require "../src/scripts/models/group.coffee"
Editor = require "../src/scripts/models/editor.coffee"

PageEditor = require "../src/scripts/views/editors/pageEditor.coffee"
ElementView = require "../src/scripts/views/element.coffee"

setup = require './setups.coffee'

$ = require 'jquery'

describe "Distribute by gaps", ->
  data = null
  page = null
  element1 = null
  element2 = null
  element3 = null
  editor = null

  before ->
    data = setup.appSetup()
    editor = data.app_view.projectView.pageView.editor

    element1 = setup.addComponent data.page, "rectangle"
    element1.set {x: 12, y: 37, w: 231, h: 178}
    element2 = setup.addComponent data.page, "rectangle"
    element2.set {x: 97, y: 203, w: 10, h: 121}
    element3 = setup.addComponent data.page, "rectangle"
    element3.set {x: 74, y: 1000, w: 401, h: 56}

    editor.selectElement element1
    editor.selectElement element2
    editor.selectElement element3
    editor.distributeSelectedHorizontalGaps()
    editor.distributeSelectedVerticalGaps()

  it "should have distributed the three objects horizontally and vertically", ->
    assert.equal element1.get("x"), 12
    assert.equal element1.get("y"), 37

    assert.equal element2.get("x"), 153.5
    assert.equal element2.get("y"), 547

    assert.equal element3.get("x"), 74
    assert.equal element3.get("y"), 1000

describe "Use buttons to distribute by gaps", ->
  data = null
  page = null
  element1 = null
  element2 = null
  element3 = null
  editor = null

  before ->
    data = setup.appSetup()
    editor = data.app_view.projectView.pageView.editor

    element1 = setup.addComponent data.page, "rectangle"
    element1.set {x: 12, y: 37, w: 231, h: 178}
    element2 = setup.addComponent data.page, "rectangle"
    element2.set {x: 97, y: 203, w: 10, h: 121}
    element3 = setup.addComponent data.page, "rectangle"
    element3.set {x: 74, y: 1000, w: 401, h: 56}

    editor.selectElement element1
    editor.selectElement element2
    editor.selectElement element3
    $(".framer-distribute-hgaps").trigger "click"
    $(".framer-distribute-vgaps").trigger "click"

  it "should have distributed the three objects horizontally and vertically", ->
    assert.equal element1.get("x"), 12
    assert.equal element1.get("y"), 37

    assert.equal element2.get("x"), 153.5
    assert.equal element2.get("y"), 547

    assert.equal element3.get("x"), 74
    assert.equal element3.get("y"), 1000
