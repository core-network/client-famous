{ json, log, p, pjson } = require 'lightsaber'
{ defaults, find, merge } = require 'lodash'
{ abs, cos, floor, pow, random, round, sin, sqrt } = Math
π = Math.PI

famous = require 'famous'
FamousEngine = famous.core.FamousEngine
PhysicsEngine = famous.physics.PhysicsEngine
Collision = famous.physics.Collision
Spring = famous.physics.Spring
Particle = famous.physics.Particle
Vec3 = famous.math.Vec3
Sphere = famous.physics.Sphere

Node = require '../core/node'
Edge = require '../core/edge'

NODE_SIZE = 50
RADIUS = 200
DEBUG = 0
debug = (args...) -> console.debug args... if DEBUG

class D2sDaydream
  constructor: (args) ->
    options = defaults args #,
    #   sectorsCount: 6
    #   attractorDistance: 266
    #
    # {
    #   @sectorsCount
    #   @attractorDistance
    # } = options

    @add = options.add ? throw new Error
    @nodes = {}
    @physics = new PhysicsEngine()
    @collision = new Collision()
    @physics.add @collision
    @layout options

  layout: (input) ->
    radius = RADIUS
    for node in input.nodes
      x = floor(random() * radius * 2) - radius
      y = (round(random()) * 2 - 1) * sqrt(radius * radius - x * x)
      params = defaults node,
        position: new Vec3 x, y, -y
      node = @addNode params

  addNode: (params) ->
    node = new Node params

    node.sphere = new Sphere
      radius: node.size / 2
      mass: node.size / 10
      position: params.position
    @physics.add node.sphere
    @collision.addTarget node.sphere

    updateLoop = node.addComponent
      onUpdate: (time) =>
        @physics.update time
        position = @physics.getTransform(node.sphere).position
        node.setPosition position[0], position[1], position[2]
        v = node.sphere.getVelocity()
        node.sphere.setVelocity v.x + random(), v.y + random(), v.z + random()
        node.requestUpdateOnNextTick updateLoop
    node.requestUpdate updateLoop

    @saveNode node
    @add node
    node

  saveNode: (node) ->
    if @nodes[node.id]?
      throw new Error "Node with ID #{node.id} already exists in @nodes"
    @nodes[node.id] = node

  getNode: (nodeId) ->
    @nodes[nodeId] or throw new Error "unknown node #{nodeId}"

  knownNode: (nodeId) ->
    @nodes[nodeId]?

  unknownNode: (nodeId) ->
    not @knownNode nodeId

module.exports = D2sDaydream
