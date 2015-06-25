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
    if @radius? and @angle?
      @x = @radius * cos @angle
      @y = @radius * sin @angle
    @size or= @defaultSize
    @setOrigin(0.5, 0.5, 0.5)
    @setMountPoint(0.5, 0.5, 0.5)
    @setAlign(0.5, 0.5, 0.5)
    @setSizeMode('absolute', 'absolute', 'absolute')
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
    @setOrigin(0.5, 0.5, 0.5)
    @setMountPoint(0.5, 0.5, 0.5)
    @setAlign(0.5, 0.5, 0.5)
    @setSizeMode('absolute', 'absolute', 'absolute')
    @setAbsoluteSize @size, @size, @size
    @setPosition @start.x, @start.y, @start.z
    @setRotation 0, 0, @end.angle
    @length = sqrt(
      (@start.x - @end.x) * (@start.x - @end.x) +
      (@start.y - @end.y) * (@start.y - @end.y)
    )
    @curve = @length / 9
    new DOMElement @,
      content: @bezier()

  bezier: ->
    """
      <svg>
        <path
          d="M 0 0 C #{@curve} #{@curve}, #{@length - @curve} #{@curve}, #{@length} #{0}"
          stroke="black"
          fill="transparent"
        />
      </svg>
    """

class Hex
  @SECTORS = 6
  @CIRCLE_RADIANS = 2*π
  @SECTOR_RADIANS = @CIRCLE_RADIANS / @SECTORS
  @FIRST_SECTOR_DEGREES = 60

  @sector_origin: ->
    noon = @CIRCLE_RADIANS * 0.75    # "12 o'clock", where radians start at "3 o'clock"
    first_sector_radians = ( @FIRST_SECTOR_DEGREES / 360 ) * @CIRCLE_RADIANS
    (noon + first_sector_radians) % @CIRCLE_RADIANS

  @sector_angle: (sector) ->
    sector * @SECTOR_RADIANS + @sector_origin()

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

  sector_origin: ->
    noon = CIRCLE_RADIANS * 0.75    # "12 o'clock", where radians start at "3 o'clock"
    first_sector_radians = ( @config('first-sector-degrees') / 360 ) * CIRCLE_RADIANS
    (noon + first_sector_radians) % CIRCLE_RADIANS

  sector_angle: (sector) ->
    sector * SECTOR_RADIANS + @sector_origin()

  _layout: ->
    rootVertex = new Vertex x: 0, y:0, id: @rootId
    @nodes[@rootId] = rootVertex
    @root.addChild rootVertex

    # first ring
    for node, i in @nodes[0...6]
      vertex =  new Vertex
        radius: 100
        angle: Hex.sector_angle i
        id: node
      @root.addChild vertex
      @nodes[node] = vertex

    # second ring
    for node, i in @nodes[6...18]
      vertex =  new Vertex
        radius: 200
        angle: Hex.sector_angle(i/2) - Hex.SECTOR_RADIANS/2
        id: node
      @root.addChild vertex
      @nodes[node] = vertex

    # third ring
    for node, i in @nodes[18...36]
      vertex =  new Vertex
        radius: 300
        angle: Hex.sector_angle(i/3) - Hex.SECTOR_RADIANS*2/3
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

