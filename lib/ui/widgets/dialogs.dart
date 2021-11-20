import 'package:cu_quiz_app/ui/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String text;

  const LoadingDialog({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
        child: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              width: 20,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}

class ExitTestDialog extends StatelessWidget {
  const ExitTestDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("Are you sure you want to logout and exit the test?"),
      content: const Text(
          "Pressing exit will log you out and exit and submit your test. You won't be able to redo the test."),
      actions: [
        TextButton(
            onPressed: () => {Navigator.pop(context, false)},
            child: const Text("Cancel")),
        TextButton(
            onPressed: () => {Navigator.pop(context, true)},
            child: const Text("Exit & Submit"))
      ],
    );
  }
}

class LogoutFromDisclaimerDialog extends StatelessWidget {
  const LogoutFromDisclaimerDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("Are you sure you want to logout and exit the test?"),
      content: const Text(
          "Pressing logout will log you out of the current session. You can come back later before the deadline to give your test"),
      actions: [
        TextButton(
            onPressed: () => {Navigator.pop(context, false)},
            child: const Text("Cancel")),
        TextButton(
            onPressed: () => {Navigator.pop(context, true)},
            child: const Text("Logout"))
      ],
    );
  }
}

class SubmitTestDialog extends StatelessWidget {
  final VoidCallback onSubmit;
  const SubmitTestDialog({Key? key, required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("Are you sure you want to submit the test?"),
      content: const Text(
          "Pressing submit will submit this test. You won't be able to change your answers or redo the test later."),
      actions: [
        TextButton(
            onPressed: () => {Navigator.pop(context, false)},
            child: const Text("Cancel")),
        TextButton(
            onPressed: () async{
              onSubmit();
              Navigator.pop(context, true);},
            child: const Text("Submit"))
      ],
    );
  }
}

class NoCurrentTestDialog extends StatelessWidget {
  const NoCurrentTestDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("No Test available!"),
      content: const Text("You don't have any test assigned to you right now. "
          "Come back when you have a test assigned. "),
      actions: [
        TextButton(
            onPressed: () => {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                      (route) => false)
                },
            child: const Text("Exit"))
      ],
    );
  }
}

class ExitAppDialog extends StatelessWidget {
  const ExitAppDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(
        "Are you sure?",
      ),
      content: const Text("Are you sure you want to exit the app?"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel")),
        TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Exit"))
      ],
    );
  }
}
