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

// class HealthPrediction extends StatelessWidget {
//   const HealthPrediction({Key? key, required this.socket}) : super(key: key);
//   final Socket socket;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Health care predictions',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   TextEditingController controller = TextEditingController();
//   bool isConnectedToServer = false;
//   String error = '';
//   String pushedData = '';
//   late Socket socket;

//   @override
//   void initState() {
//     connectToServer();
//     super.initState();
//   }

//   connectToServer() async {
//     try {
//       socket = await Socket.connect('2.tcp.ngrok.io', 19498);
//       setState(() {
//         isConnectedToServer = true;
//       });


//         // handle errors
//         onError: (error) {
//           print(error);
//           socket.destroy();
//         },

//         // handle server ending connection
//         onDone: () {
//           print('Server left.');
//           socket.destroy();
//         },
//       );
//     } catch (e) {
//       setState(() {
//         error = e.toString();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: _buildBody(),
//     );
//   }

//   _buildBody() {
//     if (error.isNotEmpty) {
//       return Column(
//         children: [
//           Center(child: Text('Connecting failed')),
//           Center(child: Text('error: $error')),
//         ],
//       );
//     }
//     if (!isConnectedToServer) {
//       return Column(
//         children: [
//           Center(child: Text('Etalisbing connect to server')),
//           Padding(
//             padding: const EdgeInsets.only(top: 15),
//             child: Center(child: CircularProgressIndicator()),
//           ),
//         ],
//       );
//     } else {

//     }
//   }
// }
