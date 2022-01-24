import 'dart:io';
import 'dart:math';

import 'dart:typed_data';

void main() async {
  final List<Socket> clients = [];
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 9999);
  print('server started');
  notifyAllClient(String message) {
    for (var item in clients) {
      print('Notify client ${item.remoteAddress.address}:${item.remotePort}');
      item.write(message + '\n');
    }
  }

  server.listen((client) async {
    print('Connection from'
        ' ${client.remoteAddress.address}:${client.remotePort}');
    if (!clients.contains(client)) {
      clients.add(client);
    }

    client.listen((Uint8List data) async {
      final message = String.fromCharCodes(data);
      print(
          'Client ${client.remoteAddress.address}:${client.remotePort} send message:'
          ' $message');
      if (message.contains('send:')) {
        notifyAllClient(message.replaceAll('send:', ''));
      }
      if (message.contains('result:')) {
        notifyAllClient(message.replaceAll('result:', 'prediction:'));
      }
    });
  });
}

// void handleConnection(Socket client) {
//   print('Connection from'
//       ' ${client.remoteAddress.address}:${client.remotePort}');

//   // listen for events from the client


//     // handle errors
//     onError: (error) {
//       print(error);
//       client.close();
//     },

//     // handle the client closing the connection
//     onDone: () {
//       print('Client left');
//       client.close();
//     },
//   );
// }
