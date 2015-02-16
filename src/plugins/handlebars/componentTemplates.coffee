Handlebars = require 'handlebars'
fs = require 'fs'
templates = {}

# register all templates
partials = fs.readdirSync __dirname+'/templates'
for partial in partials
  handle = partial.replace /\..*/, ""
  Handlebars.registerPartial handle, fs.readFileSync(__dirname+'/templates/'+partial).toString()
  templates[handle] = Handlebars.compile("{{> #{handle}}}")

module.exports.getTemplate = (handle) ->
  return templates[handle]
