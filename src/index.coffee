{ floor, random } = Math
{ find, unique, values } = require 'lodash'
{ json, log, p, pjson } = require 'lightsaber'
xhr = require 'xhr'

Node = require './core/node'
Edge = require './core/edge'
World = require './core/world'
# SpiralLayout = require './layouts/spiral'
DepthTree = require './layouts/depthTree'
CoreBubblesLayout = require './layouts/coreBubbles'

DEMO_HASH = 'QmXhcnFtfHuNbpRNUJoiRdhkskCoTtT6RYjPZA4woS7sMG'

DEBUG = 0
debug = (args...) -> console.debug args... if DEBUG

app = ->
  hash = window.location.hash[1..]
  debug hash
  if hash.length > 0
    fetch {hash, recursive: false}
  else
    window.location.hash = '#'+DEMO_HASH
    window.location.reload()

fetch = ({hash, recursive}) ->
  API_REFS_FORMAT = encodeURIComponent '<src> <dst> <linkname>'
  params = {arg: hash, format: API_REFS_FORMAT, recursive}
  queryString = ("#{k}=#{v}" for k, v of params).join '&'
  uri = "/api/v0/refs?#{queryString}"
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

  rootNode = find nodeCache, (node, nodeId) -> node.name is '[root]'

  nodes = values nodeCache
  visualize { rootNodeId: rootNode.id, nodes, edges }

cache = (nodeCache, props) ->
  id = props.id ? throw new Error
  name = props.name ? "[root]"
  if node = nodeCache[id]
    node.names.push name
    node.name = unique(nodeCache[id].names).join ' / '
  else
    node = new Node props
    node.names = [name]
    nodeCache[id] = node
  node

visualize = (data) ->
  world = new World data
  world.render new DepthTree()

app()
