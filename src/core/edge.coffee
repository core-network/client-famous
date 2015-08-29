famous = require 'famous'
DOMElement = famous.domRenderables.DOMElement
FamousNode = famous.core.Node
Opacity = famous.components.Opacity

{json, log, p, pjson} = require 'lightsaber'
Promise = require 'bluebird'
nodesphere = require 'nodesphere'

{distance, polar, vector} = require '../core/geometry'

{sin, cos, sqrt, abs} = Math

class Edge extends FamousNode
  constructor: ({@edge}) ->
    super
    throw new Error "Constructor arg 'edge' must a Nodesphere Edge, got #{json @edge}" unless @edge instanceof nodesphere.Edge
    @setOrigin 0.5, 0.5, 0.5
    @setMountPoint 0.5, 0.5, 0.5
    @setAlign 0.5, 0.5, 0.5
    @setSizeMode 'absolute', 'absolute', 'absolute'
    @opacity = new Opacity @
    @element = new DOMElement @

  render: ->
    @setPosition @start.x, @start.y, @start.z-100
    @setRotation 0, 0, polar(vector @start, @end).angle
    @length = distance @start, @end
    @curve = @length / 9
    @element.setContent @svgCurve()

  hide: (transition = {duration: 1000}) ->
    new Promise (resolve, reject) =>
      @opacity.set 0, transition, =>
        @dismount()
        resolve()

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
      <svg style="width: #{@length}px; height: #{@length/4}px; position: absolute; top: 0; left: 0;">
        <path
          d="#{data}"
          stroke="#73BAE7"
          stroke-opacity="0.2"
          stroke-width="5"
          fill="transparent"
        />
      </svg>
      """
    # Uncomment this for labels
    # svg += """
    #   <div style="color: white; white-space: nowrap; position: absolute; top: 0; left: 0;">#{@start.name} -> #{@end.name}</div>
    #   """
    svg.replace /\s+/g, ' '

module.exports = Edge
