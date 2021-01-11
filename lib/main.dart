import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseflutter/core/DataStore.dart';
import 'package:firebaseflutter/core/Login.dart';
import 'package:firebaseflutter/keys.dart';
import 'package:flutter/material.dart';

import 'core/Login.dart';

void main() {
  runApp(FirebaseFlutter());
}

class FirebaseFlutter extends StatefulWidget {
  @override
  _FirebaseFlutterState createState() => _FirebaseFlutterState();
}

class _FirebaseFlutterState extends State<FirebaseFlutter> {
  @override
  void initState() {
    super.initState();
    ini();
  }

  void ini() async {
    Keys keys = Keys();
    await Firebase.initializeApp(
      options: FirebaseOptions(
        appId: keys.appId,
        databaseURL: keys.databaseURL,
        apiKey: keys.apiKey,
      ),
    );
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FirebaseFlutter",
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Text("error");
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Login();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blue),
                strokeWidth: 5,
              ),
            ),
          );
        },
      ),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => Login(),
        '/datastore': (BuildContext context) => DataStore(),
      },
    );
  }
}
