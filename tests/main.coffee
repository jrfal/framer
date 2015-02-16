Mocha = require 'mocha'
fs = require 'fs'
path = require 'path'

testFiles = fs.readdirSync('.').filter (name) ->
  return (/^test\..*\.coffee$/).test(name)
# testFiles = fs.readdirSync('.').filter (name) ->
#   return (/^test\.(loadfile)\.coffee$/).test(name)

# watchFiles = Mocha.utils.files(path.join(process.cwd(), '..')).filter (name) ->
#   return name != __filename

# Mocha.utils.watch watchFiles, ->
#   window.location.reload();

exports.run = ->
  # watchFiles.forEach (file) ->
  #   delete require.cache[file]

  mocha = new Mocha()
  mocha.reporter 'html'
  mocha.ui 'bdd'

  query = Mocha.utils.parseQuery(window.location.search || '')
  if query.grep
    mocha.grep query.grep
  if query.invert
    mocha.invert()

  mocha.files = testFiles;

  mocha.run ->
    Mocha.utils.highlightTags 'code'
    # console.log 'Waiting for changes...'
