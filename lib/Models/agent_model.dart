import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggc_desktop/API/encryption.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import '../API/api_service.dart';
import '../API/config.dart';

class AgentModel{
  late String id;
  late String nom;
  late String prenom;
  late String telephone;
  late String adresse;
  late String zoneAffectation;
  late String mdp;

  AgentModel({
    this.id ="",
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.adresse,
    required this.zoneAffectation,
    required this.mdp
  });

  AgentModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    nom = json['nom'];
    prenom =json['prenom'];
    telephone = json['telephone'];
    adresse = json['adresse'];
    zoneAffectation = json['zoneA'];
    mdp = json['mdp'];
  }
  Map<String,dynamic> toJson(){
    final _data = <String,dynamic> {};
    _data['id'] = id;
    _data['nom'] = nom;
    _data['prenom'] = prenom;
    _data['telephone'] = telephone;
    _data['adresse'] = adresse;
    _data ['zoneA'] = zoneAffectation;
    _data['mdp'] = mdp;

    return _data;
  }

  static Future<void> insertAgent(
      AgentModel userModel, BuildContext context) async {
      userModel.mdp = Encryption.EncryptPassword(userModel.mdp);
      final _id = M.ObjectId().$oid;
      userModel.id = _id;
    var result = await MongoDatabase.insert(
        userModel.toJson(), Config.agent_collection);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Agent Enregistré "),
    backgroundColor: Colors.green,
    )
    );
  }
  static Future<void> modifierAgent(
      AgentModel agentModel, BuildContext context) async {
    agentModel.mdp = Encryption.EncryptPassword(agentModel.mdp);
    var result = await MongoDatabase.updateAgent(agentModel,Config.agent_collection);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Agent Modifier"),
      backgroundColor: Colors.green,
    )
    );
  }
  static Future<void> deleteAgent(String idAgent, BuildContext context) async {
    var result = await MongoDatabase.deleteById(idAgent,Config.agent_collection);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Agent Modifier"),
      backgroundColor: Colors.green,
    )
    );
  }
}