famous = require 'famous'
{json, log, p, pjson} = require 'lightsaber'

DOMElement = famous.domRenderables.DOMElement
FamousNode = famous.core.Node

{sin, cos, sqrt, abs} = Math

class Edge extends FamousNode
  constructor: (args) ->
    super
    @set args
    @setOrigin 0.5, 0.5, 0.5
    @setMountPoint 0.5, 0.5, 0.5
    @setAlign 0.5, 0.5, 0.5
    @setSizeMode 'absolute', 'absolute', 'absolute'
    @element = new DOMElement @

  set: (args) ->
    {@start, @end} = args
    throw new Error "Missing start [ID: #{@start?.id}] and/or end [ID: #{@end?.id}] in 'args' " unless @start? and @end?
    @id = "#{@start.id} -> #{@end.id}"

  render: ->
    @setPosition @start.x, @start.y, @start.z-100
    @setRotation 0, 0, @end.angle
    @length = sqrt(
      (@start.x - @end.x) * (@start.x - @end.x) +
      (@start.y - @end.y) * (@start.y - @end.y)
    )
    @curve = @length / 9
    # debugger
    @element.setContent @svgCurve()

  svgCurve: ->
    data = """
      M
        0 0
      C
        #{@curve}           #{@curve},
        #{@length - @curve} #{@curve},
        #{@length}          0
      """
    svg = """
      <svg>
        <path
          d="#{data}"
          stroke="#73BAE7"
          stroke-opacity="0.2"
          stroke-width="5"
          fill="transparent"
        />
      </svg>
      """
    svg.replace /\s+/g, ' '

module.exports = Edge
