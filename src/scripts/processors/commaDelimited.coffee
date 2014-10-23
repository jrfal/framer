module.exports = (text) ->
  object = {data: []}
  lines = text.split /[\r\n]/
  for line in lines
    object.data.push line.split /\s?\,\s?/
  return object
