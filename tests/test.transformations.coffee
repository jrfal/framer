assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
$ = require 'jquery'
_ = require 'underscore'
Project = require '../src/scripts/models/project.coffee'
Page = require '../src/scripts/models/page.coffee'
plugins = require './../src/plugins/plugins.coffee'

describe 'Transformations', ->
  describe 'comma delimited', ->
    it 'should split list into a 2x2 array', ->
      input = "uno, dos\ntres, quatro"
      output = [["uno", "dos"], ["tres", "quatro"]]
      transformed = plugins.transformations['comma-delimited'](input)
      assert.ok _.isEqual(output, transformed)

  describe 'form elements', ->
    it 'should have a checkbox', ->
      input = "[] label"
      output = "<input type=\"checkbox\" /> label"
      transformed = plugins.transformations['form-elements'](input)
      assert.ok _.isEqual(output, transformed)

  describe 'line list', ->
    it 'should be a list of 3', ->
      input = "eh\nbee\nsee"
      output = ["eh", "bee", "see"]
      transformed = plugins.transformations['line-list'](input)
      assert.ok _.isEqual(output, transformed)

  describe 'table meta', ->
    it 'should have extra meta properties in table', ->
      input = [["ok", "here", "it is"], ["along", "with", "this"], ["oh", "and", "this"]]
      output = [
        {columns: ["ok", "here", "it is"], even: true},
        {columns: ["along", "with", "this"], even: false},
        {columns: ["oh", "and", "this"], even: true}
      ]
      transformed = plugins.transformations['table-meta'](input)
      assert.ok _.isEqual(output, transformed)
