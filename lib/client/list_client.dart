import 'package:flutter/material.dart';
import 'package:ggc_desktop/API/api_service.dart';
import 'package:ggc_desktop/API/config.dart';
import 'package:ggc_desktop/Models/agent_model.dart';
import 'package:ggc_desktop/Models/client_model.dart';
import 'package:ggc_desktop/client/BodyClient.dart';

import '../desktop_body.dart';
import '../theme.dart';

class ListClient extends StatefulWidget {
  ListClient({Key? key}) : super(key: key);
  @override
  _ListClientState createState() => _ListClientState();
}

class _ListClientState extends State<ListClient> {
  final nom = TextEditingController();
  final prenom = TextEditingController();
  final adresse = TextEditingController();
  final contact = TextEditingController();
  final profession = TextEditingController();
  final lieu_activite = TextEditingController();
  final nationalite = TextEditingController();
  final quartier = TextEditingController();


  List<ClientModel> clientList = [];
  List<ClientModel> _filterClient = [];
  List<DataRow> _clientRow = [];
  final clientFormKey = GlobalKey<FormState>();
 late final _data;
  void searchFilter(String search) {
    List<ClientModel> results = [];
    if (search.isEmpty) {
      results = clientList;
    } else {
      results = clientList
          .where((client) =>
          client.id.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    setState(() {
      _filterClient.clear();
      _filterClient= results;
    });
  }
  reloadPage(context) {
    currentPage = BodyClient();
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => DesktopBody()));
  }

  @override
  void initState() {
    _data = MongoDatabase.getCollectionData(Config.client_collection);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder(
            future: _data,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                clientList.clear();
                _clientRow.clear();
                for (int i = 0; i < snapshot.data.length; i++) {
                  clientList.add(ClientModel.fromJson(snapshot.data[i]));
                }
               if(_filterClient.isEmpty)
                 _filterClient = clientList;
                nombreClient = clientList.length ;
                for (int i = 0; i < _filterClient.length; i++) {
                  DataRow aRow = DataRow(
                    color: MaterialStateColor.resolveWith((states) {
                      //total = data[i]['nb_nuit'] * data[i]['cout']*1.0;
                      return const Color.fromRGBO(
                          213, 214, 223, 1); //make tha magic!
                    }),
                    cells: [
                      DataCell(
                          Text("${_filterClient[i].id}")),
                      DataCell(Text("${_filterClient[i].nom}")),
                      DataCell(Text("${_filterClient[i].prenom}")),
                      DataCell(Text("${_filterClient[i].nationalite}")),
                      DataCell(Text("${_filterClient[i].lieu_activite}")),
                      DataCell(Text("${_filterClient[i].quartier}")),
                      DataCell(Text("${_filterClient[i].profession}")),
                      DataCell(Text("${_filterClient[i].contact}")),
                      DataCell(Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              ModifierClient(_filterClient[i]);
                            },
                            icon: Icon(Icons.edit),
                          ),
                          SizedBox(width: 10,),
                          IconButton(
                            onPressed: () {
                              deleteClient(_filterClient[i]);
                            },
                            icon: Icon(Icons.delete),
                          )
                        ],
                      ))
                    ],
                  );
                  _clientRow.add(aRow);
                }
                return Container(
                  //width: MediaQuery.of(context).size.width ,
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.0),
                              height: 45,
                              width: MediaQuery.of(context).size.width/4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(2)),
                              child: TextField(
                                onChanged:(value){
                                  searchFilter(value);
                                },
                                decoration: InputDecoration(
                                  icon: Icon(Icons.search_rounded),
                                    hintText: "Rechercher avec identifiant",
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                            Text("Liste des clients",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24, ),),
                            IconButton(
                                onPressed: () {
                                  reloadPage(context);
                                },
                                icon: Icon(Icons.refresh))
                          ],
                        ),
                      ),
                      DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => globalColor),
                          dataRowHeight: 35,
                          headingRowHeight: 70,
                          columnSpacing:
                          MediaQuery.of(context).size.width * 0.07,
                          columns: [
                            DataColumn(
                              label: Text(
                                "ID",
                                style: columnTextStyle,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Nom",
                                style: columnTextStyle,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Prenom",
                                style: columnTextStyle,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Nationalité",
                                style: columnTextStyle,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Zone",
                                style: columnTextStyle,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Lieu Activité",
                                style: columnTextStyle,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Quartier",
                                style: columnTextStyle,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Contact",
                                style: columnTextStyle,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Mise à jour",
                                style: columnTextStyle,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),

                          ],
                          rows: _clientRow),
                    ],
                  ),
                );
              }
              return Center(
                child: Text("No data"),
              );
            }),
      ),
    );
  }

 Future<void> ModifierClient(ClientModel currClienttData) async {
   double textFieldWidth= 200;
   nom.text = currClienttData.nom;
   prenom.text = currClienttData.prenom;
   contact.text = currClienttData.contact;
   quartier.text = currClienttData.quartier;
   lieu_activite.text = currClienttData.lieu_activite;
   profession.text = currClienttData.profession;
   nationalite.text = currClienttData.nationalite;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 400,
            width: 500,
            child: Form(
              key: clientFormKey,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("MODIFIER LE CLIENT",
                          style: TextStyle(
                              fontSize: 26, fontFamily: globalTextFont)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Modifier seulement les cases concernées",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: globalTextFont,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: EdgeInsets.all(8.0),
                          width: textFieldWidth,
                          child: TextFormField(
                            controller: nom,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Champ obligatoire*";
                              }
                            },
                            decoration: formDecoration("Nom : ",
                                last: currClienttData.nom),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8.0),
                          width: textFieldWidth,
                          child: TextFormField(
                            controller: prenom,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Champ obligatoire*";
                              }
                            },
                            decoration: formDecoration("Prenom : ",
                                last: currClienttData.prenom),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: EdgeInsets.all(8.0),
                          width: textFieldWidth,
                          child: TextFormField(
                            controller: quartier,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Champ obligatoire*";
                              }
                            },
                            decoration: formDecoration("Quarier : ",
                                last: currClienttData.quartier),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8.0),
                          width: textFieldWidth,
                          child: TextFormField(
                            controller: profession,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Champ obligatoire*";
                              }
                            },
                            decoration: formDecoration("Profession : ",
                                last: currClienttData.profession),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: EdgeInsets.all(8.0),
                          width: textFieldWidth,
                          child: TextFormField(
                            controller: contact,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Champ obligatoire*";
                              }
                            },
                            decoration: formDecoration("Contact: ",
                                last: currClienttData.contact),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.all(8.0),
                          width: textFieldWidth,
                          child: TextFormField(
                            controller: nationalite,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Champ obligatoire*";
                              }
                            },
                            decoration: formDecoration(
                              "Nationalite : ",
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: EdgeInsets.all(8.0),
                          width: textFieldWidth,
                          child: TextFormField(
                            controller: lieu_activite,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Champ obligatoire*";
                              }
                            },
                            decoration: formDecoration("Lieu d'activité: ",
                                last: currClienttData.lieu_activite),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (clientFormKey.currentState!.validate()) {
                    ClientModel clientModel = ClientModel(
                        id: currClienttData.id,
                        nom: nom.text,
                        prenom: prenom.text,
                        contact: contact.text,
                        quartier: quartier.text,
                        lieu_activite: lieu_activite.text,
                        profession: profession.text,
                      nationalite: nationalite.text
                    );
                    ClientModel.modifierClient(clientModel, context);
                    nom.clear();
                    prenom.clear();
                    adresse.clear();
                    contact.clear();
                    lieu_activite.clear();
                    nationalite.clear();
                    profession.clear();
                  }
                },
                child: Text("Enregistrer"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text("Annuler"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  Future<void> deleteClient(ClientModel currClientData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(Icons.warning_rounded,color: Colors.red,),
          content: Container(
              height: 100,
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Etes vous sûr de vouloir supprimer le Client", style: TextStyle(
                      fontSize: 26, fontFamily: globalTextFont)),
                  Text("${currClientData.id}"),
                  Text("${currClientData.nom} ${currClientData.prenom}"),
                ],
              )
          ),
          actions: [
            Container(
              margin: EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () async {
                  final result = await ClientModel.deleteClient(currClientData.id!, context);
                  if(result == false){
                    reloadPage(context);
                  }
                  else{
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                          title: Text("Attention"),
                        content:  Container(
                        height: 150,
                        child: Column(
                            children :[
                              Text("Impossible de supprimer le client cotisations en cours",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w800),),
                              Text("Veillez cloturer d'abord les cotisations en cours!",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w800)
                              )]),
                      )
                      );
                    });
                  }

                },
                child: Text("Oui S'upprimer"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text("Non! Annuler"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
