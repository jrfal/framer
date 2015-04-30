global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView

assert = require "assert"
Page = require "../src/scripts/models/page.coffee"
Element = require "../src/scripts/models/element.coffee"
Group = require "../src/scripts/models/group.coffee"
Editor = require "../src/scripts/models/editor.coffee"
ElementView = require "../src/scripts/views/element.coffee"

describe 'Parentage', ->
  describe 'After adding an element to a page, the element has the page as its parent', ->
    page = new Page()
    element = new Element()
    page.addElement(element)

    it 'should show the page as a parent', ->
      assert.equal element.get("parent"), page

  describe "After adding an element to a group, the element has the group as its parent", ->
    element = new Element()
    group = new Group()
    group.addElement(element)

    it 'should show the group as a parent', ->
      assert.equal element.get("parent"), group

  describe "After grouping two elements, they have the same parent", ->
    element1 = new Element()
    element2 = new Element()
    editor = new Editor()

    editor.selectElement element1
    editor.selectElement element2
    editor.groupSelected()

    it 'should have the same parent', ->
      assert.equal element1.get("parent"), element2.get("parent")

  describe "An element view in a group should have an offset x and y", ->
    element = new Element()
    element.set "x", 203
    element.set "y", 511

    group = new Group()
    group.set "x", 28
    group.set "y", 1001

    elementView = new ElementView {model: element}

    group.addElement element

    attributes = elementView.viewAttributes()

    it 'should have x and y attributes of 231 and 1512', ->
      assert.equal attributes.x, 231
      assert.equal attributes.y, 1512
