
import 'dart:io';

void main() {
  ServerSocket.bind(InternetAddress.ANY_IP_V4, 4000).then(
    (ServerSocket server) {
      server.listen(handleClient);
    }
  );
}

void handleClient(Socket client){
  client.pipe(client).then((whatevs) {
    client.close();
  },
  onError: (e) {
    client.close();
  });
}