import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:healthcare_prediction/custom_textfield/configs/textfield_config.dart';
import 'package:healthcare_prediction/custom_textfield/shadow_textfield.dart';
import 'package:healthcare_prediction/page/patient/patient.dart';
import 'package:healthcare_prediction/page/pushdata.dart';
import 'package:rxdart/rxdart.dart';

class ServerConnector extends StatefulWidget {
  const ServerConnector({Key? key}) : super(key: key);

  @override
  _ServerConnectorState createState() => _ServerConnectorState();
}

class _ServerConnectorState extends State<ServerConnector> {
  TextEditingController portController = TextEditingController();
  TextEditingController hostController = TextEditingController();
  // bool isConnecting = false;
  BehaviorSubject<bool> isConnecting = BehaviorSubject.seeded(false);
  // BehaviorSubject<String> error = BehaviorSubject.seeded('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server connector'),
      ),
      body: StreamBuilder<bool>(
          stream: isConnecting,
          builder: (context, snapshot) {
            if (isConnecting.value == false) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text('Server host'),
                    ),
                    ShadowTextField(
                        textFieldType: TextFieldType.text,
                        textFieldConfig:
                            TextFieldConfig(controller: hostController)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: Text('Server host'),
                    ),
                    ShadowTextField(
                        textFieldType: TextFieldType.number,
                        textFieldConfig:
                            TextFieldConfig(controller: portController)),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            if (hostController.text.isNotEmpty &&
                                portController.text.isNotEmpty) {
                              isConnecting.add(true);
                              Socket.connect(hostController.text,
                                      int.parse(portController.text))
                                  .then((value) {
                                isConnecting.add(false);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PatientsPage(
                                            socket: value,
                                          )),
                                );
                              }).onError((error, stackTrace) {
                                isConnecting.add(false);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      'Etablish connection failed: $error'),
                                ));
                              });
                            }
                          },
                          child: Text('Connect')),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text('Etablishing connection, please wait'),
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }
          }),
    );
  }
}
