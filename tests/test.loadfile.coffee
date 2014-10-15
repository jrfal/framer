assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
fs = require 'fs'
$ = require 'jquery'
_ = require 'underscore'
messages = require './../src/content/messages.en.json'
Project = require './../src/scripts/models/project.coffee'
Page = require './../src/scripts/models/page.coffee'

describe 'Loading', ->
  before ->
    framer.app.loadFile './testData/test.json'
    framer.app.saveFile './testData/savetest.json'

  describe 'simple data', ->
    it 'should have two pages', ->
      assert.equal framer.app.get('project').get('pages').length, 2

  describe 'check control boxes', ->
    it 'should match all the control box sizes and positions to their elements', ->
      page = framer.app.get('project').get('pages').first()
      $("#framer_controls .control-box").each ->
        element = page.getElementByID $(this).data('element')
        position = $(this).position()
        if element.has 'x'
          assert.equal element.get('x'), position.left
        if element.has 'y'
          assert.equal element.get('y'), position.top
        if element.has 'w'
          assert.equal element.get('w'), $(this).width()
        if element.has 'h'
          assert.equal element.get('h'), $(this).height()

  describe 'simple save', ->
    it 'should have all the same properties', ->
      loadFile = JSON.parse(fs.readFileSync('./testData/test.json').toString())
      saveFile = JSON.parse(fs.readFileSync('./testData/savetest.json').toString())
      assert.ok _.isEqual(loadFile, saveFile)
      fs.unlink './testData/savetest.json'

describe 'Save Changes', ->
  before ->
    project = new Project()
    pages = project.get 'pages'
    page = new Page()
    pages.add page
    framer.app.set 'project', project
    data = {template: "link", label: "testing link", href: "#url"}
    page.addElement data
    data = {template: "oval", x: 40, y: 110, w: 800, h: 1001}
    page.addElement data
    framer.app.saveFile './testData/savetest.json'

  describe 'save modifications', ->
    it 'should be match a previously created reference file', ->
      loadFile = JSON.parse(fs.readFileSync('./testData/reference.json').toString())
      saveFile = JSON.parse(fs.readFileSync('./testData/savetest.json').toString())
      assert.ok _.isEqual(loadFile, saveFile)
      fs.unlink './testData/savetest.json'

describe 'Problem Loading', ->
  before ->
    framer.app.loadFile './testData/not.a.file.json'

  describe 'non-existent file', ->
    it 'should show no file message', ->
      assert.equal $($(".dialog-message")[0]).text(), messages["no file"]

describe 'Problem Loading', ->
  before ->
    framer.app.loadFile './testData/invalid.json'

  describe 'badly formatted file', ->
    it 'should show bad file message', ->
      assert.equal $($(".dialog-message")[1]).text(), messages["bad file"]

  after ->
    $('.bbm-wrapper').trigger 'click'

describe 'Creating a New Project', ->
  before ->
    framer.app.loadFile './testData/test.json'

  describe 'new project', ->

    it 'should have no elements', ->
      framer.app.newProject()
      project = framer.app.get 'project'
      page = project.get('pages').first()
      elements = page.get 'elements'
      assert.equal elements.length, 0
