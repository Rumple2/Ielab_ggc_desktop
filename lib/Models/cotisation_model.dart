import 'package:flutter/material.dart';
import '../API/api_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../API/config.dart';

class CotisationModel {
  late String id;
  late String id_client;
  late String id_mise;
  late String id_agent;
  double solde = 0.0;
  List pages = [];
  List dates_cot = [];
  int posPage = 0;

  CotisationModel({
    this.id_client = "",
    this.id_mise = "",
    this.solde = 0.0
  });

  CotisationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    id_client = json['id_client'];
    id_mise = json['id_mise'];
    solde = json['solde'];
    pages = json['pages'];
    dates_cot = json['date_cot'];
    posPage = json['posPage'];
    id_agent = json['id_agent'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['id_client'] = id_client;
    _data['id_mise'] = id_mise;
    _data['solde'] = solde;
    _data['pages'] = pages;
    _data['date_cot'] = dates_cot;
    _data['posPages'] = posPage;
    _data['id_agent'] = id_agent;
    return _data;
  }

  static Future<void> insertCotisation(String clientId, String miseId,double montant, BuildContext context) async {
    var _id = ObjectId().$oid;
    CotisationModel cotisationModel = CotisationModel(id_client: clientId, id_mise: miseId,solde:montant );
    cotisationModel.id = _id;
    var result_res = await MongoDatabase.insert(
        cotisationModel.toJson(), Config.cotisation_collection);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Cotisation Enregistré "),
    backgroundColor: Colors.green,
    ));
  }
  static Future<void> deleteCotisation(String idAgent, BuildContext context) async {
    var result = await MongoDatabase.deleteById(idAgent,Config.cotisation_collection);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Agent Modifier"),
      backgroundColor: Colors.green,
    )
    );
  }
}
