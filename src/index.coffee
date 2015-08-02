{ floor, random } = Math
{ json, log, p, pjson } = require 'lightsaber'

global.Promise = require 'bluebird'
IPFS = require './adaptor/ipfs'
World = require './core/world'
SpiralLayout = require './layouts/spiral'
# DepthTree = require './layouts/depthTree'
CoreBubblesLayout = require './layouts/coreBubbles'

DEMO_HASH = 'QmRAdbiFeLjb7RBHSJ2RwaKqvpDMSe7Jt1hCcLJ2isLn4M'

DEBUG = 0
debug = (args...) -> console.debug args... if DEBUG

hash = window.location.hash[1..]
debug hash
if hash.length is 0
  window.location.hash = '#'+DEMO_HASH
  window.location.reload()

world = new World
world.render
  source: new IPFS
  layout: new SpiralLayout
  rootNodeId: hash
