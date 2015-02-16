$ = require 'jquery'
templates = require './componentTemplates.coffee'

class HandlebarsRenderer
  template: null

  constructor: (element) ->
    template = element.get('component')
    @template = templates.getTemplate template

  render: (viewAttributes) ->
    if @template?
      return $ @template(viewAttributes)
    return $ '<div></div>'

module.exports = HandlebarsRenderer
