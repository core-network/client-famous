'use strict'
famous = require('famous')

DOMElement = famous.domRenderables.DOMElement
FamousEngine = famous.core.FamousEngine
Node = famous.core.Node

dotSize = 200
clock = FamousEngine.getClock()
FamousEngine.init()
scene = FamousEngine.createScene()

# Dots are nodes.
# They have a DOMElement attached to them by default.

class Dot extends Node
  constructor: (step) ->
    super
    # Center dot.
    @setOrigin(0.5, 0.5, 0.5)
      .setMountPoint(0.5, 0.5, 0.5)
      .setAlign(0.5, 0.5, 0.5)
      .setSizeMode('absolute', 'absolute', 'absolute')
      .setAbsoluteSize dotSize, dotSize, dotSize

    # Add the DOMElement (DOMElements are components).
    @el = new DOMElement @,
      properties:
        background: 'blue'
        borderRadius: '100%'
    # Add the Position component.
    # The position component allows us to transition between different states
    # instead of instantly setting the final translation.
    # this.position = new Position(this);

dot = new Dot
scene.addChild dot
dotScale = new famous.components.Scale dot
dotScale.set 0.1, 0.1, 0.1
clock.setTimeout (->
  dotScale.set 1, 1, 1, duration: 4000
), 500
