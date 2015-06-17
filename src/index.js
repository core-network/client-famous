'use strict';
var famous = require('famous');

var DOMElement = famous.domRenderables.DOMElement;
var FamousEngine = famous.core.FamousEngine;
var Node = famous.core.Node;
var clock = FamousEngine.getClock();
var Mesh = require('famous/webgl-renderables/Mesh')

// Boilerplate
FamousEngine.init();
var scene = FamousEngine.createScene();
var node = scene.addChild()
var element = new DOMElement(node)

// Nodes can contain both a DOM element and GL Mesh
var mesh = new Mesh(node);

mesh.setGeometry('Sphere');

mesh.setGeometry('Sphere', { detail: 100 });



//var Geometry = require('famous/webgl-geometries/Geometry')
//
//function CustomTriangle(options) {
//    Geometry.call(this,
//        { buffers: [
//            { name: 'pos', data: [-1, 1, 0, 0, -1, 0, 1, 1, 0], size: 3 },
//            { name: 'normals', data: [0, 0, 1, 0, 0, 1, 0, 0, 1], size: 3 },
//            { name: 'texCoord', data: [0.0, 0.0, 0.5, 1.0, 1.0, 0.0], size: 2 },
//            { name: 'indices', data: [0, 1, 2], size: 1 }
//        ]}
//    );
//}
//
//
//var geometry = new CustomTriangle();
//var mesh = new Mesh();
//mesh.setGeometry(geometry);



//var Geometry = require('famous/webgl-geometries/Geometry');
//
//new Geometry({ dynamic: true });
