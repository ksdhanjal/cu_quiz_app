import 'dart:developer';

import 'package:cu_quiz_app/models/login_response.dart';
import 'package:cu_quiz_app/services/cloud_functions_service.dart';
import 'package:cu_quiz_app/services/database_service.dart';
import 'package:cu_quiz_app/ui/screens/disclaimer_screen.dart';
import 'package:cu_quiz_app/ui/widgets/dialogs.dart';
import 'package:cu_quiz_app/ui/widgets/textfields.dart';
import 'package:cu_quiz_app/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController uidController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // uidController.text = "19bav1181";
    // phoneController.text = "1234567890";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool pop = await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (ctx) => const ExitAppDialog()) ??
            false;

        return pop;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                const Spacer(),
                Container(
                    color: Colors.white.withOpacity(0.8),
                    child: Image.asset("assets/images/cu-logo.png")),
                const SizedBox(
                  height: 40,
                ),
                RoundedBorderTextField(
                  label: "UID",
                  hintText: "Enter Your UID",
                  controller: uidController,
                ),
                const SizedBox(
                  height: 10,
                ),
                RoundedBorderTextField(
                  hintText: "Enter Your 10 digit mobile number",
                  inputType: TextInputType.phone,
                  label: "Phone Number",
                  controller: phoneController,
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () => signIn(), child: const Text("Sign in")),
                const Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const LoadingDialog(
              text: "Logging in...",
            ));

    LoginResponse response = await CloudFunctionsService.instance
        .login(uid: uidController.text, phone: phoneController.text);

    Navigator.pop(context);
    Utils.instance.showToast(message: response.message);

    await Future.delayed(const Duration(milliseconds: 500));

    if (response.responseCode == 1) {
      showDialog(
          context: context,
          builder: (ctx) =>
              const LoadingDialog(text: "Fetching Assigned Tests"));

      Map<String, dynamic> currentTestData =
          await DBService.instance.checkIfTestAvailable();
      await Future.delayed(const Duration(milliseconds: 2000));
      Navigator.pop(context);

      if (currentTestData['isTestAvailable']) {
        Utils.instance.showToast(message: "Test Found");
        await Future.delayed(const Duration(milliseconds: 350));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DisclaimerScreen(
                      testData: currentTestData,
                    )));
      } else {
        log("showing not test available dialog");
        showDialog(
            context: context, builder: (ctx) => const NoCurrentTestDialog());
      }
    }
  }
}
