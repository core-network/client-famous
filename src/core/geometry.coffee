{ atan2, cos, sin, sqrt } = Math

class Geometry
  @rectangular: ({radius, angle}) ->
    throw new Error unless radius? and angle?
    x = radius * cos angle
    y = radius * sin angle
    {x, y}

  @polar: ({x, y}) ->
    throw new Error unless x? and y?
    radius = Geometry.distance {x: 0, y: 0}, {x, y}
    angle = atan2 y, x
    {radius, angle}

  @distance: (start, end) ->
    throw new Error unless start.x? and start.y?
    throw new Error unless end.x? and end.y?
    sqrt(
      (start.x - end.x) * (start.x - end.x) +
      (start.y - end.y) * (start.y - end.y)
    )

  @vector: (start, end) ->
    throw new Error unless start.x? and start.y?
    throw new Error unless end.x? and end.y?
    x: end.x - start.x
    y: end.y - start.y

module.exports = Geometry
