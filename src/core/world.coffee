famous = require 'famous'
FamousEngine = famous.core.FamousEngine

SpiralLayout = require '../layouts/spiral'
CoreBubblesLayout = require '../layouts/coreBubbles'

class World # extends Sphere
  constructor: (data) ->
    FamousEngine.init()
    scene = FamousEngine.createScene()
    @sceneRoot = scene.addChild()
    @set data

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
