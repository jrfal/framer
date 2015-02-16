module.exports = (text) ->
  html = text
  html = html.replace /\[\s?\]/g, '<input type="checkbox" />'
  html = html.replace /\[[Xx]\]/g, '<input type="checkbox" checked="checked" />'
  return html
