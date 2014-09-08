assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
fs = require 'fs'
$ = require 'jquery'
_ = require 'underscore'

describe 'Loading', ->
  before ->
    framer.loadFile './testData/test.json'
    framer.saveFile './testData/savetest.json'

  describe 'simple data', ->
    it 'should have two pages', ->
      assert.equal framer.get('project').get('pages').length, 2

  describe 'simple save', ->
    it 'should have all the same properties', ->
      loadFile = JSON.parse(fs.readFileSync('./testData/test.json').toString())
      saveFile = JSON.parse(fs.readFileSync('./testData/savetest.json').toString())
      assert.ok _.isEqual(loadFile, saveFile)
      fs.unlink './testData/savetest.json'
