
import 'package:flutter/material.dart';
import 'package:healthcare_prediction/page/server_connect.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health care predictions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ServerConnector(),
    );
  }
}
