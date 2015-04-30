global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView

assert = require "assert"
Page = require "../src/scripts/models/page.coffee"
Element = require "../src/scripts/models/element.coffee"
Group = require "../src/scripts/models/group.coffee"
Editor = require "../src/scripts/models/editor.coffee"

PageEditor = require "../src/scripts/views/editors/pageEditor.coffee"

describe 'Grouping:', ->
  describe 'Grouping and ungrouping changes the number of top-level elements', ->
    page = null
    element1 = null
    element2 = null
    editor = null

    groupIt = ->
      editor.selectElement element1
      editor.selectElement element2
      editor.groupSelected()

    ungroupIt = ->
      editor.ungroupSelected()

    beforeEach ->
      page = new Page()
      element1 = new Element()
      element2 = new Element()
      page.addElement element1
      page.addElement element2

      editor = new Editor()
      editor.set 'context', page

    it 'should have 2 page-level elements', ->
      assert.equal page.get("elements").length, 2

    it 'should have 1 page-level element and 1 selected element', ->
      groupIt()
      assert.equal page.get("elements").length, 1
      assert.equal editor.get("selection").length, 1

    it 'should have 2 page-level elements and 2 selected elements', ->
      groupIt()
      ungroupIt()
      assert.equal page.get("elements").length, 2
      assert.equal editor.get("selection").length, 2

  describe 'Grouping and moving the control box should update the appearance of all the elements', ->
    page = new Page()
    pageEditor = new PageEditor {model: page}
    element1 = new Element()
    element1.set "x", 203
    element1.set "y", 511

    element2 = new Element()
    element2.set "x", 680
    element2.set "y", -105

    page.addElement element1
    page.addElement element2

    controlBox1 = pageEditor.controlLayer.getElementView element1
    controlBox2 = pageEditor.controlLayer.getElementView element2

    controlBox1.selectHandler {stopPropagation: -> true}
    controlBox2.selectHandler {shiftKey: true, stopPropagation: -> true}

    assert.equal pageEditor.editor.get("selection").length, 2

    group = pageEditor.editor.groupSelected()
    group.set "x", 28
    group.set "y", 1001

    it 'should have x and y attributes of 231 and 1512', ->
      elementView = pageEditor.getElementView element1
      attributes = elementView.viewAttributes()
      assert.equal attributes.x, 231
      assert.equal attributes.y, 1512

    it 'should move the group and both elements', ->
      event1 =
        screenX: 231
        screenY: 1512
        stopPropagation: ->
          true
        preventDefault: ->
          true
      event2 =
        screenX: 331
        screenY: 1212
        stopPropagation: ->
          true
        preventDefault: ->
          true
      controlBox1.startMoveHandler event1
      controlBox1.moveHandler event2
      controlBox1.stopMoveHandler event2

      assert.equal group.get("x"), 128
      assert.equal group.get("y"), 701

      elementView = pageEditor.getElementView element2
      attributes = elementView.viewAttributes()
      assert.equal attributes.x, 808
      assert.equal attributes.y, 596

  describe 'Group elements and select group', ->
    page = new Page()
    pageEditor = new PageEditor {model: page}
    element1 = new Element()
    element2 = new Element()

    page.addElement element1
    page.addElement element2

    pageEditor.editor.selectElement element1
    pageEditor.editor.selectElement element2

    group = pageEditor.editor.groupSelected()

    it 'should show elements as selected', ->
      assert.ok pageEditor.editor.isSelected element1
      assert.ok pageEditor.editor.isSelected element2

  describe 'Group element, move group, ungroup elements', ->
    page = new Page()
    pageEditor = new PageEditor {model: page}

    element = new Element()
    element.set {x: 304, y: 918}

    pageEditor.editor.selectElement element

    group = pageEditor.editor.groupSelected()
    group.set {x: -20, y: 771}

    pageEditor.editor.ungroupSelected()

    it 'should have permanently moved element to 284, 1689', ->
      assert.equal element.get('x'), 284
      assert.equal element.get('y'), 1689
