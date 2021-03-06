assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
$ = require 'jquery'

describe 'Change View', ->
  describe 'showing element palette', ->

    it 'should be showing the element palette', ->
      framer.app.showElementPalette()
      palette = $ '#framer_elementPalette'
      assert.equal palette.css("display"), "block"

    it 'should now be hiding the element palette', ->
      $("#framer_elementPalette .close").click()
      palette = $ '#framer_elementPalette'
      assert.equal palette.css("display"), "none"

    it 'should be showing the element palette again', ->
      framer.app.showElementPalette()
      palette = $ '#framer_elementPalette'
      assert.equal palette.css("display"), "block"

  describe 'showing grid', ->

    it 'should be showing the grid', ->
      framer.app.showGridLines()
      palette = $ '#framer_grid'
      assert.equal palette.css("display"), "block"

    it 'should now be hiding the grid', ->
      framer.app.hideGridLines()
      palette = $ '#framer_grid'
      assert.equal palette.css("display"), "none"

    it 'should be showing the grid again', ->
      framer.app.showGridLines()
      palette = $ '#framer_grid'
      assert.equal palette.css("display"), "block"

describe 'Load Settings', ->
  before ->
    framer.app.loadSettings './testData/testSettings.json'

  it 'should be hiding the element palette', ->
    palette = $ '#framer_elementPalette'
    assert.equal palette.css("display"), "none"

  it 'should be hiding the grid', ->
    palette = $ '#framer_grid'
    assert.equal palette.css("display"), "none"
