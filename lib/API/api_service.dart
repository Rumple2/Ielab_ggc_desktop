import 'package:ggc_desktop/API/encryption.dart';
import 'package:ggc_desktop/Models/agent_model.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../Models/client_model.dart';
import '../Models/mise_model.dart';
import 'config.dart';

class MongoDatabase {
  static var db, dbcollection;

  static connect() async {
    db = await Db.create(Config.MONGO_CONN_URL);
    await db.open();
  }

  static Future<List<Map<String,dynamic>>> getCollectionData(String collection) async{
    final dataCollection = db.collection(collection);
    final arrData = await dataCollection.find().toList();
    return arrData;

  }

  static Future<String> insert(var data, String collection) async {
    await db.open();
    try {
      var insertCollection = db.collection(collection);
      var result = insertCollection.insertOne(data);
      if (result.isSucces) {
        return "Data Inserted";
      } else
        return "Operation Failled";
    } catch (e) {
      print(e.toString());
      return e.toString();
    }

  }
  static Future<String> deleteById(String id, String collection) async {
      var dataCollection = db.collection(collection);
      var result = dataCollection.remove(where.eq('id', id));
     return "Hi";
  }
  static Future<void> insertNotification() async {
    final cotCollection = await getCollectionData(Config.cotisation_collection);
    final notifCollection = db.collection(Config.notif_collection);
    print("voici ${cotCollection.length}");
    for(int i =0; i < cotCollection.length; i++){
      if(cotCollection[i]['posPage'] >= 10){
       // notifCollection.insert
    }
    }
  }

  static Future<String> updateAgent(AgentModel agentModel,String collection) async{
      final dataCollection = db.collection(collection);
      print(agentModel.id);
      var findA = await dataCollection.findOne({"id":agentModel.id });
      findA['nom'] = agentModel.nom;
      findA['prenom'] = agentModel.prenom;
      findA['adresse'] = agentModel.adresse;
      findA['telephone'] = agentModel.telephone;
      findA['zoneA'] = agentModel.zoneAffectation;
      findA['mdp'] = agentModel.mdp;
      final result = await dataCollection.save(findA).toString();
      return result.toString();
  }

  static Future<String> updateClient(ClientModel clientModel,String collection) async{
    final dataCollection = db.collection(collection);
    print(clientModel.id);
    var findC = await dataCollection.findOne({"id":clientModel.id });
    findC['nom'] = clientModel.nom;
    findC['prenom'] = clientModel.prenom;
    findC['contact'] =clientModel.contact;
    findC['quartier'] = clientModel.quartier;
    findC['nationalite'] = clientModel.nationalite;
    findC['lieu_activite'] = clientModel.lieu_activite;
    findC['profession'] = clientModel.profession;
    final result = await dataCollection.save(findC).toString();
    return result.toString();
  }
  static Future<List<Map<String,dynamic>>> getCotisationByClientId(String? clientId) async{
    final dataCollection = db.collection(Config.cotisation_collection);
    final arrData = await dataCollection.find(where.eq("id_client", clientId)).toList();
    return arrData;
  }
  static Future<List<Map<String,dynamic>>> getCotisationByMiseId(String? miseId) async{
    final dataCollection = db.collection(Config.cotisation_collection);
    final arrData = await dataCollection.find(where.eq("id_mise", miseId)).toList();
    return arrData;
  }
  static Future<MiseModel> getMiseById(String? miseId) async{
    var dataCollection = db.collection(Config.mise_collection);
    var arrData = await dataCollection.findOne({"id": miseId});
    return MiseModel.fromJson(arrData);
  }
  static Future<ClientModel> getClientById(String? clientId) async{

    var dataCollection = db.collection(Config.client_collection);
    var arrData = await dataCollection.findOne({"id": clientId});
    return ClientModel.fromJson(arrData);
  }

  static Future<bool> adminLogin(String numTel,String mdp) async{
    bool reponse = false;
    String mdpCrypted = Encryption.EncryptPassword(mdp);
    final dataCollection =  db.collection(Config.admin_collection);
    var arrData = await dataCollection.findOne({"telephone": numTel.trim(),"mdp":mdpCrypted});
    print(numTel);
    if(arrData !=null){
      print("Trouvé");
      reponse = true;
    }else {
      reponse = false;
      print("Non trouvé");
    }
    return reponse;

  }

  static Future<bool> agentLogin(String numTel,String mdp) async{
    bool reponse = false;
    String mdpCrypted = Encryption.EncryptPassword(mdp);
    final dataCollection =  db.collection(Config.agent_collection);
    var arrData = await dataCollection.findOne({"telephone": numTel,"mdp":mdpCrypted});
    if(!arrData.isEmpty){
      reponse = true;
    }else reponse = false;
    return reponse;
  }

}
