Handlebars = require 'handlebars'
fs = require 'fs'
templates = {}

# register all templates
partials = fs.readdirSync global.cfg.templateDir
for partial in partials
  handle = partial.replace /\..*/, ""
  Handlebars.registerPartial handle, fs.readFileSync(global.cfg.templateDir+partial).toString()
  templates[handle] = Handlebars.compile("{{> #{handle}}}")

module.exports.getTemplate = (handle) ->
  return templates[handle]
