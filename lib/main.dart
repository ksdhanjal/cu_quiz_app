import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cu_quiz_app/ui/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(color: Colors.red,
            child: const Text("something wrong happened", style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),),);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
          FirebaseFirestore firestore = FirebaseFirestore.instance;

          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.red,
              ),
              home: const LoginScreen()
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
          color: Colors.white, child: const CircularProgressIndicator(),);
      },
    );


    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const LoginScreen()
    );
  }
}

