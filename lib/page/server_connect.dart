import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:healthcare_prediction/page/pushdata.dart';

class ServerConnector extends StatefulWidget {
  const ServerConnector({Key? key}) : super(key: key);

  @override
  _ServerConnectorState createState() => _ServerConnectorState();
}

class _ServerConnectorState extends State<ServerConnector> {
  TextEditingController portController = TextEditingController();
  TextEditingController hostController = TextEditingController();
  // bool isConnecting = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server Connector'),
      ),
      body: error.isNotEmpty
          ? Text(error)
          // : isConnecting
          // ? Text('Etablish Connection')
          : Column(
              children: [
                TextFormField(
                  controller: hostController,
                ),
                TextFormField(
                  controller: portController,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (hostController.text.isNotEmpty &&
                          portController.text.isNotEmpty) {
                        Socket.connect(hostController.text,
                                int.parse(portController.text))
                            .then((value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HealthPrediction(
                                            socket: value,
                                          )),
                                ))
                            .onError((error, stackTrace) {
                          setState(() {
                            error = error.toString();
                          });
                        });
                      }
                    },
                    child: Text('Connect')),
              ],
            ),
    );
  }
}
