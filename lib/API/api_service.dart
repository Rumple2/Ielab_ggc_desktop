import 'package:ggc_desktop/API/encryption.dart';
import 'package:ggc_desktop/Models/AdminModel.dart';
import 'package:ggc_desktop/Models/agent_model.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../Models/client_model.dart';
import '../Models/tontine_model.dart';
import 'config.dart';

class MongoDatabase {
  static var db, dbcollection;

  static getConnection() async {
    print("Actual State ${db.state}");
    if (!db.isConnected || db.state == State.opening) {
      await db.close();
      print('closing the opening connexion');
    }

    if (db.state == State.closed) {
      print('opening connexion');
      connect();
    }

    print("Db State ${db.state}");
  }

  static connect() async {
    db = await Db.create(Config.MONGO_CONN_URL);
    try {
      await db.open();
    } catch (e) {
      print('Failed to open DB: $e');
      rethrow;
    }
  }

  static Future<List<Map<String,dynamic>>> getCollectionData(String collection) async{
  getConnection();
    final dataCollection = db.collection(collection);
    final arrData = await dataCollection.find().toList();
    return arrData;
  }


  static Future<bool> insert(var data, String collection) async {
    getConnection();
    try {
      var insertCollection = db.collection(collection);
      final result =  await insertCollection.insertOne(data);
      print(result);
      if (result.isSuccess || result.operationSucceeded) {
        print("Operation success");
        return true;
      }else{
        print("Operation Failled ");
        return false;

      }
    } catch (e) {
      print("Operation Failled"+e.toString());
      return false;
    }finally{
      getConnection();
    }
  }
  static Future<String> deleteById(String id, String collection) async {
    getConnection();
    var dataCollection = db.collection(collection);
      var result = await dataCollection.remove(where.eq('id', id));
    return result.toString();
  }
  static Future<void> insertNotification() async {
    getConnection();

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
    getConnection();

    final coll = db.collection(collection);
    print(agentModel.id);
    var filter = where.eq('id','${agentModel.id}');
    print(agentModel.toJson());
    var update = {
      r'$set': agentModel.toJson()
    };
    var result = await coll.update(filter, update);
      print(agentModel.id);
      return result.toString();
  }
  static Future<String> updateAdmin(AdminModel adminModel,String collection) async{
    getConnection();
    final coll = db.collection(collection);
    print(adminModel.id);
    var filter = where.eq('id','${adminModel.id}');
    print(adminModel.toJson());
    var update = {
      r'$set': adminModel.toJson()
    };
    var result = await coll.update(filter, update);
    return result.toString();
  }
//Mise à jour d'un client
  static Future<String> updateClient(ClientModel clientModel,String collection) async{
    getConnection();
    final coll = db.collection(collection);
    var filter = where.eq('id','${clientModel.id}');
    print(clientModel.toJson());
    var update = {
      r'$set': clientModel.toJson()
    };
    var result = await coll.update(filter, update);
    return result.toString();
  }

  //Mise à jour d'une collection
  static Future<void> updateCollection(var data,String collection) async{
    getConnection();
    var cotCollection = db.collection(collection);
    var filter = where.eq('id', data.id);
    var update = {r'$set': data.toJson()};
    var result = await cotCollection.update(filter, update);
  }

  // Récuperation de cotisation par l'id du client
  static Future<List<Map<String,dynamic>>> getCotisationByClientId(String clientId) async{
    getConnection();

    final dataCollection = db.collection(Config.cotisation_collection);
    final arrData = await dataCollection.find(where.eq("id_client", clientId)).toList();
    return arrData;
  }

  // Récuperation d'une cotisation par l'id de l'agent

  static Future<List<Map<String, dynamic>>> getCotisationByAgentId(String AgentId) async {
    getConnection();
    final dataCollection = db.collection(Config.cotisation_collection);
    final arrData = await dataCollection.find(where.eq("id_agent", AgentId)).toList();
    return arrData;
  }

  // Récuperation de transactino par l'id du client
  static Future<List<Map<String,dynamic>>> getTransactionByClientId(String clientId,String tontineId) async{
    getConnection();
    final dataCollection = db.collection(Config.transaction_collection);
    final arrData = await dataCollection.find(where.eq("id_client", clientId).sortBy('id_tontine')).toList();
    return arrData;
  }

  //Récuperation de cotisation par id de tontine
  static Future<List<Map<String,dynamic>>> getCotisationByTontineId(String tontineId) async{
    getConnection();
    final dataCollection = db.collection(Config.cotisation_collection);
    final arrData = await dataCollection.find(where.eq("id_mise", tontineId)).toList();
    return arrData;
  }

  //Récuperation de Tontine par id
  static Future<TontineModel> getTontineById(String? tontineId) async{
    getConnection();
    var dataCollection = db.collection(Config.tontine_collection);
    var arrData = await dataCollection.findOne({"id": tontineId});
    return TontineModel.fromJson(arrData!);
  }
  //Client par id
  static Future<ClientModel> getClientById(String? clientId) async{
    getConnection();
    var dataCollection = db.collection(Config.client_collection);
    var arrData = await dataCollection.findOne({"id": clientId});
    return ClientModel.fromJson(arrData!);
  }

  //Connection admin : Auth
  static Future<bool> adminLogin(String numTel,String mdp) async{
    getConnection();
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

  // Connection agent: Auth
  static Future<bool> agentLogin(String numTel,String mdp) async{
    getConnection();
    bool reponse = false;
    String mdpCrypted = Encryption.EncryptPassword(mdp);
    final dataCollection =  db.collection(Config.agent_collection);
    var arrData = await dataCollection.findOne({"telephone": numTel,"mdp":mdpCrypted});
    if(arrData!.isEmpty){
      reponse = true;
    }else reponse = false;
    return reponse;
  }

}
