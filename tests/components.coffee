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

describe "Creating a component element and assigning it to an existing element", ->
  page = new Page()
  pageEditor = new PageEditor {model: page}
  element = new Element()
  element.set
    x: 345
    y: 938
    w: 442
    h: 700
  page.addElement element
  instance = new Element()
  instance.set "master", element

  it "should have the same dimensions in the view attributes", ->
    attributes1 = pageEditor.getElementView(element).viewAttributes()
    attributes2 = pageEditor.getElementView(instance).viewAttributes()
    assert.equal attributes1.w, attributes2.w
    assert.equal attributes1.h, attributes2.h

describe "Create a component with an editor", ->
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
  pageEditor.controlLayer.propertyPanel.componentizeHandler({preventDefault: -> true})
  instance = page.get("elements").last()

  it "should have the same dimensions in the view attributes", ->
    attributes1 = pageEditor.getElementView(element).viewAttributes()
    attributes2 = pageEditor.getElementView(instance).viewAttributes()
    assert.equal attributes1.w, attributes2.w
    assert.equal attributes1.h, attributes2.h

  it "should put two elements in the element queue", ->
    elementQueue = pageEditor.model.fullElementList()
    assert.equal elementQueue.length, 2

  it "should return 'rectangle' as the component for the instance", ->
    assert.equal instance.get('master'), element
    assert instance.orMasterHas('component')
    assert.equal instance.orMasterGet('component'), 'rectangle'

  it "should have the appropriate renderers on the instance's view", ->
    instanceView = pageEditor.getElementView(instance)
    elementView = pageEditor.getElementView(element)

    assert.equal instanceView.renderers.length, elementView.renderers.length
    assert.equal instanceView.renderers[0].template, elementView.renderers[0].template

  it "should be able to be resized without error", ->
    pageEditor.editor.setScale 0.5, 0.5, {x: 0, y: 0}

describe "Create an element, make an instance of it, and resize it", ->
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

  instance = new Element {master: element}
  page.addElement instance

  pageEditor.editor.selectElement element
  pageEditor.editor.scaleSelectedBy 0.5, 0.8, {x: 345, y: 938}

  it "should update the dimensions of the instance", ->
    assert.equal element.orMasterGet("w"), 221
    assert.equal element.orMasterGet("h"), 560

  it "should update the dimensions of the rendering element", ->
    view = pageEditor.getElementView instance
    assert.equal $(view.el).width(), 221
    assert.equal $(view.el).height(), 560

describe "Create two elements, make instance of one, change master to the other, resize first element", ->
  page = new Page()
  pageEditor = new PageEditor {model: page}
  component = _.findWhere components, {component: "rectangle"}
  element = new Element(component)
  element2 = new Element(component)
  element.set
    x: 345
    y: 938
    w: 442
    h: 700
  page.addElement element

  instance = new Element {master: element}
  page.addElement instance

  instance.set "master", element2

  it "should not throw an error", ->
    pageEditor.editor.selectElement element
    pageEditor.editor.scaleSelectedBy 0.5, 0.8, {x: 345, y: 938}

describe "Creating a component element from a group", ->
  page = new Page()
  pageEditor = new PageEditor {model: page}
  component = _.findWhere components, {component: "rectangle"}
  element1 = new Element(component)
  element1.set
    x: 345
    y: 938
    w: 442
    h: 700
  element2 = new Element(component)
  element2.set
    x: 101
    y: 798
    w: 302
    h: 1001
  group = new Group()
  group.addElement element1
  group.addElement element2
  page.addElement group
  instance = new Element()
  instance.set "master", group
  page.addElement instance

  it "should have 2 child elements of the new instance", ->
    assert.equal instance.get("elements").length, 2

  it "should make the page have 4 elements to render", ->
    queue = page.fullElementList()
    assert.equal queue.length, 4

  it "should have a first element of a group with the instance as a parent", ->
    instanceElement = instance.get("elements").first()
    assert.equal instanceElement.get("parent"), instance

describe "Create a group component and resize", ->
  page = new Page()
  pageEditor = new PageEditor {model: page}
  component = _.findWhere components, {component: "rectangle"}
  element1 = new Element(component)
  element1.set
    x: 345
    y: 938
    w: 442
    h: 700
  element2 = new Element(component)
  element2.set
    x: 101
    y: 798
    w: 302
    h: 1001
  group = new Group()
  group.addElement element1
  group.addElement element2
  page.addElement group

  instance = new Element()
  instance.set "master", group
  page.addElement instance

  instanceElement = instance.get("elements").first()

  group.set {w: 0.5, h: 0.70}

  it "should have resized the group instance", ->
    assert.equal instance.orMasterGet("w"), 0.5
    assert.equal instance.orMasterGet("h"), 0.7

  it "should have resized the view of the first element of the component", ->
    view = pageEditor.getElementView instanceElement
    viewAttributes = view.viewAttributes()
    assert.equal viewAttributes.w, 221
    assert.equal viewAttributes.h, 490

    assert.equal $(view.el).width(), 221
    assert.equal $(view.el).height(), 490
