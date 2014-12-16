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

  describe 'component', ->
    for key, component of components
      it 'should be a '+component.component, ->
        assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'component': component.component}).length

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

  describe 'component', ->
    for key, component of components
      it 'should be a '+component.component, ->
        assert.equal 1, framer.app.get('project').get('pages').first().get('elements').where({'component': component.component}).length

  describe 'control box', ->
    for key, component of components
      it 'should be a control box for a '+component.component, ->
        element = framer.app.get('project').get('pages').first().get('elements').where({'component': component.component})[0]
        assert.equal 1, $("#framer_controls .control-box[data-element=#{element.get('id')}]").length
