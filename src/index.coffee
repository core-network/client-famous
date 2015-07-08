{json, log, p, pjson} = require 'lightsaber'
World = require './core/world'

rootNodeId = "id0"
nodes = for i in [0..36]
  id: "id#{i}"

edges = for node in nodes
  start: rootNodeId
  end: node.id

new World().spiralLayout { rootNodeId, nodes, edges }
