var app = app || {};

app.init = function() {
  // Store the Size of the window.
  app.width = window.innerWidth;
  app.height = window.innerHeight;

  // Set the Camera up. ( Field of View, Ratio, Near, Far )
  app.camera = new THREE.PerspectiveCamera(45, app.width / app.height, 1, 1000);
  app.camera.position.z = 200;

  // Set the Scene up. Then add the camera onto the page.
  app.scene = new THREE.Scene();
  app.scene.add(app.camera);

  // Create the Renderer.
  app.renderer = new THREE.WebGLRenderer();
  // Set the Size of the Renderer.
  app.renderer.setSize(app.width, app.height);
  // Set the Background Color, and it's opacity.
  app.renderer.setClearColor(0xe3f2fd, 1);

  // Place the renderer onto the page.
  document.body.appendChild(app.renderer.domElement);

  // Use an additional library to be able to control the camera.
  app.controls = new THREE.OrbitControls(app.camera, app.renderer.domElement);

  // Actually Render it.
  app.renderer.render(app.scene, app.camera);

  app.addBox();
  app.addCircle();
};

app.addBox = function() {
  // Create a box ( x, y, z ).
  var shape = new THREE.BoxGeometry(20, 20, 20);
  // Create a mesh (that it will be made up of).
  var material = new THREE.MeshBasicMaterial({
    color: 0x1a237e,
    wireframe: true
  });

  // Create the cube using the box and it's material ( or mesh ).
  app.cube = new THREE.Mesh(shape, material);
  // Add it to the scene.
  app.scene.add(app.cube);

  // Rerender the page.
  app.renderer.render(app.scene, app.camera);
};

app.animate = function() {
  requestAnimationFrame(app.animate);

  app.cube.rotation.x += 0.05;
  app.cube.rotation.y += 0.05;
  app.cube.rotation.z += 0.05;

  // Rerender the scene.
  app.renderer.render(app.scene, app.camera);
};

app.addCircle = function() {
  // Create a circle, ( radius, segments, rings ).
  var circle = new THREE.SphereGeometry(50, 16, 16);
  // Create it's material.
  var material = new THREE.MeshBasicMaterial({
    color: 0xec407a,
    wireframe: true
  });
  // Create the sphere with the material.
  app.sphere = new THREE.Mesh(circle, material);

  // Add it to the scene.
  app.scene.add(app.sphere);
  // Rerender to show the changes.
  app.renderer.render(app.scene, app.camera);
};

// Use the requestAnimationFrame API. Pass in the function that we want to use for the animations.
requestAnimationFrame(app.animate);

window.addEventListener("resize", function() {
  // Store the new width and height.
  app.width = window.innerWidth;
  app.height = window.innerHeight;

  // Change the camera's aspect ratio
  app.camera.aspect = app.width / app.height;
  // Update the way that it is representing things in the scene.
  app.camera.updateProjectionMatrix();

  // Set it's new size.
  app.renderer.setSize(app.width, app.height);
  // Rerender the size.
  app.renderer.render(app.scene, app.camera);
});

window.onload = app.init;
