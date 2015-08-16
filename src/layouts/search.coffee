{ json, log, p, pjson } = require 'lightsaber'

famous = require 'famous'

DOMElement = famous.domRenderables.DOMElement
FamousNode = famous.core.Node
# Opacity = famous.components.Opacity

class SearchLayout

  constructor: (@world) ->
    # searchNode = new FamousNode
    searchNode = @world.add new FamousNode
    # search.on = (eventType, callback) ->
    #   @addUIEvent eventType
    #   @onReceive = (event, payload) ->
    #     callback payload if event is eventType

    search = new DOMElement searchNode,
      tagName: 'input'
      attributes:
        type: 'text'
        # onkeypress: -> console.log 'hi jack'

    searchNode.addUIEvent 'keypress'

    # searchNode.onReceive = (event, payload) ->
    #   if event == 'keypress'
    #     log "yay"



    # debugger
    # search.on 'click', =>
    #   p "yaaaaaaaa"
    #   @world.renderFromClick
    #     rootNodeId: search.getValue()

  setWorld: (@world) ->

  render: ->

  hide: ->
    node.hide() for node in @nodes
    edge.hide() for edge in @edges

module.exports = SearchLayout
