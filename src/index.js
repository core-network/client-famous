'use strict';
var famous = require('famous');

var DOMElement = famous.domRenderables.DOMElement;
var FamousEngine = famous.core.FamousEngine;
var Node = famous.core.Node;
var clock = FamousEngine.getClock();

var DOT_SIZE = 200;

// Boilerplate
FamousEngine.init();
var scene = FamousEngine.createScene();

// Dots are nodes.
// They have a DOMElement attached to them by default.
function Dot(step) {
    Node.call(this);

    // Center dot.
    this
        .setOrigin(0.5, 0.5, 0.5)
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

var dotScale = new famous.components.Scale(dot);

dotScale.set(0.1, 0.1, 0.1);

clock.setTimeout(function() {
    dotScale.set(1, 1, 1, { duration: 4000 });
}, 500);
