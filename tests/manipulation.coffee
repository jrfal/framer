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

plugins = require '../src/plugins/plugins.coffee'
components = plugins.components

_ = require 'underscore'
$ = require 'jquery'

describe "Create an element and resize it", ->
  page = new Page()
  pageEditor = new PageEditor {model: page}
  component = _.findWhere components, {component: "rectangle"}
  element = new Element(component)
  element.set
    x: 345
    y: 938
    w: 442
    h: 700
  page.addElement element

  pageEditor.editor.selectElement element
  pageEditor.editor.scaleSelectedBy 0.5, 0.8, {x: 345, y: 938}

  it "should update the dimensions of the element", ->
    assert.equal element.get("w"), 221
    assert.equal element.get("h"), 560

  it "should update the dimensions of the rendering element", ->
    view = pageEditor.getElementView element
    assert.equal $(view.el).width(), 221
    assert.equal $(view.el).height(), 560

describe "Create a grid and resize it", ->
  page = new Page()
  pageEditor = new PageEditor {model: page}
  component = _.findWhere components, {component: "grid"}
  element = new Element(component)
  element.set
    x: 345
    y: 938
  page.addElement element
  view = pageEditor.getElementView element

  pageEditor.editor.selectElement element

  pageEditor.editor.setScale 0.1, 0.2, {x: 345, y: 938}
  viewAttributes = view.viewAttributes()
  delete viewAttributes.w
  delete viewAttributes.h
  viewAttributes.naturalW = 1100
  viewAttributes.naturalH = 2300
  pageEditor.editor.modifyViewAttributes element, viewAttributes
  pageEditor.editor.setScale 1, 1, {x: 345, y: 938}

  pageEditor.editor.scaleSelectedBy 5, 8, {x: 345, y: 938}

  it "should've had updated view attributes when scaling was in progress", ->
    assert.equal viewAttributes.w, 110
    assert.equal viewAttributes.h, 460

  it "should update the dimensions of the element", ->
    assert.equal element.get("w"), 5
    assert.equal element.get("h"), 8

  it "should update the dimensions of the rendering element", ->
    assert.equal $(view.el).width(), 5
    assert.equal $(view.el).height(), 8

describe "Create a grid and resize it with handlers", ->
  page = new Page()
  pageEditor = new PageEditor {model: page}
  pageEditor.controlLayer.snapper.active = false
  $("body").append pageEditor.el
  component = _.findWhere components, {component: "grid"}
  element = new Element(component)
  element.set
    x: 345
    y: 938
  page.addElement element
  view = pageEditor.getElementView element

  pageEditor.editor.selectElement element

  transformBox = pageEditor.controlLayer.transformBox

  e = $.Event "mouseDown"
  e.screenX = 0
  e.screenY = 0
  e.target = $(transformBox.el).find(".resize-handle-br")
  transformBox.startResizeHandler e
  e = $.Event "mouseMove"
  e.screenX = 5
  e.screenY = 8
  transformBox.resizeHandler e
  e = $.Event "mouseUp"
  e.screenX = 5
  e.screenY = 8
  transformBox.stopResizeHandler e

  it "should update the dimensions of the element", ->
    assert.equal element.get("w"), 5
    assert.equal element.get("h"), 8

describe "Create a grid and resize it from a natural width and height", ->
  page = new Page()
  pageEditor = new PageEditor {model: page}
  component = _.findWhere components, {component: "grid"}
  element = new Element(component)
  element.set
    x: 345
    y: 938
  page.addElement element
  element.set 'naturalW', 1100
  element.set 'naturalH', 2300

  pageEditor.editor.selectElement element

  pageEditor.editor.setScale 0.1, 0.2, {x: 345, y: 938}
  pageEditor.editor.applyMods()

  it "should be scaled to 110x460", ->
    assert.equal element.get("w"), 110
    assert.equal element.get("h"), 460
