assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
loading = require '../src/scripts/loading.coffee'
fs = require 'fs'
$ = require 'jquery'

describe 'Loading', ->
  before ->
    loading.loadFile './testData/test.json'
    loading.saveFile './testData/savetest.json'

  describe 'simple data', ->
    it 'should have two pages', ->
      assert.equal $("#framer_pages .framer-page").length, 2

  describe 'simple save', ->
    it 'should be the same file', ->
      loadFile = JSON.parse(fs.readFileSync('./testData/test.json').toString())
      saveFile = JSON.parse(fs.readFileSync('./testData/savetest.json').toString())
      assert.equal JSON.stringify(loadFile), JSON.stringify(saveFile)
      fs.unlink './testData/savetest.json'
