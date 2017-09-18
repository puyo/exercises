let angle t = 1000. *. t *. t

let render () =
  GlClear.clear [ `color ];
  GlMat.load_identity ();
  GlMat.rotate ~angle: (angle (Sys.time ())) ~z:1. ();
  GlDraw.begins `triangles;
  List.iter GlDraw.vertex2 [-1., -1.; 0., 1.; 1., -1.];
  GlDraw.ends ();
  Glut.swapBuffers ()

let _ =
  ignore( Glut.init Sys.argv );
  Glut.initDisplayMode ~double_buffer:true ();
  ignore (Glut.createWindow ~title:"OpenGL Demo Foo");
  GlMat.mode `modelview;
  Glut.displayFunc ~cb:render;
  Glut.idleFunc ~cb:(Some Glut.postRedisplay);
  Glut.mainLoop ()
