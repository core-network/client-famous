{ json, log, p, pjson } = require 'lightsaber'
{ defaults, find, merge } = require 'lodash'

Node = require '../core/node'
Edge = require '../core/edge'
{rectangular} = require '../core/geometry'

{ abs, cos, pow, round, sin, sqrt } = Math

π = Math.PI
τ = 2*π
# ε = 1e-6
NOON = τ * 0.75    # "12 o'clock", where radians start at "3 o'clock"
RING_SIZE = 100
NODE_SIZE = RING_SIZE * 0.5
NODES_IN_INNER_RING = 6
MAX_ITERATIONS = 1e+5

DEBUG = 0
debug = (args...) -> console.debug args... if DEBUG

class SpiralLayout
  constructor: ->
    @iterations = 0
    @nodes = {}

  render: (input) ->
    rootNode = if input.rootNodeId
      find(input.nodes, {id: input.rootNodeId}) ? throw new Error "input.nodes does not contain node wih ID #{input.rootNodeId}"
    else
      input.nodes[0]
    rootNode.radius = 0
    for node in input.nodes when node isnt rootNode
      node.set @nextAvailableLocation()
    for edge in input.edges
      edge.render()

  nextAvailableLocation: ->
    throw new Error if @iterations++ > MAX_ITERATIONS
    @incrementLocation()
    if @available()
      { @radius, @angle }
    else
      @nextAvailableLocation()

  available: ->
    target = rectangular { @radius, @angle }
    for id, node of @nodes
      if (abs(target.x - node.x) < NODE_SIZE) and (abs(target.y - node.y) < NODE_SIZE)
        return false
    true

  incrementLocation: ->
    @ring ?= @incrementRing()
    @angle ?= NOON
    if @angle < NOON + τ
      @angle += τ / @nodes_in_this_ring
    else
      @incrementRing()
      @angle = NOON

  incrementRing: ->
    @ring = if @ring? then @ring+1 else 1
    @radius = @ring * RING_SIZE
    @nodes_in_this_ring = @ring * NODES_IN_INNER_RING
    @ring

module.exports = SpiralLayout
