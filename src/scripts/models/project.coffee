$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
Page = require './page.coffee'

class Project extends Backbone.Model
  initialize: ->
    @set 'pages', new Backbone.Collection [], {model: Page}

module.exports = Project
