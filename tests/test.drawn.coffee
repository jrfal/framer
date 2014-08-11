assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
loading = require '../src/scripts/loading.coffee'
$ = require 'jquery'

describe 'Drawing', ->
  before ->
    loading.loadFile './testData/test.json'

  describe 'rectangle', ->
    it 'should be a 400x250 rectangle', ->
      rectangle = $ '#framer_pages #first .framer-drawn-element'
      assert.equal rectangle.width(), 400
      assert.equal rectangle.height(), 250
  describe 'oval', ->
    it 'should be a 300x200 oval', ->
      oval = $ '#framer_pages #second .framer-drawn-element'
      assert.equal oval.width(), 300
      assert.equal oval.height(), 200
      assert.equal oval.css('border-radius'), '50%'
