App = require '../src/scripts/models/app.coffee'
AppView = require "../src/scripts/views/appView.coffee"
Element = require "../src/scripts/models/element.coffee"

plugins = require '../src/plugins/plugins.coffee'
components = plugins.components

$ = require "jquery"

module.exports.appSetup = ->
  $("body").append $("<div id='app'></div>")
  data = {}
  data.app = new App()
  data.app_view = new AppView {model: data.app}
  data.page = data.app.get("project").get("pages").first()
  data.editor = data.app_view.projectView.pageView.editor

  data

module.exports.addElement = (page) ->
  element = new Element()
  page.addElement element

  element

module.exports.addComponent = (page, component) ->
  component = _.findWhere components, {component: component}
  element = new Element(component)

  page.addElement element

  element
