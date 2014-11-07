assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
$ = require 'jquery'
cbox = null

describe 'Selecting', ->
  before ->
    framer.app.loadFile './testData/test.json'
    cbox = $('.control-box:first-child')
    cbox.trigger 'click'

  describe 'clicking selects', ->
    it 'should show the edit panel for this object', ->
      assert.equal $('.property-panel').length, 1
    it 'should contain the correct id', ->
      elementID = $('.property-panel').data('element')
      assert.equal $('.property-panel').data('element'), cbox.data('element')
    it 'should be able to move the edit panel', ->
      position = $('.property-panel').position()
      e = $.Event 'mousedown'
      e.clientX = 0
      e.clientY = 0
      $('.property-panel').trigger e
      e = $.Event 'mousemove'
      e.clientX = 50
      e.clientY = 75
      $('.property-panel').trigger e
      e = $.Event 'mouseup'
      $('.property-panel').trigger e
      assert.equal Math.round(position.left) + 50, Math.round($('.property-panel').position().left)
      assert.equal Math.round(position.top) + 75, Math.round($('.property-panel').position().top)

    it 'should show the resize handles', ->
      count = 0
      $('.transform-box .resize-handle').each (i, item) ->
        if $(item).css('visibility') == 'visible'
          count++
      assert.equal count, 8

describe 'Multi-Selecting', ->
  before ->
    framer.app.loadFile './testData/two-rects.json'

  describe 'select a second element with cmd-click', ->
    it 'should have two selected', ->
      $('.control-box:first-child').trigger 'click'
      e = $.Event 'click'
      e.metaKey = true
      $('.control-box:last').trigger e
      assert.equal framer.app_view.getSelected().length, 2

  describe 'move one, and it should move both', ->
    it 'should have updated the positions to 75,70 and 125,120', ->
      controlBox = $('#framer_controls .control-box:first')
      e = $.Event 'mousedown'
      e.clientX = 50 + 9
      e.clientY = 50 + 17
      $(controlBox).find('.control-border').trigger e
      e = $.Event 'mousemove'
      e.clientX = 75 + 9
      e.clientY = 70 + 17
      $(document).trigger e
      e = $.Event 'mouseup'
      $(document).trigger e

      rects = $ '#framer_pages .framer-drawn-element'

      rectangle = $(rects[0])
      position = rectangle.position()
      assert.equal position.left, 75
      assert.equal position.top, 70

      rectangle = $(rects[1])
      position = rectangle.position()
      assert.equal position.left, 125
      assert.equal position.top, 120

  describe 'select multiple objects by dragging', ->
    it 'should have none selected if we drag through none', ->
      e = $.Event 'mousedown'
      e.clientX = 1
      e.clientY = 1
      e.shiftKey = false
      e.metaKey = false
      $("#framer_controls").trigger e
      e = $.Event 'mousemove'
      e.clientX = 2
      e.clientY = 2
      $(document).trigger e
      e = $.Event 'mouseup'
      $(document).trigger e

      assert.equal framer.app_view.getSelected().length, 0

    it 'should have two selected if we drag through both', ->
      e = $.Event 'mousedown'
      e.clientX = 125
      e.clientY = 120
      e.shiftKey = false
      e.metaKey = false
      $("#framer_controls").trigger e
      e = $.Event 'mousemove'
      e.clientX = 175
      e.clientY = 170
      $(document).trigger e
      e = $.Event 'mouseup'
      $(document).trigger e

      assert.equal framer.app_view.getSelected().length, 2

    it 'should only show one property panel', ->
      assert.equal $('.property-panel.showing').length, 1

  describe 'unselect one of current selection by cmd-clicking on it', ->
    it 'should have only one selected', ->
      e = $.Event 'click'
      e.metaKey = true
      $('.control-box:last').trigger e
      assert.equal framer.app_view.getSelected().length, 1

  describe 'toggle selection on both by cmd-dragging through them', ->
    it 'should have only one selected', ->
      e = $.Event 'mousedown'
      e.clientX = 125
      e.clientY = 120
      e.metaKey = true
      $("#framer_controls").trigger e
      e = $.Event 'mousemove'
      e.clientX = 175
      e.clientY = 170
      $(document).trigger e
      e = $.Event 'mouseup'
      $(document).trigger e

      assert.equal framer.app_view.getSelected().length, 1

    it 'should have only the second one selected', ->
      assert.equal framer.app_view.getSelected().first().get('id'), $('.control-box:last').data('element')

describe 'Selecting Auto-Dimensioned Elements', ->
  before ->
    framer.app.loadFile './testData/basicElements.json'

  describe 'select a grid by dragging', ->
    it 'should have one selected', ->
      e = $.Event 'mousedown'
      e.clientX = 400
      e.clientY = 400
      e.shiftKey = false
      e.metaKey = false
      $("#framer_controls").trigger e
      e = $.Event 'mousemove'
      e.clientX = 2
      e.clientY = 2
      $(document).trigger e
      e = $.Event 'mouseup'
      $(document).trigger e
      assert.equal framer.app_view.getSelected().length, 1
