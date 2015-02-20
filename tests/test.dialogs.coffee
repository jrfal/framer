assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
$ = require 'jquery'
Dialog = require '../src/scripts/views/dialog.coffee'

describe 'Dialogs', ->

  describe 'message', ->
    it 'should show the title and text', ->
      title = "ok title"
      message = "hello this is a message"
      question = Dialog.message title, message
      titleEl = $(question.el).find "h3"
      assert.equal titleEl.text(), title
      messageEl = $(question.el).find ".dialog-message"
      assert.equal messageEl.text(), message

  describe 'question', ->
    it 'should show the title, text, and actions', ->
      title = "question title"
      message = "here's a a question message"
      action = "action name"
      question = Dialog.question title, message, [{label: action, class: "action-button"}]
      titleEl = $(question.el).find  "h3"
      assert.equal titleEl.text(), title
      messageEl = $(question.el).find ".dialog-message"
      assert.equal messageEl.text(), message
      actionEl = $(question.el).find ".action-button"
      assert.equal actionEl.text(), action

  describe 'edit options', ->
    it 'should show the title, text, and actions', ->
      title = "edit title"
      action = "action name"
      value = "edit value"
      edit = Dialog.edit title, [{class: "value-class", value: value, options: [value, "one", "two"]}], action
      titleEl = $(edit.el).find  "h3"
      assert.equal titleEl.text(), title
      actionEl = $(edit.el).find ".submit"
      assert.equal actionEl.text(), action
      valueEl = $(edit.el).find ".value-class"
      assert.equal valueEl.val(), value

  describe 'edit text', ->
    it 'should show the title, text, and actions', ->
      title = "edit title"
      action = "action name"
      value = "edit value"
      edit = Dialog.edit title, [{class: "value-class", value: value}], action
      titleEl = $(edit.el).find  "h3"
      assert.equal titleEl.text(), title
      actionEl = $(edit.el).find ".submit"
      assert.equal actionEl.text(), action
      valueEl = $(edit.el).find ".value-class"
      assert.equal valueEl.val(), value
