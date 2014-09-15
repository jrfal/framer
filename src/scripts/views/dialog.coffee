$ = require 'jquery'
global.Backbone = require 'backbone'
uiTemplates = require './../uiTemplates.coffee'
global._ = require 'underscore'
require '../backbone.modal-min.js'

class Dialog extends Backbone.Modal
  template: uiTemplates.dialog
  cancelEl: '.bbm-button'

module.exports.dialog = (text) ->
  dialogView = new Dialog({model: new Backbone.Model({message: text})})
  $('#framer_overlay').append dialogView.render().el
