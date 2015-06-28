'use strict'
famous = require 'famous'
{json, log, p, pjson} = require 'lightsaber'

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
    throw new Error unless @id?
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
    #    p "start [ID: #{@start?.id}] end [ID: #{@end?.id}]"
    throw new Error "Missing start [ID: #{@start?.id}] and/or end [ID: #{@end?.id}] in 'args' " unless @start? and @end?
    @setOrigin 0.5, 0.5, 0.5
    @setMountPoint 0.5, 0.5, 0.5
    @setAlign 0.5, 0.5, 0.5
    @setSizeMode 'absolute', 'absolute', 'absolute'
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
    @sceneRoot = scene.addChild()
    # @sceneRoot.addComponent
    #   XXX do this is right order... promises?
    #   onMount: @_layout.bind @

  radialLayout: (args) ->
    args.sceneRoot ?= @sceneRoot
    new RadialLayout args

class RadialLayout
  constructor: (args) ->
    @vertices = {}
    @render args

  render: (input) ->
    { @sceneRoot, rootNodeId } = input

    rootVertex = new Vertex x: 0, y:0, id: rootNodeId
    @addVertex rootVertex

    # first ring
    for node, i in input.nodes[0...6]
      nodeId = node.id
      vertex =  new Vertex
        radius: 100
        angle: Sector.angle i
        id: nodeId
      @addVertex vertex

    # second ring
    for node, i in input.nodes[6...18]
      nodeId = node.id
      vertex =  new Vertex
        radius: 200
        angle: Sector.angle(i/2) - Sector.SECTOR_RADIANS/2
        id: nodeId
      @addVertex vertex

    # third ring
    for node, i in input.nodes[18...36]
      nodeId = node.id
      vertex =  new Vertex
        radius: 300
        angle: Sector.angle(i/3) - Sector.SECTOR_RADIANS*2/3
        id: nodeId
      @addVertex vertex

    for edge in input.edges
      [startId, endId] = edge
      @sceneRoot.addChild new Edge
        start: @getVertex startId
        end: @getVertex endId

  addVertex: (vertex) ->
    @saveVertex vertex
    @sceneRoot.addChild vertex

  saveVertex: (vertex) ->
    if @vertices[vertex.id]?
      throw new Error "Vertex with ID #{vertex.id} already exists in @vertices"
    @vertices[vertex.id] = vertex

  getVertex: (vertexId) ->
    @vertices[vertexId] or throw new Error

main = ->
  nodes = for i in [1..36]
    id: "id#{i}"
  rootNodeId = "id0"
  edges = for node in nodes when node.id isnt rootNodeId
    [rootNodeId, node.id]

  #  console.log "nodes", nodes
  #  console.log "edges", edges

  new World().radialLayout { rootNodeId, nodes, edges }

main()
