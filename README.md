# Nodesphere Graph Viz

Build: [![Circle CI](https://circleci.com/gh/nodesphere/graphviz/tree/master.svg?style=svg)](https://circleci.com/gh/nodesphere/graphviz/tree/master)

When the build is green, the latest code on master is built and pushed here: <http://nodesphere.github.io/graphviz>.

## Development

Run the dev server with ```npm run dev```

## Notes

- Both Nodes and Edges are implemented as _maps_, or sets of key-value pairs.
- Edges have the special keys `start` and `end` which point to those respective nodes.
