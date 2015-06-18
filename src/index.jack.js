var famous = require('famous');

var FamousEngine = famous.core.FamousEngine;
<<<<<<< HEAD:src/index.jack.js
var Node = famous.core.Node;
var clock = FamousEngine.getClock();
var scene = FamousEngine.createScene();
=======
//var Gravity3D = famous.physics.Gravity3D;
//var Particle = famous.physics.Particle;
//var PhysicsEngine = famous.physics.PhysicsEngine;
//var Spring = famous.physics.Spring;
var Vec3 = famous.math.Vec3;
>>>>>>> 0c0846a910cd6585939e9a177c4fe3310b2343a2:src/index.js

var Mesh = famous.webglRenderables.Mesh;
var Color = famous.utilities.Color;
var Circle = famous.webglGeometries.Circle;
//var Triangle = famous.webglGeometries.Triangle;
var geometry = new Circle();

<<<<<<< HEAD:src/index.jack.js
=======
var colors = [ [151, 131, 242], [47, 189, 232] ];
var totalCols = 1000;
var totalRows = 100;
//var pe = new PhysicsEngine();
>>>>>>> 0c0846a910cd6585939e9a177c4fe3310b2343a2:src/index.js

function createColorStep(step, isDom) {
  step -= (step >= totalCols) ? totalCols : 0;
  var r = colors[0][0] - Math.round(((colors[0][0] - colors[1][0]) / totalCols) * step);
  var g = colors[0][1] - Math.round(((colors[0][1] - colors[1][1]) / totalCols) * step);
  var b = colors[0][2] - Math.round(((colors[0][2] - colors[1][2]) / totalCols) * step);
  if (isDom) return 'rgb(' + r + ',' + g + ',' + b + ')';
  return [r, g, b];
}

//function Phys (node, x, y) {
//    this.id = node.addComponent(this);
//    this.node = node;
//    this.body = new Particle({
//        mass: 1,
//        position: new Vec3(x, y, 0)
//    });
//    //this.force = new Spring(null, this.body, {
//    //    period: 0.9,
//    //    dampingRatio: 0.12,
//    //    anchor: new Vec3(x, y, 0)
//    //});
//    //pe.add(this.body, this.force);
//    node.requestUpdate(this.id);
//}
//
//Phys.prototype.onUpdate = function onUpdate () {
//    var pos = this.body.position;
//    this.node.setPosition(pos.x, pos.y, pos.z);
//    this.node.requestUpdateOnNextTick(this.id);
//}

function Dot (node, i, sceneSize) {
    node.setProportionalSize(1 / totalCols, 1 / totalRows)
        .setDifferentialSize(-4, -4)
        .setPosition(Math.random() * 1000, Math.random() * 1000, 0);

    new Mesh(node).setGeometry(geometry)
                  .setBaseColor(new Color(createColorStep(i / 18)));

    //new Phys(node, sceneSize[0] * (i % totalRows) / totalRows,
    //               sceneSize[1] * ((((i / totalRows)|0) % totalCols) / totalCols));
}

<<<<<<< HEAD:src/index.jack.js
var dotScale = new famous.components.Scale(dot);
var scale = 0.1

dotScale.set(scale, scale, scale);

function toggleScale() {
    scale = (scale == 1) ? 0.1 : 1
    dotScale.set(scale, scale, scale, { duration: 4000 }, toggleScale);
}

clock.setTimeout(toggleScale, 500);

FamousEngine.init();
=======
//var grav = new Gravity3D(null, pe.bodies, {
//    strength: -5e7,
//    max: 1000,
//    anchor: new Vec3()
//});
//
//pe.add(grav);

//document.addEventListener('mousemove', function (e) {
//    grav.anchor.set(e.pageX, e.pageY);
//});
//document.addEventListener('touchmove', function (e) {
//    grav.anchor.set(e.changedTouches[0].pageX, e.changedTouches[0].pageY);
//    e.preventDefault();
//});

// APP CODE

FamousEngine.init();
var scene = FamousEngine.createScene();
//var peUpdater = scene.addComponent({
//    onUpdate: function (time) {
//                  pe.update(time);
//                  scene.requestUpdateOnNextTick(peUpdater);
//              }
//});
//scene.requestUpdate(peUpdater);
var root = scene.addChild();
var sized = false;
root.addComponent({
    onSizeChange: function (size) {
        if (!sized) {
            for (var i = 0 ; i < (totalRows * totalCols) ; i++)
                Dot(root.addChild(), i, size);
            sized = true;
        }
    }
});
>>>>>>> 0c0846a910cd6585939e9a177c4fe3310b2343a2:src/index.js
