assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
$ = require 'jquery'
_ = require 'underscore'
cbox = null

describe 'Aligning', ->
  before ->
    framer.app.loadFile './testData/three-shapes.json'
    for element in framer.app.get('project').get('pages').first().get('elements').models
      framer.app_view.projectView.pageView.editor.selectElement element

  describe 'align top', ->
    it 'should all have y of 50', ->
      framer.app_view.projectView.pageView.editor.alignSelectedTop()
      for element in framer.app.get('project').get('pages').first().get('elements').models
        assert.equal 50, element.get('y')

  describe 'align bottom', ->
    it 'should all have y + h of 150', ->
      framer.app_view.projectView.pageView.editor.alignSelectedBottom()
      for element in framer.app.get('project').get('pages').first().get('elements').models
        assert.equal 150, element.get('y') + element.get('h')

  describe 'align left', ->
    it 'should all have x of 50', ->
      framer.app_view.projectView.pageView.editor.alignSelectedLeft()
      for element in framer.app.get('project').get('pages').first().get('elements').models
        assert.equal 50, element.get('x')

  describe 'align right', ->
    it 'should all have x + w of 350', ->
      framer.app_view.projectView.pageView.editor.alignSelectedRight()
      for element in framer.app.get('project').get('pages').first().get('elements').models
        assert.equal 350, element.get('x') + element.get('w')

  describe 'align horizontal center', ->
    it 'should all have x + w/2 of 175', ->
      framer.app_view.projectView.pageView.editor.alignSelectedCenter()
      for element in framer.app.get('project').get('pages').first().get('elements').models
        assert.equal 200, element.get('x') + element.get('w')/2

  describe 'align vertical middle', ->
    it 'should all have y + h/2 of 100', ->
      framer.app_view.projectView.pageView.editor.alignSelectedMiddle()
      for element in framer.app.get('project').get('pages').first().get('elements').models
        assert.equal 100, element.get('y') + element.get('h')/2

describe 'Distributing', ->
  before ->
    framer.app.loadFile './testData/three-shapes.json'
    for element in framer.app.get('project').get('pages').first().get('elements').models
      framer.app_view.projectView.pageView.editor.selectElement element

  describe 'distribute top', ->
    it 'should have ys of 50, 275, 500', ->
      framer.app_view.projectView.pageView.editor.distributeSelectedTop()
      for element in framer.app.get('project').get('pages').first().get('elements').models
        assert.ok(element.get('y') in [50, 275, 500])

  describe 'distribute bottom', ->
    it 'should have ys of 50, 277.5, 500', ->
      framer.app_view.projectView.pageView.editor.distributeSelectedBottom()
      for element in framer.app.get('project').get('pages').first().get('elements').models
        assert.ok(element.get('y') in [50, 277.5, 500])

  describe 'distribute left', ->
    it 'should have xs of 50, 525, 1000', ->
      framer.app_view.projectView.pageView.editor.distributeSelectedLeft()
      for element in framer.app.get('project').get('pages').first().get('elements').models
        assert.ok(element.get('x') in [50, 525, 1000])

  describe 'distribute right', ->
    it 'should have xs of 50, 610, 1000', ->
      framer.app_view.projectView.pageView.editor.distributeSelectedRight()
      for element in framer.app.get('project').get('pages').first().get('elements').models
        assert.ok(element.get('x') in [50, 610, 1000])

  describe 'distribute horizontal center', ->
    it 'should have xs of 50, 567.5, 1000', ->
      framer.app_view.projectView.pageView.editor.distributeSelectedCenter()
      for element in framer.app.get('project').get('pages').first().get('elements').models
        assert.ok(element.get('x') in [50, 567.5, 1000])

  describe 'distribute vertical middle', ->
    it 'should have ys of 50, 276.25, 500', ->
      framer.app_view.projectView.pageView.editor.distributeSelectedMiddle()
      for element in framer.app.get('project').get('pages').first().get('elements').models
        assert.ok(element.get('y') in [50, 276.25, 500])
