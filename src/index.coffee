{ floor, random } = Math
{ find, values } = require 'lodash'
{ json, log, p, pjson } = require 'lightsaber'
xhr = require 'xhr'

Node = require './core/node'
Edge = require './core/edge'
World = require './core/world'
SpiralLayout = require './layouts/spiral'
CoreBubblesLayout = require './layouts/coreBubbles'

DEMO_HASH = 'QmXhcnFtfHuNbpRNUJoiRdhkskCoTtT6RYjPZA4woS7sMG'

DEBUG = 0
debug = (args...) -> console.debug args... if DEBUG

app = ->
  hash = window.location.hash[1..]
  debug hash
  if hash.length > 0
    fetch hash
  else
    window.location.hash = '#'+DEMO_HASH
    window.location.reload()

fetch = (hash) ->
  API_REFS_FORMAT = encodeURIComponent '<src> <dst> <linkname>'
  uri = "/api/v0/refs?arg=#{hash}&recursive&format=#{API_REFS_FORMAT}"
  xhr { uri }, process

process = (error, response, body) ->
  throw error if error
  data = body
  tree = {}
  nodeCache = {}
  edges = []

  refApiPattern = /"Ref": "(\S+) (\S+) (\S+)\\n"/g
  while match = refApiPattern.exec data
    [whole, startId, endId, linkName] = match
    start = cache nodeCache, id: startId
    end = cache nodeCache, id: endId, name: linkName  # Note: technically there could be multiple names for the same end node...
    edges.push new Edge { start, end }

  rootNode = find nodeCache, (node, nodeId) -> not node.name?

  nodes = values nodeCache
  visualize { rootNodeId: rootNode.id, nodes, edges }

cache = (nodeCache, props) ->
  id = props.id ? throw new Error
  if nodeCache[id]
    if nodeCache[id].name
      nodeCache[id].name += ' / ' + props.name   # TODO: we should not append the same name twice
    else
      nodeCache[id].name = props.name
  else
    nodeCache[id] = new Node props
  nodeCache[id]

visualize = (data) ->
  world = new World data
  world.render new SpiralLayout()

app()
