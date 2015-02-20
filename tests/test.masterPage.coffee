assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
fs = require 'fs'
$ = require 'jquery'
_ = require 'underscore'
messages = require './../src/content/messages.en.json'
Project = require './../src/scripts/models/project.coffee'
Page = require './../src/scripts/models/page.coffee'
plugins = require './../src/plugins/plugins.coffee'
components = plugins.components

describe 'Creating a Master Page', ->
  before ->
    framer.app.loadFile './testData/test.json'
    framer.app.get('project').get('pages').at(1).set 'masterPage', framer.app.get('project').get('pages').at(0)
    framer.app_view.projectView.showPage framer.app.get('project').get('pages').at(1)

  describe 'load and add master page', ->
    it 'should be showing an element from the first page', ->
      rectangle = $ '#framer_pages .framer-drawn-element.rectangle'
      assert.equal rectangle.length, 1
      assert.equal rectangle.outerWidth(), 400
      assert.equal rectangle.outerHeight(), 250
