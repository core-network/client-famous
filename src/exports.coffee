module.exports =
  adaptors:
    Json: require './adaptor/json'
    Ipfs: require './adaptor/ipfs'
  core:
    World: require './core/world'
    Edge: require './core/edge'
    Node: require './core/node'
    Geometry: require './core/geometry'
  layout:
    Spiral: require './layouts/spiral'
    CoreBubbles: require './layouts/coreBubbles'
