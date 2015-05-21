assert = require "assert"
boolean = require "../src/plugins/validations/boolean.coffee"
number = require "../src/plugins/validations/number.coffee"
string = require "../src/plugins/validations/string.coffee"

describe "Boolean validation", ->
  it "should be false", ->
    assert.equal boolean(false), false

  it "should be true", ->
    assert.equal boolean(true), true

describe "Number validation", ->
  it "should be 43", ->
    assert.equal number("43 things"), 43

  it "should be 28", ->
    assert.equal number("28in"), 28

describe "String validation", ->
  it "should be 'hi there jeff'", ->
    assert.equal string("hi there jeff"), "hi there jeff"
