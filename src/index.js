'use strict';
var famous = require('famous');

var DOMElement = famous.domRenderables.DOMElement;
var FamousEngine = famous.core.FamousEngine;
var Node = famous.core.Node;
var Size = famous.components.Size;

var DOT_SIZE = 24;

// Boilerplate
FamousEngine.init();
var scene = FamousEngine.createScene();

// Dots are nodes.
// They have a DOMElement attached to them by default.
function Dot(step) {
    Node.call(this);

    // Center dot.
    this
        .setMountPoint(0.5, 0.5, 0.5)
        .setAlign(0.5, 0.5, 0.5)
        .setSizeMode('absolute', 'absolute', 'absolute')
        .setAbsoluteSize(DOT_SIZE, DOT_SIZE, DOT_SIZE);

    // Add the DOMElement (DOMElements are components).
    this.el = new DOMElement(this, {
        properties: {
            // background: createColorStep(step),
            background: 'blue',
            borderRadius: '100%'
        }
    });

    // Add the Position component.
    // The position component allows us to transition between different states
    // instead of instantly setting the final translation.
    // this.position = new Position(this);
}

Dot.prototype = Object.create(Node.prototype);
Dot.prototype.constructor = Dot;


var dot = new Dot();

scene.addChild(dot);

var dotSize = new Size(dot);

dotSize
    .setMode('absolute', 'absolute', 'absolute')
    .setAbsolute(100, 100, 100, { duration: 1000 });
