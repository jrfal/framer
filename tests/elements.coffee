global.cfg = require './scripts/config.coffee'
global.document = require('jsdom').jsdom()
global.window = document.defaultView
$ = require 'jquery'

assert = require "assert"
Page = require "../src/scripts/models/page.coffee"
Element = require "../src/scripts/models/element.coffee"

plugins = require '../src/plugins/plugins.coffee'
components = plugins.components

setup = require './setups.coffee'

describe "Create a checkbox", ->
  data = null
  element = null

  before ->
    data = setup.appSetup()
    element = setup.addComponent data.page, "checkbox"

  it "should be an input[type=checkbox] element", ->
    assert.equal $("input[type=checkbox]").length, 1

  it "should be indeterminate if I set it that way", ->
    element.set "indeterminate", true
    assert $("input[type=checkbox]").prop("indeterminate")

  it "should have red text color if I set it that way", ->
    element.set "fontColor", "#ff0000"
    assert.equal $("input[type=checkbox]").parent().find(".framer-text").css("color"), "rgb(255, 0, 0)"

describe "Create a text input", ->
  data = null
  element = null

  before ->
    data = setup.appSetup()
    element = setup.addComponent data.page, "textInput"

  it "should be an input[type=text] element", ->
    assert.equal $("input[type=text]").length, 1

describe "Create a text block", ->
  data = null
  element = null

  before ->
    data = setup.appSetup()
    element = setup.addComponent data.page, "textBlock"
    element.set "text", """
# Here
## is
### a
#### test of Markdown

**boldly** _askew_

+ a
+ list
+ of
+ things"""

  reference = """
<h1>Here</h1>
<h2>is</h2>
<h3>a</h3>
<h4>test of Markdown</h4>
<p><strong>boldly</strong> <em>askew</em></p>
<ul>
<li>a</li>
<li>list</li>
<li>of</li>
<li>things</li>
</ul>

  """

  it "should have content to match the formatted reference", ->
    assert.equal $("[data-element=#{element.get('id')}] .framer-text").html(), reference

describe "Create a number input", ->
  data = null
  element = null

  before ->
    data = setup.appSetup()
    element = setup.addComponent data.page, "numberInput"

  it "should have a number input element", ->
    assert.equal $("#framer_pages input[type=number]").length, 1
