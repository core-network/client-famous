famous = require 'famous'
FamousEngine = famous.core.FamousEngine

SpiralLayout = require '../layouts/spiral'

class World
  constructor: ->
    FamousEngine.init()
    scene = FamousEngine.createScene()
    @sceneRoot = scene.addChild()
    # @sceneRoot.addComponent
    #   XXX do this is right order... promises?
    #   onMount: @_layout.bind @

  spiralLayout: (args) ->
    args.add ?= @add
    new SpiralLayout args

  add: (famousNode) =>
    @sceneRoot.addChild famousNode

module.exports = World
