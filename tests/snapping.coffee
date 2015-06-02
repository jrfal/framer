global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView

assert = require "assert"
Page = require "../src/scripts/models/page.coffee"
Element = require "../src/scripts/models/element.coffee"
Group = require "../src/scripts/models/group.coffee"
Editor = require "../src/scripts/models/editor.coffee"
Guide = require "../src/scripts/models/guide.coffee"

PageEditor = require "../src/scripts/views/editors/pageEditor.coffee"
ElementView = require "../src/scripts/views/element.coffee"

plugins = require '../src/plugins/plugins.coffee'
components = plugins.components
setup = require './setups.coffee'

_ = require 'underscore'
$ = require 'jquery'

describe "Make two rectangles and move one close to the other", ->
  data = null
  element = null
  element2 = null

  before ->
    data = setup.appSetup()
    data.app.get("settings").set "snapping", true
    data.app.get("settings").set "gridCellSize", 100
    editor = data.app_view.projectView.pageView.editor
    controlLayer = data.app_view.projectView.pageView.controlLayer

    element = setup.addComponent data.page, "rectangle"
    element.set {x: 10, y: 20, w: 230, h: 400}
    element2 = setup.addComponent data.page, "rectangle"
    element2.set {x: 0, y: 0, w: 300, h: 150}

    editor.selectElement element2
    controlLayer.getElementView(element2).move -59, 0, false
    editor.applyMods()

  it "should both have the same right side", ->
    assert.equal element.get("x")+element.get("w"), element2.get("x")+element2.get("w")

twoRectsTest = (grab) ->
  data = setup.appSetup()
  data.app.get("settings").set "snapping", true

  snapper = data.app_view.projectView.pageView.controlLayer.snapper
  i = 0
  while i < snapper.guides.length
    if snapper.guides[i].get("type") == "grid"
      snapper.guides.splice i, 1
    else
      i++

  data.element = setup.addComponent data.page, "rectangle"
  data.element.set {x: -10, y: 10, w: 110, h: 140}
  data.element2 = setup.addComponent data.page, "rectangle"
  data.element2.set {x: 110, y: 10, w: 160, h: 100}

  data.editor = data.app_view.projectView.pageView.editor
  data.controlLayer = data.app_view.projectView.pageView.controlLayer

  data.editor.selectElement data.element
  data.controlLayer.getElementView(data.element).startMove grab.x, grab.y, false
  data.controlLayer.getElementView(data.element).move 140, 0, false
  data.editor.applyMods()

  return data

describe "Move rectangle while holding the middle", ->
  data = null

  before ->
    data = twoRectsTest {x: 45, y: 75}

  it "should have aligned with the left of the second rectangle", ->
    assert.equal data.element.get("x"), data.element2.get("x")

describe "Move rectangle while holding the right edge", ->
  data = null

  before ->
    data = twoRectsTest {x: 95, y: 75}

  it "should have aligned with the right of the second rectangle", ->
    assert.equal data.element.get("x") + data.element.get("w"), data.element2.get("x") + data.element2.get("w")
