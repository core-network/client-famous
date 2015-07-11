{ json, log, p, pjson } = require 'lightsaber'
{ defaults, find, merge } = require 'lodash'

Node = require '../core/node'
Edge = require '../core/edge'

π = Math.PI
{ abs, cos, pow, round, sin, sqrt } = Math

CIRCLE_RADIANS = 2*π
NOON = CIRCLE_RADIANS * 0.75    # "12 o'clock", where radians start at "3 o'clock"
RING_SIZE = 100
NODE_SIZE = RING_SIZE * 0.5
NODES_IN_INNER_RING = 6
MAX_ITERATIONS = pow 10, 5

DEBUG = 0
debug = (args...) -> console.debug args... if DEBUG

class SpiralLayout
  constructor: (args) ->
    @add  = args.add ? throw new Error
    @iterations = 0
    @nodes = {}
    @layout args

  layout: (input) ->
    rootNode = if input.rootNodeId
      find(input.nodes, {id: input.rootNodeId}) ? throw new Error "input.nodes does not contain node wih ID #{input.rootNodeId}"
    else
      input.nodes[0]
    @addNode defaults rootNode, {radius: 0}

    for edge in input.edges
      startId = edge.start
      endId   = edge.end
      if startId is rootNode.id and @unknownNode endId
        @addNode id: endId

    for edge in input.edges
      start = @getNode edge.start
      end   = @getNode edge.end
      @add new Edge { start, end }

  addNode: (params) ->
    if not params.radius?
      params = merge params, @nextAvailableLocation()
    node = new Node params
    @saveNode node
    @add node

  nextAvailableLocation: ->
    throw new Error if @iterations++ > MAX_ITERATIONS
    @incrementLocation()
    if @available()
      { @radius, @angle }
    else
      @nextAvailableLocation()

  available: ->
    target = @rectangular @radius, @angle
    for id, node of @nodes
      if (abs(target.x - node.x) < NODE_SIZE) and (abs(target.y - node.y) < NODE_SIZE)
        return false
    true

  incrementLocation: ->
    @ring ?= @incrementRing()
    @angle ?= NOON
    if @angle < NOON + CIRCLE_RADIANS
      @angle += CIRCLE_RADIANS / @nodes_in_this_ring
    else
      @incrementRing()
      @angle = NOON

  incrementRing: ->
    @ring = if @ring? then @ring+1 else 1
    @radius = @ring * RING_SIZE
    @nodes_in_this_ring = @ring * NODES_IN_INNER_RING
    @ring

  rectangular: (radius, angle) ->
    throw new Error unless radius? and angle?
    x = radius * cos angle
    y = radius * sin angle
    {x, y}

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

module.exports = SpiralLayout
