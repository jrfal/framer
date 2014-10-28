$ = require 'jquery'
global.Backbone = require 'backbone'
uiTemplates = require './../uiTemplates.coffee'
global._ = require 'underscore'
require '../backbone.modal-min.js'
messages = require './../../content/messages.en.json'

class Dialog extends Backbone.Modal
  template: uiTemplates.dialog
  cancelEl: '.bbm-button.cancel'
  submitEl: '.bbm-button.submit'

module.exports.message = (header, text) ->
  dialogView = new Dialog({model: new Backbone.Model({title: header, message: text, actions: [{label: messages["close label"], class: "cancel"}]})})
  $('#framer_overlay').append dialogView.render().el

module.exports.question = (header, text, actions) ->
  _.each actions, (action) ->
    action.class = action.class + " submit"
  actions.push {label: messages["cancel label"], class: "cancel"}
  dialogView = new Dialog({model: new Backbone.Model({title: header, message: text, actions: actions})})
  $('#framer_overlay').append dialogView.render().el
  return dialogView
