global.window ?= {}   # so Famous doesn't freak out
{ pluck } = require 'lodash'

require('chai').should()
lightsaber = require 'lightsaber'
{ log, p } = lightsaber

SpiralLayout = require '../src/layouts/spiral'

describe 'SpiralLayout', ->
  it "should add the expected nodes and edges to the layout", ->
    elements = []
    new SpiralLayout
      nodes: [
        { id: 'node1' }
        { id: 'node2' }
      ]
      edges: [
        { start: 'node1', end: 'node2' }
      ]
      add: (element) -> elements.push element

    pluck(elements, 'id').should.deep.equal [
      'node1'
      'node2'
      'node1 -> node2'
    ]

