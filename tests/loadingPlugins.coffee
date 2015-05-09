_ = require "underscore"
assert = require "assert"

delete require.cache[require.resolve("../src/plugins/handlebars/components.json")]
handlebars = require "../src/plugins/handlebars/handlebars.coffee"
basicPost = require "../src/plugins/basicPost/basicPost.coffee"

describe "Don't load any plugins", ->
  plugins = null

  before ->
    plugins = {components:[], renderers: []}
  it "should not have a 'checkbox' component", ->
    assert (not _.findWhere(plugins.components, {component: "checkbox"})?)

describe "Load handlebars plugins", ->
  plugins = null

  before ->
    plugins = {components:[], renderers: []}
    handlebars.register plugins

  it "should have a 'checkbox' component", ->
    assert _.findWhere(plugins.components, {component: "checkbox"})?

  it "should match reference component object", ->
    reference =
      "title": "Checkbox"
      "component": "checkbox"
      "text": "Checkbox"
      "renderers": [
        "handlebars"
      ]
      "properties": [
        {"inherit": "label"}
        {"property": "selected", "type": "boolean"}
      ]
    checkbox = _.findWhere(plugins.components, {component: "checkbox"})

    assert.deepEqual reference, checkbox

describe "Load handlebars plugin and basicPost plugin", ->
  plugins = null

  before ->
    plugins = {components:[], renderers: [], postRenderers: []}

    handlebars.register plugins
    basicPost.register plugins

  it "should match the 'checkbox' component to a reference object", ->
    reference =
      "title": "Checkbox"
      "component": "checkbox"
      "text": "Checkbox"
      "renderers": [
        "handlebars"
      ]
      "postRenderers": [
        "basicPost"
      ]
      "properties": [
        {"inherit": "label"}
        {"property": "selected", "type": "boolean"}
        {"property": "indeterminate", "type": "boolean"}
      ]
    checkbox = _.findWhere(plugins.components, {component: "checkbox"})

    assert.deepEqual reference, checkbox
