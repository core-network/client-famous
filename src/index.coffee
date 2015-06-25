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
    # Center dot.
    @setOrigin(0.5, 0.5, 0.5)
    @setMountPoint(0.5, 0.5, 0.5)
    @setAlign(0.5, 0.5, 0.5)
    @setSizeMode('absolute', 'absolute', 'absolute')
    @setAbsoluteSize @size, @size, @size
    @setPosition @x, @y, @z

    # dotScale = new famous.components.Scale dot
    # dotScale.set 0.1, 0.1, 0.1

    # Add the DOMElement (DOMElements are components).
    @el = new DOMElement @,
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
    @length = sqrt(
      (@start.x - @end.x) * (@start.x - @end.x) +
      (@start.y - @end.y) * (@start.y - @end.y)
    )
    @curve = @length / 5
    @el = new DOMElement @,
      content: @bezier()

  bezier: ->
    """
      <svg>
        <path
          d="M0 0 C #{@curve} #{@curve}, #{@length - @curve} #{@curve}, #{@length} #{0}"
          stroke="black"
          fill="transparent"
        />
      </svg>
    """

class World
  constructor: ->
    clock = FamousEngine.getClock()
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
    for node, i in @nodes[0...10]
      vertex =  new Vertex
        radius: 100
        angle: i * 2*π / 10
        id: node
      @root.addChild vertex
      @nodes[node] = vertex

    # second ring
    for node, i in @nodes[10...30]
      vertex =  new Vertex
        radius: 200
        angle: i * 2*π / 20
        id: node
      @root.addChild vertex
      @nodes[node] = vertex

    for edge in @edges
      [startId, endId] = edge
      @root.addChild new Edge
        start: @nodes[startId]
        end: @nodes[endId]

nodes = for i in [0..30]
  "id#{i}"
rootId = nodes.shift()
edges = for node in nodes
  [rootId, node]

#console.log "nodes", nodes
#console.log "edges", edges

new World()
  .layout { rootId, nodes, edges }

