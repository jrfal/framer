# MasterPage

module.exports.register = (plugins) ->
  plugins.renderers.masterPage = require './renderer/masterPage.coffee'
  # plugins.modifyElementQueue.push (page, elements) ->
  #   if page.has 'masterPage'
