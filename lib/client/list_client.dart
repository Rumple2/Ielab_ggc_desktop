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
  ScrollController _scrollController = ScrollController();
bool loading = false;
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
  var _data;
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
  reloadPage() {
      setState(() {
        _data =_data = MongoDatabase.getCollectionData(Config.client_collection);
      });
  }

  @override
  void initState() {
    _data = MongoDatabase.getCollectionData(Config.client_collection);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scrollbar(
        thumbVisibility: true, //always show scrollbar
        thickness: 10, //width of scrollbar
        radius: Radius.circular(20), //corner radius of scrollbar
        scrollbarOrientation: ScrollbarOrientation.bottom,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child:
              FutureBuilder(
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
                                  onPressed: () async {
                                   bool result = await deleteClient(_filterClient[i]);
                                   print(result);
                                   if(result == true){
                                     setState(() {
                                       _data = MongoDatabase.getCollectionData(Config.client_collection);
                                     });
                                   }
                                  },
                                  icon: Icon(Icons.delete),
                                )
                              ],
                            ))
                          ],
                        );
                        _clientRow.add(aRow);
                      }
                      return Column(
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
                                        setState(() {
                                          _data = MongoDatabase.getCollectionData(Config.client_collection);

                                        });
                                      },
                                      icon: Icon(Icons.refresh))
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.65,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                children: [
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
                                            "Profession",
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
                            ),
                          ],
                      );
                    }
                    return Center(
                      child: Text("No data"),
                    );
                  }),

        ),
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
                            decoration: formDecoration("Quartier : ",
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
                              "Nationalité : ",
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
                      nationalite: nationalite.text,
                      id_agent: currClienttData.id_agent
                    );
                    ClientModel.modifierClient(clientModel, context).then((value) => reloadPage());
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

  Future<bool> deleteClient(ClientModel currClientData) async {
    late bool isDeleted;
      showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState){
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
                      if(loading == false){
                        setState(() {
                          loading = true;
                        });
                        final result = await ClientModel.verificationStatutClient(currClientData.id, context).whenComplete((){
                          setState(() {
                            loading = false;
                          });
                        });
                        if(result == false){
                          setState(() {
                            isDeleted = true;
                            loading = false;
                            _data = MongoDatabase.getCollectionData(Config.client_collection);
                          });
                          Navigator.of(context, rootNavigator: true).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Client Supprimé"),
                            backgroundColor: Colors.green,
                          ));

                        }else {
                          setState(() {
                            loading = false;
                            isDeleted = false;
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: Text("Attention"),
                                    content: Container(
                                      height: 150,
                                      child: Column(children: const [
                                        Text(
                                          "Impossible de supprimer le client, cotisations en cours",
                                          style:
                                          TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                                        ),
                                        Text("Veillez cloturer d'abord les cotisations en cours!",
                                            style: TextStyle(
                                                fontSize: 24, fontWeight: FontWeight.w800))
                                      ]),
                                    ));
                              });
                        }
                      }
                    },
                    child: loading?CircularProgressIndicator(color: Colors.white,): Text("Oui S'upprimer"),
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
      },
    );
    return isDeleted;

  }
}
