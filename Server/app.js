var port = process.env.PORT || 3000,
http    = require('http').createServer(app),
io      = require('socket.io')(http),

function getRandomNumber(min, max) {
    return Math.random() * (max - min) + min;
  }

io.on('connection', function (client) {
    console.log('client is connected')
});

io.on('gamemap', function(data){
    var models = [];
    for (i = 0; i<1000; i++){
    
    }

});

