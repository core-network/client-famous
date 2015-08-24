{ json, log, p, pjson } = require 'lightsaber'
{ isEmpty } = require 'lodash'

famous = require 'famous'
FamousEngine = famous.core.FamousEngine
GraphicNode = require './graphicNode'
GraphicEdge = require './graphicEdge'

# HistoryLayout     = require '../layouts/history'

class World
  constructor: ->
    FamousEngine.init()
    scene = FamousEngine.createScene()
    @sceneRoot = scene.addChild()
    window.onpopstate = @onpopstate.bind @

  onpopstate: (event) ->
    if event.state?.rootNodeId?
      rootNodeId = event.state.rootNodeId
    else if not isEmpty window.location.hash
      rootNodeId = window.location.hash[1..]
    @render
      rootNodeId: rootNodeId
      layout: @layout.clone()
      historyAction: false

  renderFromClick: (args) ->
    args.historyAction = 'pushState'
    @render args

  render: ({layout, source, rootNodeId, sourceUri, historyAction}) ->
    @source = source if source?
    historyAction ?= 'replaceState'
    if isEmpty(rootNodeId)
      @layout = layout if layout?
      return
    @source.fetch {rootNodeId, sourceUri}
      .then ({ nodes, edges, suggestedRootNodeId }) =>
        if isEmpty(nodes)
          window.location = @source.path rootNodeId
        else
          graphicNodes = for node in nodes
            new GraphicNode {node}
          graphicEdges = for edge in edges
            new GraphicEdge {edge}
          for graphicNode in graphicNodes
            @sceneRoot.addChild graphicNode
          for graphicEdge in graphicEdges
            @sceneRoot.addChild graphicEdge
          if history.state?.rootNodeId isnt rootNodeId and historyAction isnt false
            history[historyAction] { rootNodeId }, null, "##{rootNodeId}"
          @layout?.hide()
          @layout?.physics?.active = false
          layout.setWorld @
          layout.render {nodes: graphicNodes, edges: graphicEdges, rootNodeId: rootNodeId ? suggestedRootNodeId}
          @layout = layout
      .catch (error) =>
        console.error error

module.exports = World
