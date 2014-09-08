assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
fs = require 'fs'
$ = require 'jquery'

describe 'Loading a second file', ->
  before ->
    framer.loadFile './testData/basicElements.json'
    framer.loadFile './testData/drawn.json'

  describe 'simple data', ->
    it 'should have a page with the slug #first', ->
      assert.equal $("#framer_pages #first").length, 1

    it 'should have only two elements', ->
      assert.equal $("#framer_pages .framer-element").length, 2
