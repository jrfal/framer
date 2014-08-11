$ = require 'jquery'
$.event.props.push 'dataTransfer'
$.event.props.push 'clientX'
$.event.props.push 'clientY'

uiTemplates = require './uiTemplates.coffee'

controlDragHandler = (e) ->
  dragData = {id: e.target.id, action: 'move', startX: e.clientX - e.target.offsetLeft, startY: e.clientY - e.target.offsetTop}
  e.dataTransfer.setData('text/plain', JSON.stringify(dragData))
  $(e.target).addClass 'dragging'

controlDragStopHandler = (e) ->
  $(e.target).removeClass 'dragging'

  false

moveControlBox = (control_id, x, y) ->
  control_el = $("##{control_id}")
  element_id = control_el.data("element")

  control_el.css 'left', x
  control_el.css 'top', y
  $("##{element_id}").css 'position', 'absolute'
  $("##{element_id}").css 'left', x
  $("##{element_id}").css 'top', y

resizeControlBox = (control_id, width, height) ->
  control_el = $("##{control_id}")
  element_id = control_el.data("element")

  control_el.css('width', width)
  control_el.css('height', height)
  $("##{element_id}").css('width', width)
  $("##{element_id}").css('height', height)

updateText = (element_id, newText) ->
  $("##{element_id}").find('.framer-text').html(newText)

updateFontFamily = (element_id, newFont) ->
  $("##{element_id}").find('.framer-text').css("font-family", newFont)

updateFontSize = (element_id, newSize) ->
  $("##{element_id}").find('.framer-text').css("font-size", newSize + "px")

controlDropHandler = (e) ->
  dragData = JSON.parse(e.dataTransfer.getData("text/plain"))

  if dragData.action == 'move'
    x = e.clientX - dragData.startX
    y = e.clientY - dragData.startY
    moveControlBox dragData.id, x, y
  else if dragData.action == 'resize'
    width = Math.abs e.clientX - dragData.x
    height = Math.abs e.clientY - dragData.y
    resizeControlBox dragData.id, width, height

resizeDragHandler = (e) ->
  target = $(e.target).parent()
  dragData = {id: target.attr("id"), action: 'resize', x: target.offset().left, y: target.offset().top}
  e.dataTransfer.setData('text/plain', JSON.stringify(dragData))

  e.stopPropagation()

resizeDragStopHandler = (e) ->
  e.preventDefault()
  false

renderControls = ->
  $("#framer_controls").empty()
  id_num = 0
  $("#framer_pages .framer-page:visible .framer-element").each ->
    el_id = $(this).attr "id"
    if !el_id?
      el_id = "element_#{id_num}"
      $(this).attr "id", el_id
    controlBox = $ "<div id=\"control_box_#{id_num}\" \
      class=\"control-box\" draggable=\"true\" data-element=\"#{el_id}\"><div \
        class=\"resize-handle\" draggable=\"true\"></div>\
          <div class=\"text-edit-handle\">T</div></div>"
    $("#framer_controls").append controlBox
    id_num++

createTextEditBox = (id) ->
  text = $('#'+id).find('.framer-text').html()
  box = $ uiTemplates.propertyPanel({id: id, textValue: text})
  $('#framer_controls').append(box)

textEditHandler = (e) ->
  createTextEditBox($(e.target).closest('.control-box').data('element'))

module.exports.controlDragHandler = controlDragHandler
module.exports.controlDragStopHandler = controlDragStopHandler
module.exports.moveControlBox = moveControlBox
module.exports.resizeControlBox = resizeControlBox
module.exports.controlDropHandler = controlDropHandler
module.exports.resizeDragHandler = resizeDragHandler
module.exports.resizeDragStopHandler = resizeDragStopHandler
module.exports.renderControls = renderControls
module.exports.textEditHandler = textEditHandler
module.exports.updateText = updateText
module.exports.updateFontFamily = updateFontFamily
module.exports.updateFontSize = updateFontSize
