assert = require 'assert'
framer = require '../src/scripts/framer.coffee'
$ = require 'jquery'

describe 'Basic Elements', ->
  before ->
    framer.app.loadFile './testData/basicElements.json'

  describe 'grid', ->
    it 'should be a 4 x 2 table', ->
      table = $ '#framer_pages #grid table'
      rows = $ '#framer_pages #grid table tr'
      cells = $ '#framer_pages #grid table tr td'
      assert.equal table.length, 1
      assert.equal rows.length, 4
      assert.equal cells.length, 8

  describe 'checkbox', ->
    it 'should be a checkbox that is checked', ->
      framer.app_view.projectView.showPageSlug('checkbox')
      checkbox = $ '#framer_pages #checkbox .framer-element input'
      assert.equal checkbox.length, 1
      assert.equal checkbox.attr("type"), "checkbox"
      assert.ok checkbox.is(":checked")

  describe 'checkbox group', ->
    it 'should be a checkbox list with one that is checked and one that is not', ->
      framer.app_view.projectView.showPageSlug('checkboxList')
      checkboxes = $ '#framer_pages #checkboxList .framer-element input'
      assert.equal checkboxes.length, 2
      assert.equal $(checkboxes[0]).attr("type"), "checkbox"
      assert.equal $(checkboxes[1]).attr("type"), "checkbox"
      assert.ok $(checkboxes[1]).is(":checked")
      assert.ok !($(checkboxes[0]).is(":checked"))

  describe 'link', ->
    it 'should be a link with yellow text', ->
      framer.app_view.projectView.showPageSlug('link')
      link = $ '#framer_pages #link a.framer-element span'
      assert.equal link.length, 1
      assert.equal $(link).css("color"), "rgb(255, 255, 0)"
    it 'should link to #checkboxList', ->
      link = $ '#framer_pages #link a.framer-element'
      assert.equal link.attr("href"), "#checkboxList"
