'use strict';

var famous = require('famous');

var Camera = famous.components.Camera;
var Curves = famous.transitions.Curves;
var DOMElement = famous.domRenderables.DOMElement;
var FamousEngine = famous.core.FamousEngine;
var Node = famous.core.Node;
var Position = famous.components.Position;
var Rotation = famous.components.Rotation;

var COLORS = [ [151, 131, 242], [47, 189, 232] ];
var COLOR_STEPS = 18;
var DOT_SIZE = 24;

// Helper function used for generating the color pallet used for styling the
// dots.
function createColorStep(step) {
    step -= (step >= COLOR_STEPS) ? COLOR_STEPS : 0;
    var r = COLORS[0][0] - Math.round(((COLORS[0][0] - COLORS[1][0]) / COLOR_STEPS) * step);
    var g = COLORS[0][1] - Math.round(((COLORS[0][1] - COLORS[1][1]) / COLOR_STEPS) * step);
    var b = COLORS[0][2] - Math.round(((COLORS[0][2] - COLORS[1][2]) / COLOR_STEPS) * step);
    return 'rgb(' + r + ',' + g + ',' + b + ')';
}


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
            background: createColorStep(step),
            borderRadius: '100%'
        }
    });

    // Add the Position component.
    // The position component allows us to transition between different states
    // instead of instantly setting the final translation.
    this.position = new Position(this);
}

Dot.prototype = Object.create(Node.prototype);
Dot.prototype.constructor = Dot;



// Components define behavior.
// Spinner is such a component. Attaching the custom Spinner component to a
// Node rotates the node on a frame by frame basis.
function Spinner(node) {
    this.node = node;
    this.id = this.node.addComponent(this);
    this.node.requestUpdate(this.id);
}

// // The onUpdate method will be called on every frame.
// Spinner.prototype.onUpdate = function(time) {
//     this.node.setRotation(time*0.001, -time*0.002, Math.PI / 4);
//
//     // We request an update from the node on the next frame.
//     this.node.requestUpdate(this.id);
// };


// The Demo lays out the dots in form of a grid.
function Demo(rows, cols) {
    Node.call(this);

    var count = 0;
    this.dots = [];
    for (var row = 0; row < rows; row++) {
        for (var col = 0; col < cols; col++) {
            var dot = new Dot(count++);
            this.addChild(dot);
            this.dots.push(dot);
        }
    }

    // Add spinner component. This makes the Demo rotate.
    this.spinner = new Spinner(this);

    // Center demo
    this
        .setMountPoint(0.5, 0.5, 0.5)
        .setAlign(0.5, 0.5, 0.5)
        .setOrigin(0.5, 0.5, 0.5)
        .setPosition(0, 0, 300);

    this.layout = new Layout(this);
    FamousEngine.getClock().setInterval(function() {
        // this.layout.next();
    }.bind(this), 2000);
}

Demo.prototype = Object.create(Node.prototype);
Demo.prototype.constructor = Demo;


// The Layout component is a state machine. Each layout can is a state.
// The state is defined by
// 1. spacing: The dot spacing.
// 2. randomizePositionZ: Whether the x position should be randomized.
// 3. curve: The easing curve used to enter the state.
// 4. duration: The duration of the animation used for transitioning to the
//      state.
function Layout(node) {
    this.node = node;
    this.id = this.node.addComponent(this);
    this.current = 0;
    // Dot layout -> Square layout -> Square layout with random Z
    // -> Expanded square -> Square layout
    this.spacing = [ +DOT_SIZE, -DOT_SIZE*3, 0, 20, 0 ];
    this.randomizePositionZ = [ false, false, true, false, true ];
    this.curve = [ Curves.outQuint, Curves.outElastic, Curves.inElastic, Curves.inOutEase, Curves.inBounce ];
    this.duration = [ 700, 3000, 3000, 1000, 700 ];

    // Transitions to initial state.
    this.next();
}

Layout.prototype.next = function next() {
    if (this.current++ === 4) this.current = 0;

    var spacing = this.spacing[this.current];
    var randomizePositionZ = this.randomizePositionZ[this.current];
    var duration = this.duration[this.current];
    var curve = this.curve[this.current];

    var row = 0;
    var col = 0;
    var dimension = (spacing + DOT_SIZE);
    var bounds = [-(((dimension) * 6 / 2) - (dimension / 2)), -(((dimension) * 6 / 2) - (dimension / 2))];
    for (var i = 0; i < this.node.getChildren().length; i++) {
        var polarity = Math.random() < 0.5 ? -1 : 1;
        var x = bounds[0] + ((dimension) * col++);
        var y = bounds[1] + ((dimension) * row);
        var z = (randomizePositionZ) ? Math.floor(Math.random() * 80) * polarity : 0;
        this.node.dots[i].position.set(x, y, z, {
            duration: i*10 + duration,
            curve: curve
        });
        if (col >= 6) {
            col = 0;
            row++;
        }
    }
};

// Boilerplate
FamousEngine.init();
var scene = FamousEngine.createScene();

var camera = new Camera(scene);
camera.setDepth(2000);
scene.addChild(new Demo(6, 6));
