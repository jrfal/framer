global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView

assert = require "assert"
Page = require "../src/scripts/models/page.coffee"
Element = require "../src/scripts/models/element.coffee"

describe "Create element and remove element", ->
  page = new Page()
  element = new Element()
  page.addElement element
  assert.equal page.get("elements").length, 1
  element.removeFromParent()

  it "should have zero elements in the page", ->
    assert.equal page.get("elements").length, 0
