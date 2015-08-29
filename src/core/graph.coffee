{json, log, p, pjson} = require 'lightsaber'
{ values } = require 'lodash'
GraphicNode = require './graphicNode'
GraphicEdge = require './graphicEdge'

class Graph
  @fromNodesphere: (simpleNodes, simpleEdges) ->
    graph = new Graph
    graph.build simpleNodes, simpleEdges
    graph

  constructor: ->   #({@nodes, @_edges}) ->
    @_nodes = {}
    @_edges = {}

  build: (simpleNodes, simpleEdges) ->
    for simpleNode in simpleNodes
      @_nodes[simpleNode.id()] = new GraphicNode node: simpleNode
    for simpleEdge in simpleEdges
      edge       = @_edges[simpleEdge.id()] = new GraphicEdge edge: simpleEdge
      edge.start = @_nodes[simpleEdge.start.id()]
      edge.end   = @_nodes[simpleEdge.end.id()]

  nodes: -> values @_nodes

  edges: -> values @_edges

  elements: -> @nodes().concat @edges()

module.exports = Graph
