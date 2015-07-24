{ floor, random } = Math
{ values } = require 'lodash'
{ json, log, p, pjson } = require 'lightsaber'
xhr = require 'xhr'

Node = require './core/node'
Edge = require './core/edge'
World = require './core/world'
SpiralLayout = require './layouts/spiral'
CoreBubblesLayout = require './layouts/coreBubbles'

DEMO_HASH = 'QmUWJPLiN6ZPT351sXseVh1gdodqGPHL7Z2s2qJbAtt5NY'  # example viewer directory

DEBUG = 0
debug = (args...) -> console.debug args... if DEBUG

app = ->
  hash = window.location.hash[1..]
  debug hash
  if hash.length > 0
    render hash
  else
    window.location.hash = '#'+DEMO_HASH
    window.location.reload()

render = (hash) ->
  API_REFS_FORMAT = encodeURIComponent '<src> <dst> <linkname>'
  uri = "/api/v0/refs?arg=#{hash}&recursive&format=#{API_REFS_FORMAT}"
  xhr { uri }, (error, response, body) ->
    data = body
    tree = {}
    nodeCache = {}
    edges = []

    refApiPattern = /"Ref": "(\S+) (\S+) (\S+)\\n"/g
    while match = refApiPattern.exec data
      [whole, src, dst, linkname] = match
      start = nodeCache[src] ?= new Node id: src
      end = nodeCache[dst] ?= new Node id: dst, name: linkname
      edges.push new Edge { start, end }

    nodes = values nodeCache
    world = new World { nodes, edges }
    world.render new SpiralLayout()
    window.setTimeout =>
      world.render new CoreBubblesLayout()
    , 3000

app()
