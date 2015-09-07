{ floor, random } = Math
{ json, log, p, pjson } = require 'lightsaber'
sphere = require 'nodesphere'

World = require './core/world'
SpiralLayout = require './layouts/spiral'

Ipfs = sphere.adaptor.Ipfs
Ipfs.create()
  .then (ipfs) =>
    rootNodeId = window.location.hash[1..]
    world = new World
    world.render
      source: ipfs
      layout: new SpiralLayout
      rootNodeId: rootNodeId

# JsonAdaptor = sphere.adaptor.Json
# jsonDataUri = 'https://rawgit.com/mbostock/4062045/raw/9653f99dbf6050b0f28ceafbba659ac5e1e66fbd/miserables.json'
# world = new World
# world.render
#   source: new JsonAdaptor
#   sourceUri: jsonDataUri
#   layout: new SpiralLayout
