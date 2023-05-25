import 'package:flutter/material.dart';
import 'package:ggc_desktop/API/api_service.dart';
import 'package:ggc_desktop/Models/achatTrans_model.dart';
import 'package:ggc_desktop/Models/client_model.dart';
import 'package:ggc_desktop/Models/tontine_model.dart';
import 'package:ggc_desktop/theme.dart';
import '../API/config.dart';

class ClientAchatTrans extends StatefulWidget {
  const ClientAchatTrans({Key? key}) : super(key: key);

  @override
  State<ClientAchatTrans> createState() => _ClientAchatTransState();
}

class _ClientAchatTransState extends State<ClientAchatTrans> {
  List<ClientModel> clientModel = [];
  ClientModel currClient = ClientModel();
  TontineModel currTontine = TontineModel();
  List<String> clientTontines = [];
  List<AchatTransModel> transactions = [];
  List<DataRow> transRows = [];

  var _data;
  var _dataTontine;
  AchatTransModel achatTransModel =
      AchatTransModel(solde: 0.0, montant: 0.0, designation: "");

  List<ClientModel> allClient = [];
  List<ClientModel> _foundClient = [];
  List<TontineModel> tontines = [];

  bool isColor = false;

  void searchFilter(String search) {
    List<ClientModel> results = [];
    if (search.isEmpty) {
      results = allClient;
    } else {
      results = allClient
          .where((client) =>
              client.nom.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundClient.clear();
      _foundClient = results;
    });
  }

  @override
  void initState() {
    _data = MongoDatabase.getCollectionData(Config.client_collection);
    _dataTontine = MongoDatabase.getCollectionData(Config.tontine_collection);
    super.initState();
  }

  @override
  Widget ViewClient(ClientModel clientModel) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currClient = clientModel;
        });
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(8.0),
        child: Text(
                  "${clientModel.nom} ${clientModel.prenom}",
                  style: TextStyle(fontFamily: globalTextFont, fontSize: 18,overflow: TextOverflow.clip),
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
          ),
          actions: [
            Container(
                margin: EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/ggc_logo.png',
                  width: 150,
                ))
          ],
        ),
        body: SafeArea(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: globalColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
                          Container(
                            child: const Text("Liste des Clients",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.fade)),
                          ),
                          Container(
                            height: 50,
                            padding: EdgeInsets.all(8.0),
                            color: Colors.white,
                            child: TextField(
                              onChanged: (value) {
                                searchFilter(value);
                              },
                              decoration: InputDecoration(
                                  hintText: "Recheche",
                                  labelStyle: TextStyle(color: Colors.black),
                                  border: InputBorder.none),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2 - 10,
                      color: Colors.grey,
                      child: StatefulBuilder(
                        builder: (context,setState){
                          return FutureBuilder(
                              future: _data,
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                    snapshot.hasData) {
                                  allClient.clear();
                                  for (int i = 0; i < snapshot.data.length; i++) {
                                    allClient.add(
                                        ClientModel.fromJson(snapshot.data[i]));
                                  }
                                  if (_foundClient.isEmpty) {
                                    _foundClient = allClient;
                                  }
                                  return Container(
                                    height:
                                    MediaQuery.of(context).size.height * 0.7,
                                    child: ListView.builder(
                                        itemCount: _foundClient.length,
                                        itemBuilder: (context, index) {
                                          isColor = !isColor;
                                          return ViewClient(
                                              _foundClient.elementAt(index));
                                        }),
                                  );
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return const Text("No data found");
                              });
                        }
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                //width: MediaQuery.of(context).size.width * 0.65,
                //margin: EdgeInsets.all(8.0),
                flex: 12,
                child: StatefulBuilder(builder: (context, setState) {
                  return FutureBuilder(
                    future: MongoDatabase.getTransactionByClientId(
                        currClient.id, currTontine.id),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        transactions.clear();
                        transRows.clear();
                        for (int i = 0; i < snapshot.data.length; i++) {
                          transactions
                              .add(AchatTransModel.fromJson(snapshot.data[i]));
                        }
                        for (int i = 0; i < transactions.length; i++) {
                          DataRow aRow = DataRow(
                            color: MaterialStateColor.resolveWith((states) {
                              //total = data[i]['nb_nuit'] * data[i]['cout']*1.0;
                              return const Color.fromRGBO(
                                  213, 214, 2, 223); //make tha magic!
                            }),
                            cells: [
                              DataCell(Text("${i + 1}")),
                              DataCell(Text("${transactions[i].id_client}")),
                              DataCell(Text("${transactions[i].date}")),
                              DataCell(Text("${transactions[i].montant}")),
                              DataCell(Text("${transactions[i].designation}")),
                              DataCell(Text("${transactions[i].retrait}")),
                              DataCell(Text("${transactions[i].solde}")),
                            ],
                          );
                          transRows.add(aRow);
                        }

                        return DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => const Color.fromRGBO(11, 6, 65, 1)),
                          dataRowHeight: 35,
                          headingRowHeight: 70,
                          columnSpacing:
                              MediaQuery.of(context).size.width * 0.035,
                          columns: [
                            DataColumn(
                              label: Text(
                                "ID",
                                style: columnTextStyle,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "ID Client",
                                style: columnTextStyle,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Dates",
                                style: columnTextStyle,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Versement / Entrée",
                                style: columnTextStyle,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Désignation",
                                style: columnTextStyle,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Retrait",
                                style: columnTextStyle,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Solde",
                                style: columnTextStyle,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                          ],
                          rows: transRows,
                        );
                      }
                      return Column(
                        children: [
                          DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => const Color.fromRGBO(11, 6, 65, 1)),
                            dataRowHeight: 35,
                            headingRowHeight: 70,
                            columnSpacing:
                                MediaQuery.of(context).size.width * 0.035,
                            columns: [
                              DataColumn(
                                label: Text(
                                  "ID",
                                  style: columnTextStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "ID Client",
                                  style: columnTextStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Dates",
                                  style: columnTextStyle,
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Versement / Entrée",
                                  style: columnTextStyle,
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Désignation",
                                  style: columnTextStyle,
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Retrait",
                                  style: columnTextStyle,
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Solde",
                                  style: columnTextStyle,
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                              ),
                            ],
                            rows: [],
                          ),
                          Center(
                            child: Text("Listes vides "),
                          )
                        ],
                      );
                    },
                  );
                }),
              )
            ])));
  }
}
