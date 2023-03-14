import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import '../../API/api_service.dart';
import '../../API/config.dart';

class MiseModel {
  late String id;
  late String typeTontine;
  late double montantTontine;
  late double montantParMise;
  late double montantPrelever;

  MiseModel();
  MiseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeTontine = json['typeTontine'];
    montantTontine = json['montantTontine'];
    montantParMise = json['montantMise'];
    montantPrelever = json['montant_prelever'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nom'] = typeTontine;
    _data['montantTontine'] = montantTontine;
    _data['montantMise'] = montantParMise;
    _data['montant_prelever'] = montantPrelever;

    return _data;
  }

  static Future<void> insertMise(
      MiseModel miseModel, BuildContext context) async {
    final _id = M.ObjectId().$oid;
    miseModel.id = _id;
    var result =
        await MongoDatabase.insert(miseModel.toJson(), Config.mise_collection);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Mise Enregistré "),
      backgroundColor: Colors.green,
    ));
  }

  static Future<bool> deleteMise(String idMise, context) async {
    var miseCot = await MongoDatabase.getCotisationByMiseId(idMise);
    bool returnR = false;
    if (miseCot.length == 0) {
      print("Pas de client pour cette mise");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                actions: [
                  ElevatedButton(
                      onPressed: () async {
                        await MongoDatabase.deleteById(
                            idMise, Config.mise_collection);
                        returnR = true;
                      },
                      child: Text("Oui")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        returnR=false;
                      },
                      child: Text("Non annuler"))
                ],
                title: Text("Attention"),
                content: Container(
                  height: 100,
                  child: Text(
                    "Etes vous sur de vouloir supprimer cette cotisation ?",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ));
          });
      return returnR;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Attention"),
                content: Container(
                  height: 150,
                  child: Column(children: [
                    Text(
                      "Impossible de supprimer cette cotisation",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    Text("Il existe des mises en cours pour ce type de tontine!",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800))
                  ]),
                ));
          });
      return false;
    }
  }
}
