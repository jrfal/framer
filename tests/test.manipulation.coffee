assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
$ = require 'jquery'

describe 'Manipulating', ->
  before ->
    # move
    framer.loadFile './testData/test.json'
    controlBox = $('#framer_controls .control-box:last-child')
    dragData = {id: controlBox.data('element'), action: 'move', startX: 11, startY: 23}
    e = $.Event 'drop'
    e.clientX = 160 + 11
    e.clientY = 5 + 23
    e.originalEvent = {dataTransfer: {}, clientX: e.clientX, clientY: e.clientY }
    e.originalEvent.dataTransfer.getData = (key) ->
      this[key]
    e.originalEvent.dataTransfer['text/plain'] = JSON.stringify(dragData)
    $("#framer_controls").trigger e

    # resize
    dragData = {id: controlBox.data('element'), action: 'resize', x: controlBox.offset().left, y: controlBox.offset().top}
    e = $.Event 'drop'
    e.clientX = 90 + dragData.x
    e.clientY = 110 + dragData.y
    e.originalEvent = {dataTransfer: {}, clientX: e.clientX, clientY: e.clientY }
    e.originalEvent.dataTransfer.getData = (key) ->
      this[key]
    e.originalEvent.dataTransfer['text/plain'] = JSON.stringify(dragData)
    $("#framer_controls").trigger e

    # edit text, font, size
    $('#framer_controls .control-box:last-child .text-edit-handle').trigger "click"
    $(".text-update .content").val("so what is up?")
    $(".text-update .font-family").val("sans-serif")
    $(".text-update .font-size").val("19px")
    $(".text-update .save").trigger "click"

  describe 'moving', ->
    it 'should have moved the rectangle to 160,5', ->
      rectangle = $ '#framer_pages #first .framer-drawn-element'
      position = rectangle.position()
      assert.equal position.left, 160
      assert.equal position.top, 5

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
