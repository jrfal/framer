assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
$ = require 'jquery'

describe 'Drawing', ->
  before ->
    framer.app.loadFile './testData/drawn.json'

  describe 'rectangle', ->
    it 'should be a 400x250 rectangle', ->
      rectangle = $ '#framer_pages .framer-drawn-element.rectangle'
      assert.equal rectangle.outerWidth(), 400
      assert.equal rectangle.outerHeight(), 250
  describe 'oval', ->
    it 'should be a 300x200 oval', ->
      oval = $ '#framer_pages .framer-drawn-element.oval'
      assert.equal oval.outerWidth(), 300
      assert.equal oval.outerHeight(), 200
      assert.equal oval.css('border-radius'), '50%'
