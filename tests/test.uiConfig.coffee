assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
$ = require 'jquery'

describe 'Change View', ->
  describe 'showing element palette', ->

    it 'should be showing the element palette', ->
      framer.showElementPalette()
      palette = $ '#framer_elementPalette'
      assert.equal palette.css("display"), "block"

    it 'should now be hiding the element palette', ->
      $("#framer_elementPalette .close").click()
      palette = $ '#framer_elementPalette'
      assert.equal palette.css("display"), "none"

    it 'should be showing the element palette again', ->
      framer.showElementPalette()
      palette = $ '#framer_elementPalette'
      assert.equal palette.css("display"), "block"