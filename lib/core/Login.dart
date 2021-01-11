import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

String email = "";
String password = "";

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Flutter"),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  registro() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Registrado correctamente"),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Login correcto"),
          backgroundColor: Colors.blue,
        ),
      );
      User user = FirebaseAuth.instance.currentUser;
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushNamed(context, "/datastore");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Sesión cerrada"),
          backgroundColor: Colors.red,
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  void estado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Logeado"),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Deslogeado"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onChanged: (text) {
              setState(() {
                email = text;
              });
            },
          ),
        ),
        //----------------------
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onChanged: (text) {
              setState(() {
                password = text;
              });
            },
          ),
        ),
        //----------------------Registro
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: FlatButton(
            onPressed: () {
              if (email.isNotEmpty && password.isNotEmpty) {
                registro();
              }
            },
            child: Text(
              "Registrarse",
            ),
            color: Colors.green,
            textColor: Colors.white,
          ),
        ),
        //----------------------login
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: FlatButton(
            onPressed: () {
              if (email.isNotEmpty && password.isNotEmpty) {
                login();
              }
            },
            child: Text(
              "Login",
            ),
            color: Colors.blue,
            textColor: Colors.white,
          ),
        ),
        //----------------------Logout
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: FlatButton(
            onPressed: () {
              logout();
            },
            child: Text(
              "Logout",
            ),
            color: Colors.red,
            textColor: Colors.white,
          ),
        ),
        //----------------------Logout
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: FlatButton(
            onPressed: () {
              estado();
            },
            child: Text(
              "Estado",
            ),
            color: Colors.purple,
            textColor: Colors.white,
          ),
        )
      ],
    );
  }
}
