ElementView = require './../element.coffee'

class ElementEditor extends ElementView
  editor: null

  viewAttributes: ->
    viewAttributes = super()
    if @editor?
      @editor.modifyViewAttributes @model, viewAttributes
    return viewAttributes

module.exports = ElementEditor
