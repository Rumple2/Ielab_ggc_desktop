import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggc_desktop/API/Config.dart';
import 'package:ggc_desktop/API/api_service.dart';
import 'package:ggc_desktop/theme.dart';
import 'package:path_provider/path_provider.dart';

class Backup {
  String adminsFile = "admin.json";
  String agentsFile = "agents.json";
  String clientsFile = "clients.json";
  String cotisationsFile = "tontines.json";
  String typeTontinesFile = "type_tontines.json";
  String transactions = "transactions.json";

  static Future<File> saveFile(String fileName, String fileContents,context) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/ggc_partenaires/$fileName');
    print(file);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    if (file.existsSync()) {
      final jsonString = jsonEncode(fileContents);
      file.writeAsStringSync(jsonString);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Sauvegarde $fileName Reussie"),
        backgroundColor: Colors.green,
      )
      );
      print('Le fichier $fileName a été créé avec succès!');
    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erreur de Sauvegarde $fileName"),
        backgroundColor: Colors.green,
      )
      );
      print("Impossible de créer le fichier $fileName");
    }
    return file.writeAsString(fileContents);
  }

  void SaveData(String adminsData, String agentsData, String clientsData, String cotisationsData,
      typetontinesData, transactionsData,context) async {
    final savedAdmins = await saveFile(adminsFile, adminsData,context);
    final savedAgents = await saveFile(agentsFile, agentsData,context);
    final savedClients = await saveFile(clientsFile, clientsData,context);
    final savedCotisations = await saveFile(cotisationsFile, cotisationsData,context);
    final savedTypetontines =
        await saveFile(typeTontinesFile, typetontinesData,context);
    final savedTransactions = await saveFile(transactions, transactionsData,context);
  }
}

class BackupBody extends StatefulWidget {
  const BackupBody({Key? key}) : super(key: key);

  @override
  State<BackupBody> createState() => _BackupBodyState();
}

class _BackupBodyState extends State<BackupBody> {
  var cotisatioons;
  var admins;
  var typetontines;
  var agents;
  var transactions;
  var clients;
  var cotisationsData = [];
  var adminsData = [];
  var typetontinesData = [];
  var agentsData = [];
  var transactionsData = [];
  var clientsData = [];

  void initState() {
    cotisatioons =
        MongoDatabase.getCollectionData(Config.cotisation_collection);
    admins = MongoDatabase.getCollectionData(Config.admin_collection);
    typetontines = MongoDatabase.getCollectionData(Config.tontine_collection);
    agents = MongoDatabase.getCollectionData(Config.agent_collection);
    transactions =
        MongoDatabase.getCollectionData(Config.transaction_collection);
    clients = MongoDatabase.getCollectionData(Config.client_collection);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text("Récupération des données",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26,decoration: TextDecoration.underline),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 150,
                  child: FutureBuilder(
                      future: admins,
                      builder: (context, AsyncSnapshot adminSnap) {
                        if (adminSnap.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (adminSnap.hasData &&
                            adminSnap.connectionState == ConnectionState.done) {
                          adminsData = adminSnap.data;
                          return Column(
                            children: [
                              Text(
                                "Admins",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Icon(
                                Icons.verified,
                                color: Colors.green,
                              )
                            ],
                          );
                        }
                        return Column(
                          children: [
                            Text(
                              "Admins",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Icon(
                              Icons.error,
                              color: Colors.red,
                            )
                          ],
                        );
                      }),
                ),
                Container(
                  height: 100,
                  width: 150,
                  child: FutureBuilder(
                      future: agents,
                      builder: (context, AsyncSnapshot agentSnap) {
                        if (agentSnap.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (agentSnap.hasData &&
                            agentSnap.connectionState == ConnectionState.done) {
                          agentsData.clear();
                            agentsData = agentSnap.data;

                          return Column(
                            children: [
                              Text(
                                "Agents Ok",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Icon(
                                Icons.verified,
                                color: Colors.green,
                              )
                            ],
                          );
                        }
                        return Column(
                          children: [
                            Text(
                              "Agents",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Icon(
                              Icons.error,
                              color: Colors.red,
                            )
                          ],
                        );
                      }),
                ),
                Container(
                  height: 100,
                  width: 150,
                  child: FutureBuilder(
                      future: clients,
                      builder: (context, AsyncSnapshot clientSnap) {
                        if (clientSnap.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (clientSnap.hasData &&
                            clientSnap.connectionState == ConnectionState.done) {
                          clientsData.clear();
                            clientsData = clientSnap.data;
                          return Column(
                            children: [
                              Text(
                                "Clients Ok",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Icon(
                                Icons.verified,
                                color: Colors.green,
                              )
                            ],
                          );
                        }
                        return Column(
                          children: [
                            Text(
                              "Clients",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Icon(
                              Icons.error,
                              color: Colors.red,
                            )
                          ],
                        );
                      }),
                ),
                Container(
                  height: 100,
                  width: 150,
                  child: FutureBuilder(
                      future: typetontines,
                      builder: (context, AsyncSnapshot typeTontineSnap) {
                        if (typeTontineSnap.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (typeTontineSnap.hasData &&
                            typeTontineSnap.connectionState == ConnectionState.done) {
                          typetontinesData.clear();
                            typetontinesData = typeTontineSnap.data;
                          return Column(
                            children: [
                              Text(
                                "TypeTontine ok",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Icon(
                                Icons.verified,
                                color: Colors.green,
                              )
                            ],
                          );
                        }
                        return Column(
                          children: [
                            Text(
                              "Types Tontines",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Icon(
                              Icons.error,
                              color: Colors.red,
                            )
                          ],
                        );
                      }),
                ),
                Container(
                  height: 100,
                  width: 150,
                  child: FutureBuilder(
                      future: cotisatioons,
                      builder: (context, AsyncSnapshot cotisationsSnap) {
                        if (cotisationsSnap.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (cotisationsSnap.hasData &&
                            cotisationsSnap.connectionState == ConnectionState.done) {
                          cotisationsData.clear();
                            cotisationsData = cotisationsSnap.data;
                          return Column(
                            children: [
                              Text(
                                "Cotisations ok",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Icon(
                                Icons.verified,
                                color: Colors.green,
                              )
                            ],
                          );
                        }
                        return Column(
                          children: [
                            Text(
                              "Cotisations",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Icon(
                              Icons.error,
                              color: Colors.red,
                            )
                          ],
                        );
                      }),
                ),
                Container(
                  height: 100,
                  width: 150,
                  child: FutureBuilder(
                      future: transactions,
                      builder: (context, AsyncSnapshot transactionSnap) {
                        if (transactionSnap.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (transactionSnap.hasData &&
                            transactionSnap.connectionState == ConnectionState.done) {
                          transactionsData.clear();
                            transactionsData = transactionSnap.data;
                          return Column(
                            children: [
                              Text(
                                "Transctions ok",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Icon(
                                Icons.verified,
                                color: Colors.green,
                              )
                            ],
                          );
                        }
                        return Column(
                          children: [
                            Text(
                              "Transactions",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Icon(
                              Icons.error,
                              color: Colors.red,
                            )
                          ],
                        );
                      }),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                /*print("Cotisation : " + cotisationsData.toString());
                print("Admins : " + adminsData.toString());
                print("Agents : " + agentsData.toString());
                print("Transacctions : " + transactionsData.toString());
                print("Clients : " + clientsData.toString());
                print("Type Tontines : " + typetontinesData.toString());*/
                Backup().SaveData(adminsData.toString(), agentsData.toString(), clientsData.toString(), cotisationsData.toString(), typetontinesData.toString(), transactionsData.toString(),context);
              },
              child: Text("Sauvégarder"),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 70), backgroundColor: globalColor),
            )
          ],
        ),
      ),
    );
  }
}
