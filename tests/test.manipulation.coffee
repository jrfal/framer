assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
$ = require 'jquery'

describe 'Manipulating', ->
  before ->
    # move
    framer.app.loadFile './testData/test.json'
    controlBox = $('#framer_controls .control-box:last')
    e = $.Event 'mousedown'
    e.clientX = 100 + 11
    e.clientY = 100 + 23
    $(controlBox).find('.control-border').trigger e
    e = $.Event 'mousemove'
    e.clientX = 160 + 11
    e.clientY = 5 + 23
    $(document).trigger e
    e = $.Event 'mouseup'
    $(document).trigger e

    # edit text, font, size
    $('#framer_controls .control-box:last').trigger "click"
    el_id = $('#framer_controls .control-box:last').data('element')
    $(".property-panel[data-element=#{el_id}] .content").val("so what is up?")
    $(".property-panel[data-element=#{el_id}] .font-family").val("sans-serif")
    $(".property-panel[data-element=#{el_id}] .font-size").val("19px")
    $(".property-panel[data-element=#{el_id}] .save").trigger "click"

    # edit grid
    $('#framer_controls .control-box:last').prev('.control-box').trigger "click"
    el_id = $('#framer_controls .control-box:last').prev('.control-box').data('element')
    $(".property-panel[data-element=#{el_id}] .content").val("one\ntwo\nthree")
    $(".property-panel[data-element=#{el_id}] .font-family").val("sans-serif")
    $(".property-panel[data-element=#{el_id}] .font-size").val("19px")
    $(".property-panel[data-element=#{el_id}] .save").trigger "click"

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
  describe 'grid content edit', ->
    it 'should have a 1x3 grid', ->
      grid = $ '#framer_pages #first table.framer-element'
      rows = grid.find 'tr'
      assert.equal rows.length, 3
      columns = grid.find 'tr:first-of-type td'
      assert.equal columns.length, 1

describe 'Resizing', ->
  before ->
    framer.app.loadFile './testData/resizing.json'

    doResize = (number, edge, dropX, dropY) ->
      controlBox = $('#framer_controls .control-box:nth-child('+number+')')
      rectangle = $('#framer_pages #first .framer-drawn-element:nth-child('+number+')')
      handle = controlBox.find('.resize-handle-'+edge)
      e = $.Event 'mousedown'
      if edge in ['tl', 'l', 'bl']
        e.clientX = handle.position().x + handle.width()
      else
        e.clientX = handle.position().x
      if edge in ['tl', 't', 'tr']
        e.clientX = handle.position().y + handle.height()
      else
        e.clientX = handle.position().y
      handle.trigger e

      e = $.Event 'mousemove'
      e.clientX = dropX
      e.clientY = dropY
      $(document).trigger e
      $(document).trigger 'mouseup'

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
