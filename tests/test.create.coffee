assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
$ = require 'jquery'
components = require '../src/components/components.json'
Project = require '../src/scripts/models/project.coffee'
Page = require '../src/scripts/models/page.coffee'

describe 'Creating', ->
  before ->
    project = new Project()
    pages = project.get 'pages'
    page = new Page()
    pages.add page
    for key, component of components
      page.addElement component
    framer.app.set 'project', project

  describe 'label', ->
    it 'should be a label', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'component': 'label'}).length

  describe 'rectangle', ->
    it 'should be a rectangle', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'component': 'rectangle'}).length

  describe 'oval', ->
    it 'should be an oval', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'component': 'oval'}).length

  describe 'grid', ->
    it 'should be a grid', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'component': 'grid'}).length

  describe 'link', ->
    it 'should be an link', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'component': 'link'}).length

  describe 'checkbox', ->
    it 'should be a checkbox', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'component': 'checkbox'}).length

describe 'Creating from Palette', ->
  before ->
    project = new Project()
    pages = project.get 'pages'
    page = new Page()
    pages.add page
    framer.app.set 'project', project
    for component in components
      paletteLink = $("#framer_element_palette a[data-template=#{component.component}]")
      paletteLink.trigger "click"

  describe 'label', ->
    it 'should be a label', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'component': 'label'}).length

  describe 'rectangle', ->
    it 'should be a rectangle', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'component': 'rectangle'}).length

  describe 'oval', ->
    it 'should be an oval', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'component': 'oval'}).length

  describe 'grid', ->
    it 'should be a grid', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'component': 'grid'}).length

  describe 'link', ->
    it 'should be an link', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'component': 'link'}).length

  describe 'checkbox', ->
    it 'should be a checkbox', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'component': 'checkbox'}).length
