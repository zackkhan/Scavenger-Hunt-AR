var port = process.env.PORT || 3000,
io = require('socket.io')();
io.listen(port);

var users = new Map(),
    gameMap = [],
    host = null;

function getRandomNumber(min, max) {
    return Math.random() * (max - min) + min;
}
  
function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min)) + min; //The maximum is exclusive and the minimum is inclusive
}

function generateGameMap(){
    gameMap = []
    for (i = 0; i<1000; i++) {
        gameMap.push({
            'modelNum': getRandomInt(0,4),
            'x': getRandomNumber(-2.0, 2.0),
            'y': getRandomNumber(-2.0, 2.0),
            'z': getRandomNumber(-1.0, 2.0)
        });
    }
    //console.log(gameMap)
}

io.on('connection', function (client) {
    client.on('hostConnect', function (data) {
        users.set(client, data.id);
        host = {id: data.id, socket: client};
    });

    client.on('generateGameMap', function (data) {
        generateGameMap();
    });

    client.on('clientConnect', function(data) {
        users.set(client, data.id);
    });

    client.on('getGameMap', function(data) {
        client.emit('gameMap', gameMap);
    });

    client.on('appendObject', function(data) {
        gameMap.push({modelNum: data.modelNum, x: data.x, y: data.y, z: data.z});
        /*for (const key of users.keys()) {
            if (key != host.socket) key.emit('hostObject', obj);
        }*/
        io.emit('hostObject', {modelNum: data.modelNum, x: data.x, y: data.y, z: data.z})
    });

    client.on('deleteObject', function(data) {
        io.emit('deleteObject', data.index)
    });

    client.on('win', function(data) {
        client.emit('endGame', true);
        for (const key of users.keys()) {
            if (client != key) key.emit('endGame', false);
        }
    });
});