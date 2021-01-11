import 'dart:math';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebaseflutter/models/Pokemon.model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DataStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Store"),
      ),
      body: Body(),
    );
  }
}

String data = "";

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController _controller = TextEditingController();

  //----------------Escribir--------------
  void sendData() async {
    //---Referencia---
    try {
      var id = FirebaseDatabase.instance.reference().child("pokemon/");
      Pokemon poke = Pokemon(name: data, type: tipo());
      id.push().set(poke.toJson());
      snack(context, Colors.green, "Pokemon generado");
      setState(() {
        _controller.text = "";
      });
    } catch (e) {
      print(e);
      snack(context, Colors.red, "Error");
    }
  }

  @override
  void initState() {
    super.initState();
    ini();
  }

//-------Actualizar----------------
  void ini() async {
    try {
      Map<String, dynamic> poke = {"name": "charmander", "type": "${tipo()}"};
      var id0 =
          await FirebaseDatabase.instance.reference().child("pokemon/").once();
      Map<dynamic, dynamic> id1 = id0.value;
      String id = "";
      id1.forEach((key, value) {
        print(key);
        id = key;
      });

      await FirebaseDatabase.instance
          .reference()
          .child("pokemon/${id}")
          .update(poke);
    } catch (e) {
      print('---------------------------------');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Texto",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onChanged: (text) {
                      data = text;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                    iconSize: 35,
                    onPressed: () {
                      if (data.isNotEmpty) {
                        sendData();
                      } else {
                        snack(context, Colors.red, "Escriba un nombre");
                      }
                    }),
              ),
            ],
          ),
          Flexible(
              child: FirebaseAnimatedList(
            query: FirebaseDatabase.instance.reference().child("pokemon/"),
            itemBuilder: (context, dataSnapshot, animation, x) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                        "Nombre: ${dataSnapshot.value["name"]} \n\nTipo: ${dataSnapshot.value["type"]}"),
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}

String tipo() {
  int ran = Random().nextInt(3);
  String nam = "";

  switch (ran) {
    case 1:
      nam = "Agua";
      break;
    case 2:
      nam = "Fuego";
      break;
    default:
      nam = "Planta";
  }

  return nam;
}

void snack(BuildContext context, Color col, String text) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: col,
    ),
  );
}
