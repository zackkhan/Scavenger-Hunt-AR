var port = process.env.PORT || 3000,
http    = require('http').createServer(app),
io      = require('socket.io')(http);

const ids = {}, gameMap = {}; 
var host = ""; 

function getRandomNumber(min, max) {
    return Math.random() * (max - min) + min;
  }
  
function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min)) + min; //The maximum is exclusive and the minimum is inclusive
  }
function generateGameMap(){
    for (i = 0; i<1000; i++) {
        var hash = {};
        hash['x'] = getRandomNumber(-2.0, 2.0)
        hash['y'] = getRandomNumber(-2.0, 2.0)
        hash['z'] = getRandomNumber(-1.0, 2.0)
        hash['model'] = getRandomInt(0,4)
        gameMap[i] = hash;
    }
}

io.on('connection', function (client) {
    console.log('client is connected')
    
    client.on('hostConnect', function (data) {
        ids[client] = data.id
        host = {id: data.id, socket: client};
        generateGameMap()
    });
    client.on('clientConnect', function(data){
        ids[client] = data.id
    })
});

io.on('start', function(client){
    io.emit('map', gameMap);
})

io.on('win', function (client) {
    io.emit('winner', )
});

 io.on('hostObject', function(data){
     

});


/*
on(‘win’) -> String -Make it the unique client id from the phone
on(‘appendObject’) -> {“modelNum”: Int, “x”: Float, “y”: Float, “z”: Float}
on(‘ready’) -> {id: String, ready: Bool}
on(‘startGame’) -> nil - Emit the game map
on(‘objectDelete’) -> index type Int
on(‘hostConnect’) <- id - make the gameMap, add to objs
on(‘clientConnect’) <- id - add to objs
*/