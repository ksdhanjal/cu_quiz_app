import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:cu_quiz_app/models/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CloudFunctionsService {
  static CloudFunctionsService instance = CloudFunctionsService();

  void useFunctionsEmulator() {
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  }

  Future<LoginResponse> login(
      {required String uid, required String phone}) async {
    try {
      // useFunctionsEmulator()
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable("login");

      final response = await callable.call({"uid": uid, "phone": phone});
      log(response.data.toString());
      LoginResponse result = LoginResponse.fromJson(response.data);
      if (result.responseCode == 1) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("userID", response.data['userID']);
      }
      return result;
    } catch (e) {

      log("error caught: -" + e.toString());
      LoginResponse errorResult = LoginResponse(
          responseCode: 3, message: 'unknown error occurred', status: 'failed');
      return errorResult;
    }
  }
}
