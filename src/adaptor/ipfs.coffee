{ json, log, p, pjson } = require 'lightsaber'
{ find, unique, values } = require 'lodash'
# xhr = require 'xhr-promise'
xhr = Promise.promisify require 'xhr'

Node = require '../core/node'
Edge = require '../core/edge'

class IPFS
  fetch: ({rootNodeId, recursive}) ->
    recursive ?= false
    API_REFS_FORMAT = encodeURIComponent '<src> <dst> <linkname>'
    params = {arg: rootNodeId, format: API_REFS_FORMAT, recursive}
    queryString = ("#{k}=#{v}" for k, v of params).join '&'
    uri = "/api/v0/refs?#{queryString}"
    xhr { uri }
      .then @process
      .catch (error) -> throw error

  process: ([res]) =>
    data = res.body
    tree = {}
    nodeMap = {}
    edges = []

    refApiPattern = /"Ref": "(\S+) (\S+) (\S+)\\n"/g
    while match = refApiPattern.exec data
      [whole, startId, endId, linkName] = match
      start = @cache nodeMap, id: startId
      end = @cache nodeMap, id: endId, name: linkName  # Note: technically there could be multiple names for the same end node...
      edges.push new Edge { start, end }

    rootNode = find nodeMap, (node, nodeId) -> node.name is '[root]'

    nodes = values nodeMap
    {nodes, edges}

  cache: (nodeMap, props) ->
    id = props.id ? throw new Error
    name = props.name # ? "[root]"
    if node = nodeMap[id]
      node.names.push name
      node.name = unique(nodeMap[id].names).join ' / '
    else
      node = new Node props
      node.names = [name]
      nodeMap[id] = node
    node

module.exports = IPFS
