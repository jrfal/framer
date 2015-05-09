$ = require "jquery"

class BasicPost

  postRender: (el) ->
    $(el).find(".wirekit-indeterminate").prop("indeterminate", true)

module.exports = BasicPost
