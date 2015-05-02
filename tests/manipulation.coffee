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
