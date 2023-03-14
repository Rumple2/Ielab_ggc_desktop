import 'package:flutter/material.dart';
import 'package:ggc_desktop/API/api_service.dart';
import 'package:ggc_desktop/Models/achatTrans_model.dart';
import 'package:ggc_desktop/Models/client_model.dart';
import 'package:ggc_desktop/theme.dart';
import 'package:ggc_desktop/utils/constants.dart';

import '../API/config.dart';

class ClientAchatTrans extends StatefulWidget {
  const ClientAchatTrans({Key? key}) : super(key: key);

  @override
  State<ClientAchatTrans> createState() => _ClientAchatTransState();
}

class _ClientAchatTransState extends State<ClientAchatTrans> {
  List<ClientModel> clientModel = [];
  late final _data;
  AchatTransModel achatTransModel =
      AchatTransModel(solde: 0.0, montant: 0.0, designation: "");

  List<ClientModel> allClient = [];
  List<ClientModel> _foundClient = [];
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
    _data = MongoDatabase.getCollectionData(
        Config.client_collection);
    super.initState();
  }


  @override
  Widget ViewClient(var clientModel) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        height: 40,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isColor ? Colors.black12 : Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${clientModel.nom} ${clientModel.prenom}",
                  style: TextStyle(fontFamily: globalTextFont, fontSize: 18),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed:(){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back),color: Colors.black,),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: globalColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Liste des Clients"),
                        Container(
                          height: 50,
                          width: 200,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.white,
                          child: TextField(
                            onChanged: (value){
                              searchFilter(value);
                            },
                            decoration: InputDecoration(
                              label: Text("Recherche .."),
                              border: InputBorder.none
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *0.2 - 10,
                    child: FutureBuilder(
                        future: _data,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.done &&
                              snapshot.hasData) {
                            allClient.clear();
                              for(int i = 0; i < snapshot.data.length; i++){
                                allClient.add(ClientModel.fromJson(snapshot.data[i]));
                              }
                              if(_foundClient.isEmpty){
                                _foundClient = allClient;
                              }
                            return Container(
                              height: MediaQuery.of(context).size.height *0.7,
                              child: ListView.builder(
                                  itemCount: _foundClient.length,
                                  itemBuilder: (context, index) {
                                    isColor = !isColor;
                                    return ViewClient(_foundClient.elementAt(index));
                                  }),
                            );
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return const Text("No data founde");
                        }),
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              margin: EdgeInsets.all(8.0),
              color: Colors.green,
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromRGBO(11, 6, 65, 1)),
                dataRowHeight: 35,
                headingRowHeight: 70,
                columnSpacing: MediaQuery.of(context).size.width * 0.03,
                columns: [
                  DataColumn(
                    label: Text(
                      "ID",
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
                /*rows:[
                          for(int i = 0; i < dataLength; i++)
                            DataRow(


                                color: MaterialStateColor.resolveWith((states) {
                                  //total = data[i]['nb_nuit'] * data[i]['cout']*1.0;
                                  return const Color.fromRGBO(
                                      241, 234, 227, 1); //make tha magic!
                                }),
                                cells: [


                                  DataCell(
                                      onTap: () {
                                        // Your code here
                                        generateInvoice('nom',  'prenomfac', 1234,6789, 7865, '11/21/1234', '93/43/3423', 'cafe', 12.3, 21.7, 2,20 ,1230438);
                                      },
                                     // Text(data[i]['id_res'])
                                  ),
                                  DataCell(
                                      onTap: () {
                                        // Your code here
                                       // generateInvoice('nom',  'prenomfac', 1234,6789, 7865, '11/21/1234', '93/43/3423', 'cafe', 12.3, 21.7, 2,20 ,1230438);
                                      },
                                      Text(data[i]['id_res'].toString())
                                  ),
                                  DataCell(Text(data[i]['prenom'].toString())),
                                  DataCell(Text(data[i]['telephone'].toString())),
                                  DataCell(Text(data[i]['descriptions'].toString())),
                                  DataCell(Text("${data[i]['personne'].toString()}")),
                                  DataCell(Text(data[i]['cout'].toString())),
                                  DataCell(Text(data[i]['date_res'].toString())),
                                  DataCell(Text(data[i]['date_fin_res'].toString())),
                                  DataCell(Text("${data[i]['nb_nuit'].toString()}")),
                                  DataCell(Text(data[i]['source'].toString())),
                                  DataCell(data[i]['status_res']?Icon(Icons.check_circle,color: Colors.green,):Icon(Icons.cancel,color: Colors.redAccent,)),
                                  DataCell(Text("Action"))
                                ]
                            )

                        ]*/
              ),
            )
          ],
        ),
      ),
    );
  }
}
