Backbone = require 'backbone'
_ = require 'underscore'

class Guide extends Backbone.Model
  defaults:
    type: 'grid'

class GridGuide extends Guide
  defaults:
    type: 'grid'
    cellSize: 8
    cellGroup: 10
    lineColor: "gray"

  getGeosFor: (geo) ->
    geos = []
    if geo.x?
      geos.push {x: Math.round(geo.x/@attributes.cellSize) * @attributes.cellSize}
    if geo.y?
      geos.push {y: Math.round(geo.y/@attributes.cellSize) * @attributes.cellSize}
    return geos

class ElementsGuide extends Guide
  defaults:
    type: 'elements'
    page: null

  getGeosFor: (geo) ->
    geos = []

    page = @get "page"
    xGeo = null
    yGeo = null
    if page?
      for element in page.get("elements").models
        for elGeo in element.getGeos()
          if geo.x? and elGeo.x?
            if xGeo == null
              xGeo = elGeo
            else if Math.abs(geo.x - elGeo.x) < Math.abs(geo.x - xGeo.x)
              xGeo = elGeo
          if geo.y? and elGeo.y?
            if yGeo == null
              yGeo = elGeo
            else if Math.abs(geo.y - elGeo.y) < Math.abs(geo.y - yGeo.y)
              yGeo = elGeo
    geos.push xGeo if xGeo?
    geos.push yGeo if yGeo?

    return geos

module.exports.Guide = Guide
module.exports.Grid = GridGuide
module.exports.Elements = ElementsGuide
