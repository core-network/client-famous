{ json, log, p, pjson } = require 'lightsaber'
{ defaults, find, merge } = require 'lodash'

Node = require '../core/node'
Edge = require '../core/edge'
{rectangular} = require '../core/geometry'

{ abs, cos, pow, round, sin, sqrt } = Math

τ = 2 * Math.PI
NOON = τ * 0.75    # "12 o'clock", where radians start at "3 o'clock"
RING_SIZE = 111
NODES_IN_INNER_RING = 8
MAX_ITERATIONS = 1e+5

DEBUG = 0
debug = (args...) -> console.debug args... if DEBUG

class SpiralLayout
  constructor: ->
    @iterations = 0

  setWorld: (@world) ->

  render: ({@nodes, @edges, rootNodeId}) ->
    rootNode = if rootNodeId
      find(@nodes, {id: rootNodeId}) ? throw new Error "node wih ID #{rootNodeId} not found in nodes: #{pjson @nodes}"
    else
      @nodes[0]
    rootNode.radius = 0
    for node in @nodes when node isnt rootNode
      do (node) =>
        node.set @nextAvailableLocation()
        node.on 'click', (event) =>
          @world.render
            layout: new SpiralLayout
            rootNodeId: node.id
    for edge in @edges
      edge.render()

  nextAvailableLocation: ->
    throw new Error if @iterations++ > MAX_ITERATIONS
    @incrementLocation()

  incrementLocation: ->
    @ring ?= @incrementRing()
    @angle ?= NOON
    if @angle < NOON + τ
      @angle += τ / @nodes_in_this_ring
    else
      @incrementRing()
      @angle = NOON
    { @radius, @angle }

  incrementRing: ->
    @ring = if @ring? then @ring+1 else 1
    @radius = @ring * RING_SIZE
    @nodes_in_this_ring = @ring * NODES_IN_INNER_RING
    @ring

  hide: ->
    node.hide() for node in @nodes
    edge.hide() for edge in @edges

module.exports = SpiralLayout
