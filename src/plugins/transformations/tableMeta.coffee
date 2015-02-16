module.exports = (table) ->
  tableMeta = []
  even = true
  for row in table
    tableMeta.push {even: even, columns: row}
    if even
      even = false
    else
      even = true
  return tableMeta
