{ json, log, p, pjson } = require 'lightsaber'
{ isEmpty } = require 'lodash'

famous = require 'famous'
FamousEngine = famous.core.FamousEngine

# HistoryLayout     = require '../layouts/history'

class World
  constructor: ->
    FamousEngine.init()
    scene = FamousEngine.createScene()
    @sceneRoot = scene.addChild()
    window.onpopstate = (event) =>
      @render
        rootNodeId: event.state.rootNodeId
        layout: @layout.clone()
        historyAction: false

  renderFromClick: (args) ->
    args.layout = @layout.clone()
    args.historyAction = 'pushState'
    @render args

  render: ({layout, source, rootNodeId, sourceUri, historyAction}) ->
    historyAction ?= 'replaceState'
    @source = source if source?
    if rootNodeId?
      @source.fetch {rootNodeId, sourceUri}
        .then ({ nodes, edges, suggestedRootNodeId }) =>
          if isEmpty(nodes) and rootNodeId?
            window.location = @source.path rootNodeId
            # debugger
          else
            # debugger
            @add node for node in nodes
            @add edge for edge in edges
            if history.state?.rootNodeId isnt rootNodeId and historyAction isnt false
              history[historyAction] { rootNodeId, foo: 'bar' }, null, "##{rootNodeId}"
            @layout?.hide()
            @layout?.physics?.active = false
            layout.setWorld @
            layout.render {nodes, edges, rootNodeId: rootNodeId ? suggestedRootNodeId}
            @layout = layout
    else
      @layout?.hide()
      @layout?.physics?.active = false
      layout.setWorld @
      layout.render()
      @layout = layout


  add: (famousNode) =>
    @sceneRoot.addChild famousNode

module.exports = World
