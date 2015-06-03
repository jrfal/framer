assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
$ = require 'jquery'

describe 'Manipulating', ->
  before ->
    # move
    framer.app.get('settings').set {snapping: false}
    framer.app.loadFile './testData/test.json'
    el_id = $("#framer_pages .framer-element:last").data("element")
    controlBox = $("#framer_controls .control-box[data-element=#{el_id}]")
    e = $.Event 'mousedown'
    e.screenX = 100 + 11
    e.screenY = 100 + 23
    $(controlBox).find('.control-border').trigger e
    e = $.Event 'mousemove'
    e.screenX = 160 + 11
    e.screenY = 5 + 23
    $(document).trigger e
    e = $.Event 'mouseup'
    e.screenX = 160 + 11
    e.screenY = 5 + 23
    $(document).trigger e

    # edit text, font, size
    el_id = $("#framer_pages .framer-element:last").data("element")
    $("#framer_controls .control-box[data-element=#{el_id}]").trigger "click"
    $(".property-panel.showing [data-property=text]").val("so what is up?")
    $(".property-panel.showing [data-property=fontFamily]").val("sans-serif")
    $(".property-panel.showing [data-property=fontSize]").val("19")
    $(".property-panel.showing [data-property=fontColor]").val("#00ff00")
    $(".property-panel.showing [data-property=borderColor]").val("#ff0000")
    $(".property-panel.showing [data-property=borderWidth]").val("4")
    $(".property-panel.showing [data-property=fillColor]").val("#0000ff")
    $(".property-panel.showing .save").trigger "click"

    # edit grid
    el_id = $("#framer_pages .framer-element:last").prev(".framer-element").data("element")
    $("#framer_controls .control-box[data-element=#{el_id}]").trigger "click"
    $(".property-panel.showing [data-property=text]").val("one\ntwo\nthree")
    $(".property-panel.showing [data-property=evenColor]").val("#ff0000")
    $(".property-panel.showing [data-property=oddColor]").val("#ffff00")
    $(".property-panel.showing .save").trigger "click"

    # edit check box
    el_id = $("#framer_pages .framer-element:last").prev(".framer-element").prev(".framer-element").data("element")
    $("#framer_controls .control-box[data-element=#{el_id}]").trigger "click"
    $(".property-panel.showing [data-property=text]").val("helllo")
    $(".property-panel.showing [data-property=selected]").attr("checked", "checked")
    $(".property-panel.showing .save").trigger "click"

  describe 'moving', ->
    it 'should have moved the rectangle to 160,5', ->
      rectangle = $ '#framer_pages #first .framer-drawn-element:last'
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
  describe 'font color edit', ->
    it 'the font color should be #0f0', ->
      rectangleText = $ '#framer_pages #first .framer-drawn-element .framer-text'
      assert.equal rectangleText.css("color"), "rgb(0, 255, 0)"
  describe 'border color edit', ->
    it 'the border color should be #f00', ->
      rectangle = $ '#framer_pages #first .framer-drawn-element:last'
      assert.equal rectangle.css("border-color"), "rgb(255, 0, 0)"
  describe 'border width edit', ->
    it 'the border width should be 4px', ->
      rectangle = $ '#framer_pages #first .framer-drawn-element:last'
      assert.equal rectangle.css("border-width"), "4px"
  describe 'fill color edit', ->
    it 'the fill color should be #00f', ->
      rectangle = $ '#framer_pages #first .framer-drawn-element:last'
      assert.equal rectangle.css("background-color"), "rgb(0, 0, 255)"
  describe 'grid content edit', ->
    it 'should have a 1x3 grid', ->
      grid = $ '#framer_pages #first table.framer-element'
      rows = grid.find 'tr'
      assert.equal rows.length, 3
      columns = grid.find 'tr:first-of-type td'
      assert.equal columns.length, 1
  describe 'grid colors edit', ->
    it 'should make the first row red and the second yellow', ->
      grid = $ '#framer_pages #first table.framer-element'
      rows = grid.find 'tr'
      assert.equal $(rows[0]).css("background-color"), "rgb(255, 0, 0)"
      assert.equal $(rows[1]).css("background-color"), "rgb(255, 255, 0)"
  describe 'checkbox label edit', ->
    it 'should have the label "helllo"', ->
      checkboxLabel = $('#framer_pages #first input[type=checkbox]').parent().find('label')
      assert.equal checkboxLabel.html(), "helllo"
    it 'should be checked', ->
      checkbox = $('#framer_pages #first input[type=checkbox]')
      assert.ok checkbox.is(":checked")

describe 'Resizing', ->
  before ->
    framer.app.loadFile './testData/resizing.json'

    doResize = (number, edge, dropX, dropY) ->
      id = $('#framer_pages .framer-element:nth-child('+number+')').data("element")
      controlBox = $("#framer_controls .control-box[data-element=#{id}]")
      controlBox.trigger "click"
      transformBox = $('#framer_controls .transform-box')
      elel = $(".framer-page [data-element=#{id}]")
      handle = transformBox.find('.resize-handle-'+edge)
      e = $.Event 'mousedown'
      if edge in ['tl', 'l', 'bl']
        e.screenX = elel.position().left
      else
        e.screenX = elel.position().left + elel.width()
      if edge in ['tl', 't', 'tr']
        e.screenY = elel.position().top
      else
        e.screenY = elel.position().top + elel.height()
      handle.trigger e

      e = $.Event 'mousemove'
      e.screenX = dropX
      e.screenY = dropY
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
        assert.equal rectangle.outerWidth(), width
        assert.equal rectangle.outerHeight(), height
      checkRectangle 1, 80,  69,  200, 370
      checkRectangle 2, 43,  87,  629, 331
      checkRectangle 3, 2,   18,  310, 410
      checkRectangle 4, 210, 31,  189, 354
      checkRectangle 5, 760, 12,  30,  562
      checkRectangle 6, 30,  18,  387, 423
      checkRectangle 7, 87,  170, 423, 250
      checkRectangle 8, 292, 569, 908, 1281

describe 'Resizing Multiple', ->
  before ->
    framer.app.loadFile './testData/resizing.json'

    editor = framer.app_view.projectView.pageView.controlLayer.editor
    elements = framer.app.get('project').get('pages').first().get('elements')
    for element in elements.models
      editor.selectElement(element)

    transformBox = $('#framer_controls .transform-box')
    handle = transformBox.find('.resize-handle-br')
    e = $.Event 'mousedown'
    e.screenX = handle.position().left
    e.screenY = handle.position().top
    handle.trigger e

    e = $.Event 'mousemove'
    e.screenX = handle.position().left + 100
    e.screenY = handle.position().top + 100
    $(document).trigger e
    $(document).trigger 'mouseup'

  describe 'resizing', ->
    it 'should have 8 resized rectangles', ->
      checkRectangle = (number, x, y, width, height) ->
        rectangle = $ '#framer_pages #first .framer-drawn-element:nth-child('+number+')'
        assert.equal rectangle.offset().left, x
        assert.equal rectangle.offset().top, y
        assert.equal rectangle.outerWidth(), width
        assert.equal rectangle.outerHeight(), height
      checkRectangle 1, 86.890625,  103.71875,  217, 358
      checkRectangle 2, 46.8125,    102.671875, 652, 337
      checkRectangle 3, 2.40625,    18.3125,    315, 433
      checkRectangle 4, 227.703125, 32.03125,   195, 264
      checkRectangle 5, 823.421875, 12,         33,  577
      checkRectangle 6, -3,         18.3125,    455, 549
      checkRectangle 7, 119.390625, 178.59375,  434, 263
      checkRectangle 8, 325.171875, 631.984375, 975, 1318

describe 'Editing Multiple', ->
  before ->
    framer.app.loadFile './testData/two-rects.json'
    $('.control-box:first-child').trigger 'click'
    e = $.Event 'click'
    e.metaKey = true
    $('.control-box:last').trigger e

    $(".property-panel.showing [data-property=fontFamily]").val("sans-serif")
    $(".property-panel.showing .save").trigger "click"

  describe 'select a second element with cmd-click', ->
    it 'should have the same text values', ->
      assert.equal "one", framer.app.get('project').get('pages').first().get('elements').first().get('text')
      assert.equal "two", framer.app.get('project').get('pages').first().get('elements').last().get('text')

    it 'should have sans-serif as the font family', ->
      assert.equal "sans-serif", framer.app.get('project').get('pages').first().get('elements').first().get('fontFamily')
      assert.equal "sans-serif", framer.app.get('project').get('pages').first().get('elements').last().get('fontFamily')

describe 'Snapping', ->
  before ->
    framer.app.get('settings').set {snapping: true}
    framer.app.get('settings').set {gridCellSize: 13}
    framer.app.loadFile './testData/test.json'

    # remove elements guide
    snapper = framer.app_view.projectView.pageView.controlLayer.snapper
    i = 0
    while i < snapper.guides.length
      if snapper.guides[i].get("type") == "elements"
        snapper.guides.splice i, 1
      else
        i++

    # moving
    controlBox = $('#framer_controls .control-box:last')
    e = $.Event 'mousedown'
    e.screenX = 100 + 200
    e.screenY = 100 + 125
    $(controlBox).find('.control-border').trigger e
    e = $.Event 'mousemove'
    e.screenX = 160 + 200
    e.screenY = 5 + 125
    $(document).trigger e
    e = $.Event 'mouseup'
    $(document).trigger e

    #resizing
    transformBox = $('#framer_controls .transform-box')
    handle = transformBox.find('.resize-handle-br')
    e = $.Event 'mousedown'
    e.screenX = 559 + 3
    e.screenY = 250 + 7
    handle.trigger e
    e = $.Event 'mousemove'
    e.screenX = 569 + 3
    e.screenY = 270 + 7
    $(document).trigger e
    $(document).trigger 'mouseup'

  describe 'moving', ->
    it 'should have moved the rectangle to 159,0', ->
      rectangle = $ '#framer_pages #first .framer-drawn-element:last'
      position = rectangle.position()
      assert.equal position.left, 159
      assert.equal position.top, 0

  describe 'resizing', ->
    it 'should have resized the rectangle to 572x273', ->
      rectangle = $ '#framer_pages #first .framer-drawn-element:last'
      assert.equal rectangle.outerWidth(), 413
      assert.equal rectangle.outerHeight(), 273

describe 'Locked Moving and Resizing', ->
  before ->
    framer.app.get('settings').set {snapping: false}
    framer.app.loadFile './testData/two-rects.json'

    # move
    el_id = $("#framer_pages .framer-element:first").data("element")
    controlBox = $("#framer_controls .control-box[data-element=#{el_id}]")
    e = $.Event 'mousedown'
    e.screenX = 50 + 11
    e.screenY = 50 + 23
    $(controlBox).find('.control-border').trigger e
    e = $.Event 'mousemove'
    e.screenX = 160 + 11
    e.screenY = 20 + 23
    e.shiftKey = true
    $(document).trigger e
    e = $.Event 'mouseup'
    $(document).trigger e

    #resizing
    el_id = $("#framer_pages .framer-element:last").data("element")
    controlBox = $("#framer_controls .control-box[data-element=#{el_id}]")
    controlBox.trigger 'click'
    transformBox = $('#framer_controls .transform-box')
    handle = transformBox.find('.resize-handle-br')
    e = $.Event 'mousedown'
    e.screenX = 200 + 3
    e.screenY = 200 + 7
    handle.trigger e
    e = $.Event 'mousemove'
    e.screenX = 300 + 3
    e.screenY = 250 + 7
    e.shiftKey = true
    $(document).trigger e
    $(document).trigger 'mouseup'

  describe 'moving', ->
    it 'should have moved the rectangle to 160,50', ->
      rectangle = $ '#framer_pages .framer-element:first'
      position = rectangle.position()
      assert.equal position.left, 160
      assert.equal position.top, 50

  describe 'resizing', ->
    it 'should have resized the rectangle to 175x175', ->
      rectangle = $ '#framer_pages .framer-element:last'
      assert.equal rectangle.outerWidth(), 175
      assert.equal rectangle.outerHeight(), 175
