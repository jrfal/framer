$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
Page = require './page.coffee'

class Project extends Backbone.Model
  initialize: ->
    @set 'pages', new Backbone.Collection [], {model: Page}

  addPage: ->
    pages = @get 'pages'
    pages.add(new Page())

  getPageBySlug: (slug) ->
    pages = @get 'pages'
    for page in pages
      if page.slug == slug
        return page

module.exports = Project
