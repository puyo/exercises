var express = require('express');
var http = require('http');
var socketio = require('socket.io');
var faker = require('faker');

var server = http.createServer();         // low level server that will listen on the network

var app = express();                      // create a web server
server.on('request', app);                // express app handles HTTP requests (GET/POST)

var ioServer = socketio();                // creates a socket.io server
ioServer.attach(server);                  // socket.io server handles WS requests

// all incoming network traffic
// |
// +--> server (http.Server)
//      ||
//      |+------> app (express handler for GET, POST, etc.)
//      +-------> ioServer (socket io handler for web sockets protocol)

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});

ioServer.on('connection', function(socket){

  var from = faker.name.firstName();

  console.log(from, 'connected');

  socket.on('chat message', function(msg){
    console.log('chat message: ' + msg);
    ioServer.emit('chat message', {from: from, msg: msg});
  });

  socket.on('disconnect', function(){
    console.log(from, 'disconnected');
  });

});

server.listen(3000, function(){
  console.log('listening on *:3000');
});
