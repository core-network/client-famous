famous = require 'famous'
{json, log, p, pjson} = require 'lightsaber'

DOMElement = famous.domRenderables.DOMElement
FamousNode = famous.core.Node

#π = Math.PI
{sin, cos, sqrt, abs} = Math

class Node extends FamousNode
  defaultSize: 50

  constructor: (args) ->
    super
    { @x, @y, @z, @radius, @angle, @size, @id } = args
    throw new Error unless @id?
    @z ?= 0
    @angle = 0 if @radius is 0
    if @radius? and @angle?
      throw new Error if @x? or @y?
      @x = @radius * cos @angle
      @y = @radius * sin @angle
    @size ?= @defaultSize
    @setOrigin 0.5, 0.5, 0.5
    @setMountPoint 0.5, 0.5, 0.5
    @setAlign 0.5, 0.5, 0.5
    @setSizeMode 'absolute', 'absolute', 'absolute'
    @setAbsoluteSize @size, @size, @size
    @setPosition @x, @y, @z

    new DOMElement @,
      content: @svgDot()

    text = @addChild()
    new DOMElement text,
      content: @id
      opacity: 0.9
      properties:
        color: "#9FDAFF"
        textAlign: "left"
        lineHeight: "#{@size}px"
        fontFamily: "Open Sans"
        marginLeft: "#{@size}px"
        paddingLeft: "5px"

  svgDot: ->
    svg = """
      <svg style="position: relative; top: -50%; left: -50%;">
        <defs>
          <filter id="glow" filterUnits="userSpaceOnUse" x="0%" y="0%" width="140%" height="140%">
            <feOffset result="offOut" in="SourceGraphic" dx="0" dy="0" />
            <feGaussianBlur result="blurOut" in="offOut" stdDeviation="10" />
            <feBlend in="SourceGraphic" in2="blurOut" mode="normal" />
          </filter>
        </defs>
        <circle
          cx="#{@size}"
          cy="#{@size}"
          r="#{@size/2}"
          fill="#9DDCFA"
          filter="url(#glow)"
        />
      </svg>
    """
    svg.replace /\s+/g, ' '

module.exports = Node
