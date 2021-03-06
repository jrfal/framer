assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
$ = require 'jquery'
_ = require 'underscore'
cbox = null
MenuBar = require '../src/scripts/views/helpers/menubar.coffee'

describe 'Selecting', ->
  before ->
    framer.app.loadFile './testData/test.json'
    cbox = $('.control-box:first-child')
    cbox.trigger 'click'

  describe 'clicking selects', ->
    it 'should show the edit panel for this object', ->
      assert.equal $('.property-panel').length, 1
    it 'should contain the correct id in the selection', ->
      elementID = cbox.data 'element'
      assert.ok framer.app_view.projectView.pageView.controlLayer.editor.isSelectedID(elementID)

    it 'should show the resize handles', ->
      count = 0
      $('.transform-box .resize-handle').each (i, item) ->
        if $(item).css('visibility') == 'visible'
          count++
      assert.equal count, 8

describe 'Multi-Selecting', ->
  before ->
    framer.app.get('settings').set {snapping: false}
    framer.app.loadFile './testData/two-rects.json'

  describe 'select a second element with cmd-click', ->
    it 'should have two selected', ->
      $('.control-box:first-child').trigger 'click'
      e = $.Event 'click'
      e.metaKey = true
      $('.control-box:last').trigger e
      assert.equal framer.app_view.getSelected().length, 2
    it 'should have no text in the property panel', ->
      assert.equal $('.property-panel.showing [data-property=text]').val(), ""
    it 'should have 20 font size in the property panel', ->
      assert.equal $('.property-panel.showing [data-property=fontSize]').val(), 20

  describe 'move one, and it should move both', ->
    it 'should have updated the positions to 75,70 and 125,120', ->
      controlBox = $('#framer_controls .control-box:first')
      e = $.Event 'mousedown'
      e.screenX = 50 + 9
      e.screenY = 50 + 17
      $(controlBox).find('.control-border').trigger e
      e = $.Event 'mousemove'
      e.screenX = 75 + 9
      e.screenY = 70 + 17
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
      e.clientX = 2
      e.clientY = 2
      $(document).trigger e

      assert.equal framer.app_view.getSelected().length, 0

    it 'should have two selected if we drag through both', ->
      e = $.Event 'mousedown'
      e.screenX = 125
      e.screenY = 120
      e.shiftKey = false
      e.metaKey = false
      $("#framer_controls").trigger e
      e = $.Event 'mousemove'
      e.screenX = 175
      e.screenY = 170
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
      e.screenX = 125
      e.screenY = 120
      e.metaKey = true
      $("#framer_controls").trigger e
      e = $.Event 'mousemove'
      e.screenX = 175
      e.screenY = 170
      $(document).trigger e
      e = $.Event 'mouseup'
      $(document).trigger e

      assert.equal framer.app_view.getSelected().length, 1

    it 'should have only the second one selected', ->
      assert.equal framer.app_view.getSelected().first().get('id'), $('.control-box:last').data('element')

  describe 'deselect by clicking background', ->
    it 'should have no selected', ->
      e = $.Event 'mousedown'
      e.clientX = 0
      e.clientY = 0
      $("#framer_controls").trigger e
      e = $.Event 'mouseup'
      e.clientX = 0
      e.clientY = 0
      $("#framer_controls").trigger e
      assert.equal framer.app_view.getSelected().length, 0

describe 'Selecting Auto-Dimensioned Elements', ->
  before ->
    framer.app.loadFile './testData/basicElements.json'

  describe 'select a grid by dragging', ->
    it 'should have one selected', ->
      e = $.Event 'mousedown'
      e.screenX = 400
      e.screenY = 400
      e.shiftKey = false
      e.metaKey = false
      $("#framer_controls").trigger e
      e = $.Event 'mousemove'
      e.screenX = 2
      e.screenY = 2
      $(document).trigger e
      e = $.Event 'mouseup'
      e.screenX = 2
      e.screenY = 2
      $(document).trigger e
      assert.equal framer.app_view.getSelected().length, 1

describe 'Select All', ->
  before ->
    framer.app.loadFile './testData/basicElements.json'
    framer.app_view.projectView.pageView.controlLayer.selectAll()

  describe 'select all elements on the page', ->
    it 'should have no elements unselected', ->
      elements = framer.app.get('project').get('pages').first().get('elements')
      editor = framer.app_view.projectView.pageView.controlLayer.editor
      for element in elements.models
        assert.ok editor.isSelected(element)

describe 'Select text', ->
  menubar = null

  before ->
    framer.app.loadFile './testData/basicElements.json'
    element = framer.app.get("project").get("pages").first().get("elements").first()
    framer.app_view.projectView.pageView.editor.selectElement element
    framer.app_view.projectView.propertyPanel.show()
    $(".property-panel #property-panel-text").select()
    menubar = new MenuBar framer.app, framer.app_view
    menubar.copyHandler()
    $(".property-panel #property-panel-text").val("")
    $(".property-panel #property-panel-text").focus()
    menubar.pasteHandler()

  it "should have the right text in the clipboard", ->
    assert.equal "First, Last\nJeff, Fal\nDarth, Vader\nSpider, Man", menubar.clipboard.get()

  it "should have the right text in the text field", ->
    assert.equal "First, Last\nJeff, Fal\nDarth, Vader\nSpider, Man", $(".property-panel #property-panel-text").val()

describe 'Cut text', ->
  menubar = null

  before ->
    framer.app.loadFile './testData/basicElements.json'
    element = framer.app.get("project").get("pages").first().get("elements").first()
    framer.app_view.projectView.pageView.editor.selectElement element
    framer.app_view.projectView.propertyPanel.show()
    $(".property-panel #property-panel-text").focus()
    $(".property-panel #property-panel-text").select()
    menubar = new MenuBar framer.app, framer.app_view
    menubar.cutHandler()

  it "should have the right text in the clipboard", ->
    assert.equal "First, Last\nJeff, Fal\nDarth, Vader\nSpider, Man", menubar.clipboard.get()

  it "should have no text in the text field", ->
    assert.equal "", $(".property-panel #property-panel-text").val()
