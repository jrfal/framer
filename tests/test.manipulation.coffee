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

    # edit text, font, size
    $('#framer_controls .control-box:last-child').trigger "click"
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

describe 'Resizing', ->
  before ->
    framer.loadFile './testData/resizing.json'

    doResize = (number, edge, dropX, dropY) ->
      controlBox = $('#framer_controls .control-box:nth-child('+number+')')
      rectangle = $('#framer_pages #first .framer-drawn-element:nth-child('+number+')')
      top = rectangle.offset().top
      right = rectangle.offset().left + rectangle.width()
      bottom = rectangle.offset().top + rectangle.height()
      left = rectangle.offset().left
      dragData = {id: controlBox.data('element'), action: 'resize', edge: edge, top: top, right: right, bottom: bottom, left: left, clickX: 0, clickY: 0}
      e = $.Event 'drop'
      e.clientX = dropX
      e.clientY = dropY
      e.originalEvent = {dataTransfer: {}, clientX: e.clientX, clientY: e.clientY }
      e.originalEvent.dataTransfer.getData = (key) ->
        this[key]
      e.originalEvent.dataTransfer['text/plain'] = JSON.stringify(dragData)
      $("#framer_controls").trigger e

    doResize 1, 't', 100, 69
    doResize 2, 'tr', 670, 87
    doResize 3, 'r', 310, 75
    doResize 4, 'br', 397, 383
    doResize 5, 'b', 2, 572
    doResize 6, 'bl', 30, 439
    doResize 7, 'l', 87, 900
    doResize 8, 'tl', 292, 569

  describe 'resizing', ->
    it 'should have 8 resized rectangles', ->
      checkRectangle = (number, x, y, width, height) ->
        rectangle = $ '#framer_pages #first .framer-drawn-element:nth-child('+number+')'
        assert.equal rectangle.offset().left, x
        assert.equal rectangle.offset().top, y
        assert.equal rectangle.width(), width
        assert.equal rectangle.height(), height
      checkRectangle 1, 80,  69,  200, 370
      checkRectangle 2, 43,  87,  627, 331
      checkRectangle 3, 2,   18,  308, 410
      checkRectangle 4, 210, 31,  187, 352
      checkRectangle 5, 760, 12,  30,  560
      checkRectangle 6, 30,  18,  387, 421
      checkRectangle 7, 87,  170, 423, 250
      checkRectangle 8, 292, 569, 908, 1281


describe 'Selecting', ->
  before ->
    framer.loadFile './testData/test.json'
    $('.control-box:first-child').trigger 'click'

  describe 'clicking selects', ->
    it 'should show the edit panel for this object', ->
      assert.equal $('.text-update').length, 1
    it 'should contain the correct id', ->
      elementID = $('.text-update').data('element')

      assert.equal $('.text-update').data('element'), $('.control-box:first-child').data('element')
