_ = require 'underscore'

class Snapper
  constructor: () ->
    @guides = []
    @active = true

  addGuide: (newGuide) ->
    for guide in @guides
      if newGuide == guide
        return
    @guides.push newGuide

  getGeosCorner: (geos) ->
    corner = {}
    for geo in geos
      if geo.x?
        if corner.x?
          if geo.x < corner.x
            corner.x = geo.x
        else
          corner.x = geo.x
      if geo.y?
        if corner.y?
          if geo.y < corner.y
            corner.y = geo.y
        else
          corner.y = geo.y
    corner.x = 0 if not corner.x?
    corner.y = 0 if not corner.y?

    return corner

  moveGeos: (geos, translateX, translateY) ->
    for geo in geos
      geo.x = geo.x + translateX if geo.x?
      geo.y = geo.y + translateY if geo.y?

  getOffset: (geo1, geo2) ->
    if geo1.x? and geo2.x?
      if geo1.y? and geo2.y?
        return {x: geo2.x - geo1.x, y: geo2.y - geo1.y, distance: Math.sqrt(((geo1.x - geo2.x) ** 2) + ((geo1.y - geo2.y) ** 2))}
      else
        return {x: geo2.x - geo1.x, distance: Math.abs(geo1.x - geo2.x)}
    else if geo1.y? and geo2.y?
      return {y: geo2.y - geo1.y, distance: Math.abs(geo1.y - geo2.y)}

    return {}

  getSnap: (geos) ->
    if not @active
      return {x: 0, y: 0}
    offsets = []
    for guide in @guides
      for geo in geos
        for geo2 in guide.getGeosFor(geo)
          offsets.push @getOffset(geo, geo2)
    offsets = _.sortBy offsets, (item) ->
      if item.distance?
        return item.distance
      return 100000

    snapping = {}
    while (not snapping.x? or not snapping.y?) and offsets.length > 0
      offset = offsets.shift()
      if not snapping.x?
        if offset.x?
          snapping.x = offset.x
      if not snapping.y?
        if offset.y?
          snapping.y = offset.y
    snapping.x = 0 if not snapping.x?
    snapping.y = 0 if not snapping.y?

    return snapping

module.exports = Snapper
