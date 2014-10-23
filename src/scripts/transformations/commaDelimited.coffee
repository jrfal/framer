module.exports = (text) ->
  table = []
  lines = text.split /[\r\n]/
  for line in lines
    table.push line.split /\s?\,\s?/
  return table
