{ json, log, p, pjson } = require 'lightsaber'

famous = require 'famous'
FamousEngine = famous.core.FamousEngine

# HistoryLayout     = require '../layouts/history'

class World
  constructor: ->
    FamousEngine.init()
    scene = FamousEngine.createScene()
    @sceneRoot = scene.addChild()
    # @rootLayout = new HistoryLayout

  render: ({layout, source, rootNodeId}) ->
    @source = source if source?
    @source.fetch {rootNodeId}
      .then ({ nodes, edges }) =>
        @add node for node in nodes
        @add edge for edge in edges
        @layout?.physics?.active = false
        layout.setWorld @
        layout.render {nodes, edges, rootNodeId}
        @layout = layout

  add: (famousNode) =>
    @sceneRoot.addChild famousNode

module.exports = World
