var cluster = require('cluster');
var net = require('net');
var os = require('os');

if (cluster.isMaster) {
    for (let i = 0; i < os.cpus().length; i++) {
        cluster.fork();
    }
} else {
    var server = net.createServer(function(socket) {
      // Don't crash when connections close
      socket.on('close', () => undefined)

      socket.pipe(socket);
    });

    server.listen(4000, '127.0.0.1');
}
