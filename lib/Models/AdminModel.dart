import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:mongo_dart/mongo_dart.dart';
import '../API/api_service.dart';
import '../API/config.dart';
import '../API/encryption.dart';

class AdminModel{

  late String id;
  late String nom;
  late String telephone;
  late String mdp;
AdminModel({
   this.id = "",
  this.nom = "",
  this.telephone = "",
  this.mdp = "",
});
  AdminModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    nom = json['nom'];
    telephone = json['telephone'];
    mdp = json['mdp'];
  }
  Map<String,dynamic> toJson(){
    final _data = <String,dynamic> {};
    _data['id'] = id;
    _data['nom'] = nom;
    _data['telephone'] = telephone;
    _data['mdp'] = mdp;

    return _data;
  }

  static Future<void> insertAdmin(
      AdminModel userModel, context) async {
    userModel.mdp = Encryption.EncryptPassword(userModel.mdp);
    final _id = M.ObjectId().$oid;
    userModel.id = _id;
    bool result = await MongoDatabase.insert(
        userModel.toJson(), Config.admin_collection);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Admin Enregistré "),
      backgroundColor: Colors.green,
    )
    );
    print(result);
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
  static Future<void> modifierAdmin(
      AdminModel adminModel, BuildContext context) async {
    adminModel.mdp = Encryption.EncryptPassword(adminModel.mdp);
    var result = await MongoDatabase.updateAdmin(adminModel,Config.admin_collection);
    print(result);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Admin Modifié"),
      backgroundColor: Colors.green,
    )
    );
  }
  static Future<void> deleteAdmin(String idAdmin, BuildContext context) async {
    var result = await MongoDatabase.deleteById(idAdmin,Config.admin_collection);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Admin Supprimé"),
      backgroundColor: Colors.green,
    )
    );
  }
}