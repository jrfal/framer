assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
controlBox = require '../src/scripts/controlBox.coffee'
loading = require '../src/scripts/loading.coffee'
$ = require 'jquery'

describe 'Manipulating', ->
  before ->
    loading.loadFile './testData/test.json'
    controlBox.moveControlBox 'control_box_3', 60, 25
    controlBox.resizeControlBox 'control_box_3', 90, 110
    controlBox.updateText 'element_3', "so what is up?"
    controlBox.updateFontFamily 'element_3', 'sans-serif'
    controlBox.updateFontSize 'element_3', 19

  describe 'moving', ->
    it 'should have moved the rectangle to 60,25', ->
      rectangle = $ '#framer_pages #first .framer-drawn-element'
      position = rectangle.position()
      assert.equal position.left, 60
      assert.equal position.top, 25
  describe 'resizing', ->
    it 'should have resized rectangle to 90x110', ->
      rectangle = $ '#framer_pages #first .framer-drawn-element'
      assert.equal rectangle.width(), 90
      assert.equal rectangle.height(), 110
  describe 'text edit', ->
    it 'should have text saying "so what is up?"', ->
      rectangleText = $ '#framer_pages #first .framer-drawn-element .framer-text'
      assert.equal rectangleText.html(), "so what is up?"
  describe 'font family edit', ->
    it 'font should be sans-serif', ->
      rectangleText = $ '#framer_pages #first .framer-drawn-element .framer-text'
      assert.equal rectangleText.css("font-family"), "sans-serif"
  describe 'text size edit', ->
    it 'text size should be 19px', ->
      rectangleText = $ '#framer_pages #first .framer-drawn-element .framer-text'
      assert.equal rectangleText.css("font-size"), "19px"

describe 'Simulate Pointer', ->
  before ->
    loading.loadFile './testData/test.json'
    dragData = {id: 'control_box_3', action: 'move', startX: 11, startY: 23}
    e = $.Event 'drop'
    e.dataTransfer = {}
    e.dataTransfer.getData = (key) ->
      this[key]
    e.clientX = 160 + 11
    e.clientY = 5 + 23
    e.dataTransfer['text/plain'] = JSON.stringify(dragData)
    controlBox.controlDropHandler(e)

  describe 'moving', ->
    it 'should have moved the rectangle to 160,5', ->
      rectangle = $ '#framer_pages #first .framer-drawn-element'
      position = rectangle.position()
      assert.equal position.left, 160
      assert.equal position.top, 5
