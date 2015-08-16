{ json, log, p, pjson } = require 'lightsaber'
{ isEmpty } = require 'lodash'

famous = require 'famous'
FamousEngine = famous.core.FamousEngine

# HistoryLayout     = require '../layouts/history'

class World
  constructor: ->
    FamousEngine.init()
    scene = FamousEngine.createScene()
    @sceneRoot = scene.addChild()
    # @rootLayout = new HistoryLayout

  render: ({layout, source, rootNodeId, sourceUri}) ->
    @source = source if source?
    @source.fetch {rootNodeId, sourceUri}
      .then ({ nodes, edges, suggestedRootNodeId }) =>
        if isEmpty nodes
          window.location = @source.path rootNodeId
        else
          @add node for node in nodes
          @add edge for edge in edges
          @layout?.hide()
          @layout?.physics?.active = false
          layout.setWorld @
          layout.render {nodes, edges, rootNodeId: rootNodeId ? suggestedRootNodeId}
          @layout = layout

  add: (famousNode) =>
    @sceneRoot.addChild famousNode

module.exports = World
