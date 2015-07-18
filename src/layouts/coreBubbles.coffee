{ json, log, p, pjson } = require 'lightsaber'
{ defaults, find, merge } = require 'lodash'

famous = require 'famous'
FamousEngine = famous.core.FamousEngine
PhysicsEngine = famous.physics.PhysicsEngine
Collision = famous.physics.Collision
Spring = famous.physics.Spring
Particle = famous.physics.Particle
Vec3 = famous.math.Vec3
Sphere = famous.physics.Sphere

π = Math.PI
{ abs, cos, pow, random, round, sin, sqrt } = Math

CIRCLE_RADIANS = 2*π
NOON = CIRCLE_RADIANS * 0.75    # "12 o'clock", where radians start at "3 o'clock"
NODE_SIZE = 50

DEBUG = 0
debug = (args...) -> console.debug args... if DEBUG

class CoreBubblesLayout
  constructor: (args = {}) ->
    @physics = new PhysicsEngine()
    options = defaults args,
      sectorsCount: 6
      attractorDistance: 266
    {
      @sectorsCount
      @attractorDistance
    } = options

    # @sectors = sectors_sphere.keys().sort()

    # @sectorRadians = CIRCLE_RADIANS / @sectorsCount

    # @sectorHues = for index in [0...@sectorsCount]
    #   360 / @sectorsCount * index

    @sectorSize = CIRCLE_RADIANS / @sectorsCount

    @attractors = @makeAttractors()
    # console.log "attractors:", @attractors
    @collision = new Collision()
    @physics.add @collision

    @nodes = {}

  onUpdate: (time) =>
    @physics.update time
    for own id, node of @nodes
      position = @physics.getTransform(node.sphere).position
      node.setPosition position[0], position[1], position[2]
    FamousEngine.requestUpdateOnNextTick(@) if @physics.active

  makeAttractors: ->
    for harmonic in [0...@sectorsCount]
      radians = NOON + harmonic * @sectorSize
      x = @attractorDistance * cos radians
      y = @attractorDistance * sin radians
      new Vec3 x, y, 0

  render: (input) ->
    @nodes = input.nodes
    for node in input.nodes
      @addNode node
    @physics.active = true
    FamousEngine.requestUpdateOnNextTick @

  addNode: (node) ->
    # throw new Error unless node.sector?
    # todo manage our own physics stuff but don't overwrite others
    position = node.getPosition() ? new Vec3 random() * Math.PI, random() * Math.PI, 0
    node.sphere = new Sphere
      radius: node.size / 2
      mass: node.size / 10
      position: position
    node.spring = new Spring null, [node.sphere],
      period: 10
      dampingRatio: 0.9
      length: 0
    node.spring.anchor = @attractors[node.sector]
    @physics.add node.sphere, node.spring
    @collision.addTarget node.sphere

  rectangular: (radius, angle) ->
    throw new Error unless radius? and angle?
    x = radius * cos angle
    y = radius * sin angle
    {x, y}

module.exports = CoreBubblesLayout
