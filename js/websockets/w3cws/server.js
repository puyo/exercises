#!/usr/bin/env node

var express = require('express'),
    expressWs = require('express-ws');

var app = express();

expressWs(app); // add web sockets

app.get('/', function(req, res, next){
  res.sendFile(__dirname + '/index.html');
});

var clients = [];

app.ws('/', function(socket, req) {
  console.log((new Date()) +  ' Connection accepted');

  clients.push(socket);

  socket.on('message', function(message) {
    console.log(new Date() + ' Received: ' + message);

    for (var i = 0; i < clients.length; i++) {
      clients[i].send(message);
    }
  });

  socket.on('close', function(code) {
    console.log(new Date() + ' Disconnect: ' + code);

    for(var i = 0; i < clients.length; i++) {
      if(clients[i] == socket) {
        clients.splice(i);
        break;
      }
    }
  });
});

app.listen(3000, function(){
  console.log('listening on *:3000');
});
