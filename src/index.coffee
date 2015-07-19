{json, log, p, pjson} = require 'lightsaber'
Node = require './core/node'
Edge = require './core/edge'
World = require './core/world'
SpiralLayout = require './layouts/spiral'
CoreBubblesLayout = require './layouts/coreBubbles'
{ floor, random } = Math

rootNode = new Node
  id: "id0"

nodes = for i in [1..36]
  new Node
    id: "id#{i}"
    sector: floor random() * 6  # temporary, we will do sectors intelligently later

edges = for node in nodes
  new Edge
    start: rootNode
    end: node

# new World().spiralLayout { rootNodeId, nodes, edges }
# layout = world.defaultLayout()
world = new World { rootNode, nodes, edges }
# world.set { rootNodeId, nodes, edges }
world.render new SpiralLayout()
window.setTimeout =>
  world.render new CoreBubblesLayout()
, 3000
