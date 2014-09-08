assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
$ = require 'jquery'

describe 'Basic Elements', ->
  before ->
    framer.loadFile './testData/basicElements.json'

  describe 'grid', ->
    it 'should be a 4 x 2 table', ->
      table = $ '#framer_pages #grid table'
      rows = $ '#framer_pages #grid table tr'
      cells = $ '#framer_pages #grid table tr td'
      assert.equal table.length, 1
      assert.equal rows.length, 4
      assert.equal cells.length, 8
