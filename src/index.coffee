{ floor, random } = Math
{ json, log, p, pjson } = require 'lightsaber'

global.Promise = require 'bluebird'  # override built in Promise everywhere
World = require './core/world'
SpiralLayout = require './layouts/spiral'
# CoreBubblesLayout = require './layouts/coreBubbles'
IPFS = require './adaptor/ipfs'

DEMO_HASH = 'QmRAdbiFeLjb7RBHSJ2RwaKqvpDMSe7Jt1hCcLJ2isLn4M'

rootNodeId = window.location.hash[1..]
if rootNodeId.length is 0
  window.location.hash = '#'+DEMO_HASH
  window.location.reload()

world = new World
world.render
  source: new IPFS
  layout: new SpiralLayout
  rootNodeId: rootNodeId
