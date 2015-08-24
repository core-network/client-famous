{ values } = require 'lodash'
GraphicNode = require './graphicNode'
GraphicEdge = require './graphicEdge'

class Graph
  @fromNodesphere: (simpleNodes, simpleEdges) ->
    graph = new Graph
    graph.build simpleNodes, simpleEdges
    graph

  constructor: ->   #({@nodes, @edges}) ->
    @nodes = {}
    @edges = {}

  build: (simpleNodes, simpleEdges) ->
    for simpleNode in simpleNodes
      @nodes[simpleNode.id()] = new GraphicNode node: simpleNode
    for simpleEdge in simpleEdges
      edge = @edges[simpleEdge.id()] = new GraphicEdge edge: simpleEdge
      edge.start = @nodes[simpleEdge.start.id()]
      edge.end   = @nodes[simpleEdge.end.id()]

  elements: ->
    values(@nodes).concat values(@edges)

module.exports = Graph
