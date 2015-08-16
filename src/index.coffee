{ floor, random } = Math
{ json, log, p, pjson } = require 'lightsaber'

World = require './core/world'
SearchLayout = require './layouts/search'

# JsonAdaptor = require './adaptor/json'
# jsonDataUri = 'https://rawgit.com/mbostock/4062045/raw/9653f99dbf6050b0f28ceafbba659ac5e1e66fbd/miserables.json'
# world = new World
# world.render
#   source: new JsonAdaptor
#   sourceUri: jsonDataUri
#   layout: new SpiralLayout

IPFS = require './adaptor/ipfs'

# DEMO_HASH = 'QmYjtMKBWUBFJDbwmexvsYne6Z4dKTcNqkEnSKT3G6d1FC'
#
# rootNodeId = window.location.hash[1..]
# if rootNodeId.length is 0
#   window.location.hash = '#'+DEMO_HASH
#   window.location.reload()

world = new World
world.render
  source: new IPFS
  layout: new SearchLayout world
  # rootNodeId: rootNodeId
