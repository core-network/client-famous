famous = require 'famous'
{json, log, p, pjson} = require 'lightsaber'

DOMElement = famous.domRenderables.DOMElement
FamousNode = famous.core.Node
Vec3 = famous.math.Vec3
Opacity = famous.components.Opacity

{sin, cos, sqrt, abs} = Math

class Node extends FamousNode
  DEFAULT_SIZE: 50
  PROPS: [
    'id'
    'name'
  ]

  constructor: (data) ->
    super
    @set data
    @z ?= 0
    # p args
    # @set args
    throw new Error unless @id?
    @setOrigin 0.5, 0.5, 0.5
    @setMountPoint 0.5, 0.5, 0.5
    @setAlign 0.5, 0.5, 0.5
    @setSizeMode 'absolute', 'absolute', 'absolute'
    @opacity = new Opacity @

    new DOMElement @,
      content: @svgDot()

    text = @addChild()
    text.setSizeMode 'absolute', 'absolute', 'absolute'
    text.setAbsoluteSize 333, @size
    new DOMElement text,
      content: @name
      opacity: 0.9
      properties:
        color: "#9FDAFF"
        textAlign: "left"
        lineHeight: "#{@size}px"
        fontFamily: "Open Sans"
        marginLeft: "#{@size}px"
        paddingLeft: "5px"

  set: (data) ->
    p @PROPS
    for own key, value of data when key in @PROPS
      @[key] = value
    @z ?= 0
    @angle = 0 if @radius is 0
    if @radius? and @angle?
      # throw new Error if @x? or @y?
      @x = @radius * cos @angle
      @y = @radius * sin @angle
    @x ?= 0
    @y ?= 0
    @size ?= @DEFAULT_SIZE
    @setAbsoluteSize @size, @size, @size
    @setPosition @x, @y, @z

  on: (eventType, callback) ->
    @addUIEvent eventType
    @onReceive = (event, payload) ->
      callback payload if event is eventType

  glowSize: ->
    @size * 2

  svgDot: ->
    svg = """
      <svg style="width: #{@glowSize()}px; height: #{@glowSize()}px; position: relative; top: -50%; left: -50%;">
        <defs>
          <filter id="glow" filterUnits="userSpaceOnUse" x="0%" y="0%" width="140%" height="140%">
            <feOffset result="offOut" in="SourceGraphic" dx="0" dy="0" />
            <feGaussianBlur result="blurOut" in="offOut" stdDeviation="10" />
            <feBlend in="SourceGraphic" in2="blurOut" mode="normal" />
          </filter>
        </defs>
        <circle
          cx="#{@glowSize()/2}"
          cy="#{@glowSize()/2}"
          r="#{@size/2}"
          fill="#9DDCFA"
          filter="url(#glow)"
        />
      </svg>
      """
    svg.replace /\s+/g, ' '

  getPosition: ->
    new Vec3 @x, @y, @z

  onHide: (transition = {duration: 1000}) ->
    new Promise (resolve, reject) =>
      @opacity.set 0, transition, =>
        @dismount()
        resolve()

module.exports = Node
