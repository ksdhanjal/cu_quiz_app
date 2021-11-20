import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cu_quiz_app/services/database_service.dart';
import 'package:cu_quiz_app/ui/screens/questions_screen.dart';
import 'package:cu_quiz_app/ui/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class DisclaimerScreen extends StatefulWidget {
  final Map<String, dynamic>? testData;

  const DisclaimerScreen({Key? key, this.testData}) : super(key: key);

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  List testQuestion = [];
  int testTime = 0;

  String disclaimer =
      "The content of this test is confidential. To ensure confidentiality, you must agree to the following additional terms and conditions before taking the test: \n\nYou will not record, copy, publish, or share any part of the test questions or answers in any form (verbal, written) or by any means (manual, electronic) for any purpose.\n\nYou acknowledge that the test will be taken solely by you and that you will not consult any third person or use any other online or offline resource. \n\nYou will receive warnings if prohibited behavior is detected. Multiple instances of prohibited behavior will result in automatic shut-down of the test and rejection of your application.";

  String note =
      "IMPORTANT NOTE: You are NOT allowed to open any other Browser/App switch between the this and other Apps/ Minimize the this app. The Test will automatically log out if a candidate is found switching through apps while taking the Test.";

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        bool pop = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const LogoutFromDisclaimerDialog()) ??
            false;
        return pop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Disclaimer and Rules"),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<Map<String, dynamic>?>(
                            future: DBService.instance.getTestData(
                                testID: widget.testData!['testID']),
                            builder: (ctx, snapshot) {
                              if (snapshot.hasData) {
                                var data = snapshot.data;
                                testQuestion = data!['questions'];
                                testTime = int.parse(data['testDuration']);
                                return buildTestDataTable(testData: data);
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Disclaimer:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(disclaimer),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          note,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () => startTheTest(),
                    child: const Text("Start the Test"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startTheTest() {
    log("Test is starting");

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => QuestionsScreen(
                  testQuestions: testQuestion,
                  testTime: testTime
                )));
  }

  Widget buildTestDataTable({required Map<String, dynamic>? testData}) {
    List<TableRow> widgets = [];
    testData!.forEach((key, value) {
      if (key != "questions") {
        key = key.replaceAll("test", "test ");

        widgets.add(TableRow(children: [
          Text(
            key.capitalize(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
            child: Text(
              ":",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 18)),
        ]));
      }
    });
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: widgets,
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
