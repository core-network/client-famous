famous = require 'famous'
FamousEngine = famous.core.FamousEngine

HistoryLayout     = require '../layouts/history'
SpiralLayout      = require '../layouts/spiral'
CoreBubblesLayout = require '../layouts/coreBubbles'

class World
  constructor: ({data, @rootLayout}) ->
    FamousEngine.init()
    scene = FamousEngine.createScene()
    @sceneRoot = scene.addChild()
    @set data
    @rootLayout ?= new HistoryLayout

  set: (@data) ->
    @add node for node in @data.nodes
    @add edge for edge in @data.edges

  render: (newLayout) ->
    @layout?.physics?.active = false
    newLayout.render @data
    @layout = newLayout

  add: (famousNode) =>
    @sceneRoot.addChild famousNode

module.exports = World
