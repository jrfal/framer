assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
fs = require 'fs'
$ = require 'jquery'
_ = require 'underscore'
messages = require './../src/content/messages.en.json'

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

describe 'Problem Loading', ->
  before ->
    framer.loadFile './testData/not.a.file.json'

  describe 'non-existent file', ->
    it 'should show no file message', ->
      assert.equal $($(".dialog-message")[0]).text(), messages["no file"]

describe 'Problem Loading', ->
  before ->
    framer.loadFile './testData/invalid.json'

  describe 'badly formatted file', ->
    it 'should show bad file message', ->
      assert.equal $($(".dialog-message")[1]).text(), messages["bad file"]

after ->
  $('.bbm-wrapper').trigger 'click'
