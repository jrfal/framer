# MasterPage

module.exports.register = (plugins) ->
  plugins.renderers.masterPage = require './renderer/masterPage.coffee'
  plugins.components.push {
    "title": "Master Page",
    "component": "masterPage",
    "renderers": [
      "masterPage"
    ]
  }
  plugins.modifyElementQueue.push (pageView, elements) ->
    Element = require './../../scripts/models/element.coffee'
    page = pageView.model
    if page.has 'masterPage'
      elements.push new Element({'component': 'masterPage', 'page': page.get('masterPage')})
