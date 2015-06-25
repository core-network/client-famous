'use strict'
famous = require('famous')

DOMElement = famous.domRenderables.DOMElement
FamousEngine = famous.core.FamousEngine
Node = famous.core.Node

class Vertex extends Node
  defaultSize: 200

  constructor: (args) ->
    super
    { x, y, z, @size } = args
    @size or= @defaultSize
    # Center dot.
    @setOrigin(0.5, 0.5, 0.5)
    @setMountPoint(0.5, 0.5, 0.5)
    @setAlign(0.5, 0.5, 0.5)
    @setSizeMode('absolute', 'absolute', 'absolute')
    @setAbsoluteSize @size, @size, @size

    # dotScale = new famous.components.Scale dot
    # dotScale.set 0.1, 0.1, 0.1

    # Add the DOMElement (DOMElements are components).
    @el = new DOMElement @,
      properties:
        background: 'blue'
        borderRadius: '100%'

class World
  constructor: ->
    clock = FamousEngine.getClock()
    FamousEngine.init()

  layout: (args) ->
    { root, nodes, edges } = args
    scene = FamousEngine.createScene()
    @famousRoot = scene.addChild()
    rootVertex = new Vertex x: 0, y:0
    @famousRoot.addChild rootVertex


nodes = for i in [0..50]
  "id#{i}"
root = "id0"
edges = for node in nodes
  [root, node]

#console.log "nodes", nodes
#console.log "edges", edges

new World()
  .layout { root, nodes, edges }

