assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
fs = require 'fs'
$ = require 'jquery'
_ = require 'underscore'
messages = require './../src/content/messages.en.json'
Project = require './../src/scripts/models/project.coffee'
Page = require './../src/scripts/models/page.coffee'
components = require '../src/components/components.json'

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
      boxes = $("#framer_controls .control-box")
      assert.equal 6, boxes.length
      boxes.each ->
        id = $(this).data('element')
        drawnElement = $("#framer_pages [data-element=#{id}]")
        position = $(this).position()
        assert.equal drawnElement.position().left, position.left
        assert.equal drawnElement.position().top, position.top
        assert.equal drawnElement.outerWidth(), $(this).outerWidth()
        assert.equal drawnElement.outerHeight(), $(this).outerHeight()

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
    data = {component: "link", label: "testing link", href: "#url"}
    page.addElement data
    data = {component: "oval", x: 40, y: 110, w: 800, h: 1001}
    page.addElement data
    framer.app.saveFile './testData/savetest.json'

  describe 'save modifications', ->
    it 'should match a previously created reference file', ->
      loadFile = JSON.parse(fs.readFileSync('./testData/reference.json').toString())
      saveFile = JSON.parse(fs.readFileSync('./testData/savetest.json').toString())
      assert.ok _.isEqual(loadFile, saveFile)
      fs.unlink './testData/savetest.json'

describe 'Problem Loading', ->
  describe 'non-existent file', ->
    it 'should show no file message', ->
      framer.app.loadFile './testData/not.a.file.json'
      els = $(".dialog-message")
      assert.equal $(els[els.length - 1]).text(), messages["no file"]
      $('.bbm-wrapper').trigger 'click'

describe 'Problem Loading', ->
  describe 'badly formatted file', ->
    it 'should show bad file message', ->
      framer.app.loadFile './testData/invalid.json'
      els = $(".dialog-message")
      assert.equal $(els[els.length - 1]).text(), messages["bad file"]
      $('.bbm-wrapper').trigger 'click'

describe 'Creating a New Project', ->
  describe 'new project', ->
    it 'should have no elements', ->
      framer.app.loadFile './testData/test.json'
      framer.app.newProject()
      project = framer.app.get 'project'
      page = project.get('pages').first()
      elements = page.get 'elements'
      assert.equal elements.length, 0

describe 'Unsaved Project', ->
  before ->
    framer.app.loadFile './testData/test.json'
    project = framer.app.get 'project'
    page = project.get('pages').first()
    page.addElement components[0]

  describe 'new project', ->
    it 'should show message about unsaved project', ->
      framer.app_view.newProjectCmd()
      els = $(".dialog-message")
      assert.equal $(els[els.length - 1]).text(), messages["load while unsaved"]
      $(".bbm-button.cancel").click()

  describe 'load project', ->
    it 'should show message about unsaved project', ->
      framer.app_view.loadFileCmd()
      els = $(".dialog-message")
      assert.equal $(els[els.length - 1]).text(), messages["load while unsaved"]
      $(".bbm-button.cancel").click()

describe 'Save and New', ->
  before ->
    framer.app.loadFile './testData/reference2.json'
    framer.app_view.projectView.projectChanged()
    framer.app_view.afterSaving = framer.app_view.newProjectCmd
    framer.app_view.saveFile {}, './testData/savetest.json'

  describe 'save and new', ->
    it 'should have no elements', ->
      project = framer.app.get 'project'
      page = project.get('pages').first()
      elements = page.get 'elements'
      assert.equal elements.length, 0

    it 'should match a previously created reference file', ->
      loadFile = JSON.parse(fs.readFileSync('./testData/reference2.json').toString())
      saveFile = JSON.parse(fs.readFileSync('./testData/savetest.json').toString())
      assert.ok _.isEqual(loadFile, saveFile)
      fs.unlink './testData/savetest.json'

describe 'Naming Pages', ->
  before ->
    framer.app.loadFile './testData/same-name-pages.json'

  describe 'Make page slugs unique', ->
    it 'should not have any page slugs equal to any others', ->
      pages = framer.app.get('project').get('pages')
      pages.each (page1) ->
        pages.each (page2) ->
          if page1 != page2
            assert.notEqual page1.get('slug'), page2.get('slug')

describe 'Various File Issues', ->
  describe 'deal with some bad files', ->
    it 'should not choke on these', ->
      framer.app.loadFile './testData/badData/wrongPages.json'

  after ->
    $('.bbm-wrapper').trigger 'click'
