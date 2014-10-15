assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
fs = require 'fs'
$ = require 'jquery'

describe 'Loading a second file', ->
  before ->
    framer.app.loadFile './testData/basicElements.json'
    framer.app.loadFile './testData/drawn.json'

  describe 'simple data', ->
    it 'should have a page with the slug #first', ->
      assert.equal $("#framer_pages #first").length, 1

    it 'should have 1 page and 2 elements', ->
      assert.equal framer.app.get('project').get('pages').length, 1
      assert.equal framer.app.get('project').get('pages').first().get('elements').length, 2

    it 'should have only two elements', ->
      assert.equal $("#framer_pages .framer-element").length, 2
