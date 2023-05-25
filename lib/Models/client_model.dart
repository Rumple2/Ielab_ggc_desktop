import 'package:flutter/material.dart';
import 'package:ggc_desktop/Models/cotisation_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import '../API/api_service.dart';
import '../API/config.dart';

class ClientModel {
  late String id;
  late String nom;
  late String prenom;
  late String nationalite;
  late String quartier;
  late String profession;
  late String contact;
  late String lieu_activite;
  late String id_agent;
  CotisationModel cModel =
      CotisationModel(id_client: "", id_mise: "", solde: 0.0);

  ClientModel({
    this.id = "",
    this.nom = "",
    this.prenom = "",
    this.nationalite = "",
    this.quartier = "",
    this.profession = "",
    this.contact = "",
    this.lieu_activite = "",
    this.id_agent = "",
  });

  ClientModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prenom = json['prenom'];
    nationalite = json['nationalite'];
    quartier = json['quartier'];
    profession = json['profession'];
    contact = json['contact'];
    lieu_activite = json['lieu_activite'];
    id_agent = json['id_agent'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nom'] = nom;
    _data['prenom'] = prenom;
    _data['nationalite'] = nationalite;
    _data['quartier'] = quartier;
    _data['profession'] = profession;
    _data['contact'] = contact;
    _data['lieu_activite'] = lieu_activite;
    _data['id_agent'] = id_agent;
    return _data;
  }

  static Future<void> insertClient(
      ClientModel clientModel, BuildContext context) async {
    final _id = M.ObjectId().$oid;
    clientModel.id = _id;
    var result = await MongoDatabase.insert(
        clientModel.toJson(), Config.client_collection);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Client Enregistré "),
      backgroundColor: Colors.green,
    ));
    if(result == false){
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text("Erreur"),
                content: Container(
                  height: 150,
                  child: Column(children: const [
                    Text(
                      "Echec de l'opération",
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                  ]),
                ));
          });
    }
  }

  static Future<void> modifierClient(
      ClientModel clientModel, BuildContext context) async {
    var result = await MongoDatabase.updateClient(clientModel, Config.client_collection);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Client Modifié"),
      backgroundColor: Colors.green,
    ));
  }

  static Future<bool> verificationStatutClient(
      String idClient,context) async {

    var clientCot = await MongoDatabase.getCotisationByClientId(idClient);
    if (clientCot.isEmpty) {
      deleteClient(idClient, context);
      return false;
    } else {
        return true;
    }
  }

  static Future<void> deleteClient(
      String idClient, BuildContext context) async {
    await MongoDatabase.deleteById(idClient, Config.client_collection);
  }
}
