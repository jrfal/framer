# Handlebars

module.exports.register = (plugins) ->
  plugins.renderers.handlebars = require './renderer/handlebars.coffee'
  plugins.components.push.apply plugins.components, require('./components.json')
