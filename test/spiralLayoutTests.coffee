chai = require 'chai'
chaiStats = require 'chai-stats'
chai.use chaiStats
chai.should()

global.window ?= {}   # so Famous doesn't freak out
{ pluck } = require 'lodash'


lightsaber = require 'lightsaber'
{ log, p } = lightsaber

SpiralLayout = require '../src/layouts/spiral'
Node = require '../src/core/node'
Edge = require '../src/core/edge'

π = Math.PI
τ = 2*π

describe 'SpiralLayout', ->
  it "should add the expected nodes and edges to the layout", ->
    node1 = new Node { id: 'node1' }
    node2 = new Node { id: 'node2' }
    edge1 = new Edge { start: node1, end: node2 }
    layout = new SpiralLayout
    layout.render
      nodes: [ node1, node2 ]
      edges: [ edge1 ]

    node1.x.should.equal 0
    node1.y.should.equal 0
    node2.radius.should.equal 100
    node2.angle.should.almost.equal τ * 11/12
