'use strict'
famous = require('famous')

DOMElement = famous.domRenderables.DOMElement
FamousEngine = famous.core.FamousEngine
Node = famous.core.Node

π = Math.PI
{sin, cos} = Math

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

class World
  constructor: ->
    clock = FamousEngine.getClock()
    FamousEngine.init()
    scene = FamousEngine.createScene()
    @root = scene.addChild()

  layout: (args) ->
    { rootId, nodes, edges } = args
    rootVertex = new Vertex x: 0, y:0, id: rootId
    @root.addChild rootVertex
    for node, i in nodes
      @root.addChild new Vertex
        radius: 100
        angle: i * 2*π / 10
        id: node


nodes = for i in [0..50]
  "id#{i}"
rootId = "id0"
edges = for node in nodes
  [rootId, node]

#console.log "nodes", nodes
#console.log "edges", edges

new World()
  .layout { rootId, nodes, edges }

