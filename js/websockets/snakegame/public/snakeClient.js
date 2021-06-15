var snake = snake || {};

snake.client = function() {
  var client = this;

  var dir = 'right';
  var canvas = document.getElementById("snakeCanvas");
  var ctx = canvas.getContext("2d");
  w = canvas.width;
  h = canvas.height;

  var cw = 15; // Cell width
  var drawBackground = function() {
    ctx.fillStyle = "#334D5C"; // canvas fill colour
    ctx.fillRect(0, 0, 1005, 600);
  };

  var drawSnakes = function() {
    var pnum = 0;
    for (var name in client.state.players) {
      pnum += 1;
      var col = "hsl(" + pnum * 20 + ", 100%, 80%)";
      console.log(col);
      var snake = client.state.players[name].snake;
      for (var i = 0; i < snake.length; i++) {
        var s = snake[i];
        ctx.fillStyle = col;
        ctx.fillRect(s.x*cw, s.y*cw, cw, cw);
      }
    }
  };

  var drawFood = function() {
    for (var i = 0; i < client.state.foodBits.length; i++) {
      var f = client.state.foodBits[i];
      ctx.fillStyle = f.colour;
      ctx.fillRect(f.x*cw, f.y*cw, cw, cw);
    }
  };

  var draw = function(){
    drawBackground();
    drawSnakes();
    drawFood();
  };

  var socket = io();

  socket.on('connect', function(){
  });

  socket.on('disconnect', function(){
  });

  socket.on('state', function(state){
    client.state = state;
    draw();
  });

  $(document).keydown(function(e){
    var key = e.which;
    if (key === 37 || key === 38 || key === 39 || key === 40) {
      e.preventDefault();
    }
    if ((key === 37) && (dir != "right")) dir = "left";
    else if ((key === 38) && (dir != "down")) dir = "up";
    else if ((key === 39) && (dir != "left")) dir = "right";
    else if ((key === 40) && (dir != "up")) dir = "down";
    socket.emit('dir', dir);
  });
};
