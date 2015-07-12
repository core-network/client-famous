{json, log, p, pjson} = require 'lightsaber'
World = require './core/world'
{ floor, random } = Math

rootNodeId = "id0"
nodes = for i in [0..36]
  id: "id#{i}"
  sector: floor random() * 6  # temporary, we will do sectors intelligently later

edges = for node in nodes
  start: rootNodeId
  end: node.id

# new World().spiralLayout { rootNodeId, nodes, edges }
new World().coreBubblesLayout { nodes }
