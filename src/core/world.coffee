famous = require 'famous'
FamousEngine = famous.core.FamousEngine

SpiralLayout = require '../layouts/spiral'
CoreBubblesLayout = require '../layouts/coreBubbles'

class World
  constructor: ->
    FamousEngine.init()
    scene = FamousEngine.createScene()
    @sceneRoot = scene.addChild()

  spiralLayout: (args) ->
    args.add ?= @add
    new SpiralLayout args

  coreBubblesLayout: (args) ->
    args.add ?= @add
    new CoreBubblesLayout args

  add: (famousNode) =>
    @sceneRoot.addChild famousNode

module.exports = World
