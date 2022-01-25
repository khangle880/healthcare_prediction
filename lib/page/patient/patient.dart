import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:healthcare_prediction/page/patient/patient_model.dart';
import 'package:rxdart/rxdart.dart';

import 'add_patient.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({Key? key, required this.socket}) : super(key: key);
  final Socket socket;
  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  BehaviorSubject<List<PatientModel>> patients = BehaviorSubject.seeded([]);
  late CountdownTimerController controller;
  @override
  void initState() {
    super.initState();
    // fetchAll();
    int endTime = DateTime.now().millisecondsSinceEpoch;
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  void onEnd() {
    Future.delayed(Duration(seconds: 3), () {
      // TODO: handle after timer out
      int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 70;
      controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
      // setState(() {});
    });
  }

  // Future<List> fetchAll() async {
  //   List contactList = [];
  //   FirebaseFirestore.instance
  //       .collection('patients')
  //       .snapshots()
  //       .map((event) =>
  //           event.docs.map((e) => PatientModel.fromJson(e.data())).toList())
  //       .listen((event) {
  //     patients = event;
  //     setState(() {});
  //   });
  //   return contactList;
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                  builder: (context) => AddPatient(
                        socket: widget.socket,
                      )),
            )
                .then((value) {
              print('pop out');
              if (value is PatientModel) {
                print('add patient success');
                patients.add(patients.value..add(value));
              }
            });
          },
          tooltip: 'Add',
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('Patient'),
          // actions: [
          //   Center(
          //     child: Padding(
          //       padding: const EdgeInsets.only(right: 10),
          //       child: CountdownTimer(
          //         controller: controller,
          //         widgetBuilder: (_, time) {
          //           if (time == null) {
          //             return Text('Time out');
          //           }
          //           return Text(
          //             'sec: [ ${(time.days ?? 0) * 24 + (time.hours ?? 0) * 60 + (time.min ?? 0) * 60 + (time.sec ?? 0)} ]',
          //             style: TextStyle(
          //               fontSize: 14,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   ),
          // ],
        ),
        body: StreamBuilder<List<PatientModel>>(
            stream: patients,
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: patients.value.length,
                itemBuilder: (ctx, index) {
                  final item = patients.value[index];
                  return Card(
                    elevation: 8,
                    shadowColor: Colors.green,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.blueAccent[100]!, width: 1.2)),
                    child: ExpansionTile(
                      trailing: Image.asset(
                        item.gender == Gender.female
                            ? 'assets/female.png'
                            : 'assets/male.png',
                        width: 40,
                        height: 40,
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextSpan(
                                    title: 'Age: ', value: item.age.toString()),
                                CustomTextSpan(
                                  title: 'Ever Married: ',
                                  value: item.everMarried ? 'Yes' : 'No',
                                ),
                              ],
                            ),
                          ),
                          VDivider(),
                          SizedBox(width: 2),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextSpan(
                                    title: 'Work Type: ',
                                    value: item.workType.value().capitalize()),
                                CustomTextSpan(
                                    title: 'Residence: ',
                                    value: item.residenceType
                                        .value()
                                        .capitalize()),
                              ],
                            ),
                          ),
                        ],
                      ),
                      children: [
                        ExpansionChild(item: item),
                      ],
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}

class ExpansionChild extends StatelessWidget {
  const ExpansionChild({
    Key? key,
    required this.item,
  }) : super(key: key);

  final PatientModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextSpan(title: 'Bmi: ', value: item.bmi.toString()),
                CustomTextSpan(
                  title: 'Avg Glucose: ',
                  value: item.avgGlucoseLevel.toString(),
                ),
              ],
            ),
          ),
          VDivider(height: 70),
          SizedBox(width: 2),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextSpan(
                    title: 'Heart Disease: ',
                    value: item.heartDisease ? 'Yes' : 'No'),
                CustomTextSpan(
                    title: 'Hypertension: ',
                    value: item.hypertension ? 'Yes' : 'No'),
                CustomTextSpan(
                    title: 'Smoking: ',
                    value: item.smokingStatus.value().toString()),
              ],
            ),
          ),
          Expanded(
              child: Column(
                children: [
                  Text('Prediction'),
                  if (item.strokePredict == null) Text('Awaiting'),
                  if (item.strokePredict != null)
                    Text((item.strokePredict!)
                        ? 'Stroke occured'
                        : 'Stroke unoccured'),
                  // Text('Prediction'),
                ],
              ),
              flex: 2)
          // Text('prediction:'),
        ],
      ),
    );
    // return Container();
  }
}

class CustomText extends StatelessWidget {
  const CustomText({Key? key, required this.text, this.style})
      : super(key: key);
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Text(
        text,
        style:
            TextStyle(fontSize: 14, fontWeight: FontWeight.w400).merge(style),
      ),
    );
  }
}

class CustomTextSpan extends StatelessWidget {
  const CustomTextSpan(
      {Key? key, required this.title, this.style, required this.value})
      : super(key: key);
  final String title;
  final String value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                  text: title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF325288),
                  )),
              TextSpan(text: value),
            ],
          ),
        ));
  }
}

class VDivider extends StatelessWidget {
  const VDivider({Key? key, this.height}) : super(key: key);
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: height ?? 45,
      color: Colors.black,
      margin: EdgeInsets.symmetric(
        vertical: 2.0,
        horizontal: 8.0,
      ),
    );
  }
}
