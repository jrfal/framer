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

  describe 'rectangle', ->
    it 'should be a rectangle', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'template': 'rectangle'}).length

  describe 'oval', ->
    it 'should be an oval', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'template': 'oval'}).length

  describe 'grid', ->
    it 'should be a grid', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'template': 'grid'}).length

  describe 'link', ->
    it 'should be an link', ->
      assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'template': 'link'}).length
