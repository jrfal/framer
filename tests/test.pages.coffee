assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
$ = require 'jquery'

describe 'Add Page', ->
  before ->
    framer.app.loadFile './testData/reference.json'
    framer.app_view.projectView.showPage framer.app.get('project').addPage()

  describe 'adding new page', ->

    it 'should have two pages', ->
      assert.equal 2, framer.app.get('project').get('pages').size()

describe 'Change Pages', ->
  it 'should be showing the first page', ->
    framer.app_view.projectView.showPage framer.app.get('project').get('pages').first()
    assert.equal framer.app_view.projectView.currentPage, framer.app.get('project').get('pages').first()
    assert.equal 1, $("#page").length
    assert.equal 1, $("[href=#url]").length

  it 'should be showing the second page', ->
    framer.app_view.projectView.showPage framer.app.get('project').get('pages').last()
    assert.equal framer.app_view.projectView.currentPage, framer.app.get('project').get('pages').last()
    assert.equal 0, $("#page").length
    assert.equal 0, $("[href=#url]").length
