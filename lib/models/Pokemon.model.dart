import 'package:firebase_auth/firebase_auth.dart';

class Pokemon {
  String name;
  String type;
  // var user = userV();
  Pokemon({this.name, this.type}) {}

  Map<String, String> toJson() {
    return {
      'name': name,
      'type': type,
    };
  }

  // List<Pokemon> lista(data) {
  //   Pokemon newPoke;
  //   data.forEach((name, type) {
  //     newLista.add(Pokemon(name: type["name"], type: type["type"]));
  //   });
  //   pok
  //   return newPoke;
  // }
}

dynamic userV() {
  var us = FirebaseAuth.instance.currentUser;
  return us;
}
