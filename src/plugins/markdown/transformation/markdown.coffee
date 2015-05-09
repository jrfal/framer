MarkDown = require "markdown-it"
md = new MarkDown()

module.exports = (text) ->
  return md.render(text)
