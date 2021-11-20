import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DBService {
  static DBService instance = DBService();

  Future<String> getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    final String userID = prefs.getString("userID").toString();
    return userID;
  }

  Future<void> setTestID({required String testID}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("testID", testID);
  }

  Future<List?> fetchAllTests({required String userID}) async {
    var ref = FirebaseFirestore.instance.doc("students/$userID");
    var value = await ref.get();
    List<dynamic>? assignedTests = value.get("assignedTest");
    return assignedTests;
  }

  Future<Map<String, dynamic>> checkIfTestAvailable() async {
    var currentTestData = <String, dynamic>{"isTestAvailable": false};

    String userID = await getUserID();
    List<dynamic>? assignedTests = await fetchAllTests(userID: userID);

    if (assignedTests!.isNotEmpty) {
      for (var test in assignedTests) {
        log(test.toString());
        var dateTime = DateTime.parse(test['testDateTime'].toDate().toString());
        var timeDifference = DateTime.now().difference(dateTime).inMinutes;
        if (timeDifference > 0 && timeDifference < 30) {
          await setTestID(testID: test['testID']);
          currentTestData = {
            "isTestAvailable": true,
            "testID": test['testID'],
            "testName": test['testName']
          };
          return currentTestData;
        }
      }
    }
    return currentTestData;
  }

  Future<Map<String, dynamic>?> getTestData({required String testID}) async {
    var testData = await FirebaseFirestore.instance.doc("tests/$testID").get();
    log(testData.data().toString());
    return testData.data();
  }

  Future<void> submitTestScore(
      {required int maxMarks, required int marksObtained}) async {
    String userID = await getUserID();
    String testID = await getTestID();
    var _ref = FirebaseFirestore.instance.doc("students/$userID");
    log("ref = $_ref and testID is:- $testID");
    var studentData = (await _ref.get());
    List allAssignedTests = studentData.data()!['assignedTest'];
    log(allAssignedTests.toString());

    var currentTest = {};

    for (var element in allAssignedTests) {
      if (element['testID'] == testID) {
        currentTest = element;
        break;
      }
    }
    allAssignedTests.remove(currentTest);
    currentTest['maxMarks'] = maxMarks;
    currentTest['marksObtained'] = marksObtained;
    _ref.update({
      "assignedTest": allAssignedTests,
      "submittedTest": FieldValue.arrayUnion([currentTest])
    });
  }

  getTestID() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.get("testID");
  }
}
