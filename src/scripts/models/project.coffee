$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
Page = require './page.coffee'

class Project extends Backbone.Model
  initialize: ->
    _.bindAll @, 'checkNewPage', 'checkNewSlug'
    pages = new Backbone.Collection [], {model: Page}
    @set 'pages', pages
    pages.on 'add', @checkNewPage

  addPage: ->
    pages = @get 'pages'
    newPage = new Page()
    pages.add(newPage)
    return newPage

  getPageBySlug: (slug) ->
    pages = @get 'pages'
    return pages.findWhere {slug: slug}

  allSlugs: ->
    pages = @get 'pages'
    return pages.pluck 'slug'

  checkNewPage: (page) ->
    slug = @checkSlugFor(page.get('slug'), page)
    if slug != page.get('slug')
      page.set 'slug', slug
    page.on 'change:slug', @checkNewSlug

  checkSlugFor: (slug, page) ->
    pages = @get 'pages'
    clean = false
    index = 1
    testSlug = slug
    while not clean
      if index > 1
        testSlug = slug + '_' + index
      clean = true
      pages.each (page2) ->
        if page != page2
          if page2.get('slug') == testSlug
            index++
            clean = false
    return testSlug

  checkNewSlug: (page) ->
    slug = @checkSlugFor(page.get('slug'), page)
    if slug != page.get('slug')
      page.set 'slug', slug

  saveObject: ->
    projectObject = _.clone @attributes
    pages = []
    for page in projectObject.pages.models
      pages.push page.saveObject()
    projectObject.pages = pages

    return projectObject

module.exports = Project
