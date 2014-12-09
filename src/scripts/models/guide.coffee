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

  getGeosFor: (geo) ->
    geos = []
    if geo.x?
      geos.push {x: Math.round(geo.x/@attributes.cellSize) * @attributes.cellSize}
    if geo.y?
      geos.push {y: Math.round(geo.y/@attributes.cellSize) * @attributes.cellSize}
    return geos

module.exports.Guide = Guide
module.exports.Grid = GridGuide
