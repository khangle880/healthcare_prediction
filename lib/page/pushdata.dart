import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';

class HealthPrediction extends StatefulWidget {
  const HealthPrediction({Key? key, required this.socket}) : super(key: key);
  final Socket socket;

  @override
  _HealthPredictionState createState() => _HealthPredictionState();
}

class _HealthPredictionState extends State<HealthPrediction> {
  TextEditingController controller = TextEditingController();
  String pushedData = '';

  @override
  void initState() {
    widget.socket.listen(
      (Uint8List data) {
        final String serverResponse = String.fromCharCodes(data);
        if (serverResponse == pushedData) {
          pushedData = '';
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Send success'),
          ));
        }
        if (serverResponse.contains('prediction:')) {
          String id = serverResponse.replaceAll('prediction:', '').split(';')[0].split(',')[0];
          String predict = serverResponse.replaceAll('prediction:', '').split(';')[0].split(',')[1];          
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('id: $id, stroke prediction: $predict'),
          ));
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Word Count'),
        ),
        body: _buildBody());
  }

  _buildBody() {
    return Column(children: [
      TextFormField(
        controller: controller,
      ),
      ElevatedButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              widget.socket.write('send:${controller.text}');
              pushedData = controller.text + '\n';
              controller.text = '';
            }
          },
          child: const Text('send'))
    ]);
  }
}
