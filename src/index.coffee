{ floor, random } = Math
{ json, log, p, pjson } = require 'lightsaber'

World = require './core/world'
SpiralLayout = require './layouts/spiral'

# JsonAdaptor = require './adaptor/json'
# jsonDataUri = 'https://rawgit.com/mbostock/4062045/raw/9653f99dbf6050b0f28ceafbba659ac5e1e66fbd/miserables.json'
# world = new World
# world.render
#   source: new JsonAdaptor
#   sourceUri: jsonDataUri
#   layout: new SpiralLayout

IPFS = require './adaptor/ipfs'

rootNodeId = window.location.hash[1..]
world = new World
world.render
  source: new IPFS
  layout: new SpiralLayout
  rootNodeId: rootNodeId
