Backbone = require 'backbone'

class BaseView extends Backbone.View
  assign: (view, selector) ->
    view.setElement(this.$(selector))
    view.render()

module.exports = BaseView
