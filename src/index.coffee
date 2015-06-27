'use strict'
famous = require('famous')

DOMElement = famous.domRenderables.DOMElement
FamousEngine = famous.core.FamousEngine
Node = famous.core.Node

π = Math.PI
{sin, cos, sqrt} = Math

class Vertex extends Node
  defaultSize: 50

  constructor: (args) ->
    super
    { @x, @y, @z, @radius, @angle, @size, @id } = args
    @z ?= 0
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

    # dotScale = new famous.components.Scale dot
    # dotScale.set 0.1, 0.1, 0.1

    new DOMElement @,
      content: @id
      properties:
        background: 'blue'
        borderRadius: '100%'
        color: 'white'
        textAlign: 'center'
        lineHeight: "#{@size}px"
        fontFamily: "sans"

class Edge extends Node
  constructor: (args) ->
    super
    {@start, @end} = args
    @setOrigin 0.5, 0.5, 0.5
    @setMountPoint 0.5, 0.5, 0.5
    @setAlign 0.5, 0.5, 0.5
    @setSizeMode 'absolute', 'absolute', 'absolute'
    @setAbsoluteSize @size, @size, @size
    @setPosition @start.x, @start.y, @start.z-100
    @setRotation 0, 0, @end.angle
    @length = sqrt(
      (@start.x - @end.x) * (@start.x - @end.x) +
      (@start.y - @end.y) * (@start.y - @end.y)
    )
    @curve = @length / 9
    new DOMElement @,
      content: @svgCurve()

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
          stroke="black"
          fill="transparent"
        />
      </svg>
      """
    svg.replace /\s+/g, ' '

class Sector
  @SECTORS = 6
  @CIRCLE_RADIANS = 2*π
  @SECTOR_RADIANS = @CIRCLE_RADIANS / @SECTORS
  @FIRST_SECTOR_DEGREES = 60

  @origin: ->
    noon = @CIRCLE_RADIANS * 0.75    # "12 o'clock", where radians start at "3 o'clock"
    first_sector_radians = ( @FIRST_SECTOR_DEGREES / 360 ) * @CIRCLE_RADIANS
    (noon + first_sector_radians) % @CIRCLE_RADIANS

  @angle: (sector) ->
    sector * @SECTOR_RADIANS + @origin()

class World
  constructor: ->
    FamousEngine.init()
    scene = FamousEngine.createScene()
    @root = scene.addChild()
    @nodes = {}
    # @root.addComponent
    #   XXX do this is right order... promises?
    #   onMount: @_layout.bind @

  layout: (args) ->
    { @rootId, @nodes, @edges } = args
    @_layout()

  _layout: ->
    rootVertex = new Vertex x: 0, y:0, id: @rootId
    @nodes[@rootId] = rootVertex
    @root.addChild rootVertex

    # first ring
    for node, i in @nodes[0...6]
      vertex =  new Vertex
        radius: 100
        angle: Sector.angle i
        id: node
      @root.addChild vertex
      @nodes[node] = vertex

    # second ring
    for node, i in @nodes[6...18]
      vertex =  new Vertex
        radius: 200
        angle: Sector.angle(i/2) - Sector.SECTOR_RADIANS/2
        id: node
      @root.addChild vertex
      @nodes[node] = vertex

    # third ring
    for node, i in @nodes[18...36]
      vertex =  new Vertex
        radius: 300
        angle: Sector.angle(i/3) - Sector.SECTOR_RADIANS*2/3
        id: node
      @root.addChild vertex
      @nodes[node] = vertex

    for edge in @edges
      [startId, endId] = edge
      @root.addChild new Edge
        start: @nodes[startId]
        end: @nodes[endId]

nodes = for i in [0..36]
  "id#{i}"
rootId = nodes.shift()
edges = for node in nodes
  [rootId, node]

#console.log "nodes", nodes
#console.log "edges", edges

new World()
  .layout { rootId, nodes, edges }

