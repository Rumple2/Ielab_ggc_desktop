import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import '../../API/api_service.dart';
import '../../API/config.dart';

class TontineModel {
  late String id;
  late String typeTontine;
  late double montantTontine;
  late double montantParMise;
  late double montantPrelever;

  TontineModel(
      {this.id = "",
      this.typeTontine = "",
      this.montantTontine = 0.0,
      this.montantParMise = 0.0,
      this.montantPrelever = 0.0});

  TontineModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeTontine = json['typeTontine'];
    montantTontine = json['montantTontine'];
    montantParMise = json['montantMise'];
    montantPrelever = json['montant_prelever'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['typeTontine'] = typeTontine;
    _data['montantTontine'] = montantTontine;
    _data['montantMise'] = montantParMise;
    _data['montant_prelever'] = montantPrelever;

    return _data;
  }

  static Future<void> insertMise(
      TontineModel miseModel, BuildContext context) async {
    final _id = M.ObjectId().$oid;
    miseModel.id = _id;
    var result =
        await MongoDatabase.insert(miseModel.toJson(), Config.tontine_collection);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Tontine Enregistré "),
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

  static verificationMise(String idMise, context) async {
    var miseCot = await MongoDatabase.getCotisationByTontineId(idMise);
    if (miseCot.isEmpty) {
      await deleteMise(idMise, context);
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
                    Text(
                        "Il existe des mises en cours pour ce type de tontine!",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800))
                  ]),
                ));
          });
    }
  }

  static Future deleteMise(String idMise, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      await MongoDatabase.deleteById(
                              idMise, Config.tontine_collection)
                          .then((value) {
                        Navigator.of(context, rootNavigator: true).pop();

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Cotisation Supprimer"),
                          backgroundColor: Colors.green,
                        ));
                      });
                    },
                    child: Text("Oui")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
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
  }
}
