import 'package:flutter/material.dart';
import 'package:ggc_desktop/API/api_service.dart';
import 'package:ggc_desktop/API/config.dart';
import 'package:ggc_desktop/API/encryption.dart';
import 'package:ggc_desktop/Models/agent_model.dart';
import 'package:ggc_desktop/Models/tontine_model.dart';
import 'package:ggc_desktop/agent/BodyAgent.dart';
import '../Models/cotisation_model.dart';
import '../desktop_body.dart';
import '../theme.dart';

class ListAgent extends StatefulWidget {
  ListAgent({Key? key}) : super(key: key);

  @override
  _ListAgentState createState() => _ListAgentState();
}

class _ListAgentState extends State<ListAgent> {
  ScrollController _scrollController = ScrollController();

  var _data;
  var _dataCotisations;
  var _dataMises;
  double textFieldWidth = 200;
  late List<AgentModel> agentList = [];
  late List<AgentModel> _filterAgentList = [];
  late List<CotisationModel> cotisations = [];
  late List<CotisationModel> filteredCotisations = [];
  late List<TontineModel> mises = [];
  List<DataRow> _agentRow = [];
  final agentFormKey = GlobalKey<FormState>();
  final nom = TextEditingController();
  final prenom = TextEditingController();
  final adresse = TextEditingController();
  final telephone = TextEditingController();
  final zoneA = TextEditingController();
  final mdp = TextEditingController();
  bool mListColor = false;
  bool eListColor = false;
  String nomAgent = "";
  double totalMontant = 0.0;



  @override
  void initState() {
    _data = MongoDatabase.getCollectionData(Config.agent_collection);
    _dataCotisations =
        MongoDatabase.getCollectionData(Config.cotisation_collection);
    _dataMises = MongoDatabase.getCollectionData(Config.tontine_collection)
        .then((value) {
      mises.clear();
      for (int i = 0; i < value.length; i++) {
        mises.add(TontineModel.fromJson(value[i]));
      }
    });
    super.initState();
  }

  // recheache agent par nom
  void searchFilter(String search) {
    List<AgentModel> results = [];
    if (search.isEmpty) {
      results = agentList;
    } else {
      results = agentList
          .where(
              (agent) => agent.nom.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    setState(() {
      _filterAgentList.clear();
      _filterAgentList = results;
    });
  }

  // Calcule du taux à prelever de chaque agent sur les cotisations
  double calculTauxPrelever(CotisationModel cotisation) {
    TontineModel tontine = getTontine(cotisation.id_mise);
    double resultat = 0;
    if (cotisation.solde > 0) {
      double taux = tontine.montantPrelever * cotisation.pages.length;
      resultat = taux + tontine.montantParMise;
    }
    return resultat;
  }

  // Filtrage de cotisation par id de l'agent
  void searchFilterCot(String search) {
    print(search);
    totalMontant = 0.0;
    List<CotisationModel> results = [];
    results = cotisations;
    results = cotisations
        .where((cotisation) => cotisation.id_agent == search)
        .toList();
    setState(() {
      filteredCotisations.clear();
      filteredCotisations = results;
      for (int i = 0; i < filteredCotisations.length; i++) {
        print(filteredCotisations[i].solde);
        totalMontant += calculTauxPrelever(filteredCotisations[i]);
      }
    });
  }

  // Filtrage de Tontine par id
  TontineModel getTontine(String search) {
    late TontineModel filteredMises;
    List<TontineModel> results = [];
    results = mises;
    results = mises.where((mise) => mise.id == search).toList();

    filteredMises = results[0];
    return filteredMises;
  }

  //Rechargement de la page
  reloadPage(context) {
    setState(() {
      _data = MongoDatabase.getCollectionData(Config.agent_collection);
      _dataCotisations =
          MongoDatabase.getCollectionData(Config.cotisation_collection);
      _dataMises = MongoDatabase.getCollectionData(Config.tontine_collection)
          .then((value) {
        mises.clear();
        for (int i = 0; i < value.length; i++) {
          mises.add(TontineModel.fromJson(value[i]));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClientParAgent(),
        Expanded(
          flex: 15,
          child: Scrollbar(
            thumbVisibility: true, //always show scrollbar
            thickness: 10, //width of scrollbar
            radius: Radius.circular(20), //corner radius of scrollbar
            scrollbarOrientation: ScrollbarOrientation.bottom,
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
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
                      agentList.clear();
                      _agentRow.clear();
                      for (int i = 0; i < snapshot.data.length; i++) {
                        agentList.add(AgentModel.fromJson(snapshot.data[i]));
                      }
                      if (_filterAgentList.isEmpty) _filterAgentList = agentList;

                      nombreAgent = agentList.length;
                      for (int i = 0; i < _filterAgentList.length; i++) {
                        DataRow aRow = DataRow(
                          onSelectChanged: (value) {
                            setState(() {
                              nomAgent = _filterAgentList[i].nom;
                              searchFilterCot(_filterAgentList[i].id);
                            });
                          },
                          color: MaterialStateColor.resolveWith((states) {
                            //total = data[i]['nb_nuit'] * data[i]['cout']*1.0;
                            return const Color.fromRGBO(
                                213, 214, 2, 223); //make tha magic!
                          }),
                          cells: [
                            DataCell(Text("${i + 1}")),
                            DataCell(Text("${_filterAgentList[i].nom}")),
                            DataCell(Text("${_filterAgentList[i].prenom}")),
                            DataCell(Text("${_filterAgentList[i].adresse}")),
                            DataCell(
                                Text("${_filterAgentList[i].zoneAffectation}")),
                            DataCell(Text("${_filterAgentList[i].telephone}")),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    ModifierAgent(_filterAgentList[i])
                                        .then((value) {
                                      setState(() {
                                        _data = MongoDatabase.getCollectionData(
                                            Config.agent_collection);
                                      });
                                    });
                                    ;
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteAgent(_filterAgentList[i]);
                                  },
                                  icon: Icon(Icons.delete),
                                )
                              ],
                            ))
                          ],
                        );
                        _agentRow.add(aRow);
                      }
                      return Container(
                        //width: MediaQuery.of(context).size.width ,
                        margin: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              width: 500,
                              margin: EdgeInsets.all(8.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    height: 45,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: TextField(
                                      onChanged: (value) {
                                        searchFilter(value);
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Recherche ...",
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _data = MongoDatabase.getCollectionData(
                                              Config.agent_collection);
                                        });
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
                                    MediaQuery.of(context).size.width * 0.05,
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      "",
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
                                      "Adresse",
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
                                      "Telephone",
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
                                rows: _agentRow),
                          ],
                        ),
                      );
                    }
                    return Center(
                      child: Text("No data"),
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget ViewClient(CotisationModel cotisation) {
    return GestureDetector(
      onTap: () {
        setState(() {});
      },
      child: Container(
        height: 40,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: mListColor ? Colors.black12 : Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: Text(
                  "${cotisation.id_client} : ${getTontine(cotisation.id_mise).typeTontine}",
                  style: TextStyle(fontFamily: globalTextFont, fontSize: 18),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Text(
                    "${cotisation.solde} F",
                    style: TextStyle(fontFamily: globalTextFont, fontSize: 18),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Text(
                    "${calculTauxPrelever(cotisation)} F",
                    style: TextStyle(fontFamily: globalTextFont, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ClientParAgent() {
    return Expanded(
      flex: 8,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Client par Agent : ${nomAgent}",
                style: TextStyle(
                    fontSize: 26,
                    fontFamily: globalTextFont,
                    fontWeight: FontWeight.w700)),
          ),
          /*Container(
            padding: EdgeInsets.all(8.0),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextField(
              onChanged: (value) {
                searchFilterCot(value);
              },
              decoration: InputDecoration(
                label: Text(""),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),*/
          Container(
            height: 50,
            width: 650,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.grey,
                      child: Center(
                          child: Text("Identifiant Clients",
                              style: TextStyle(fontSize: 18)))),
                ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.grey,
                      child: Center(
                          child:
                              Text("Solde", style: TextStyle(fontSize: 18)))),
                ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.blue,
                      child: Center(
                          child: Text(
                        "Taux à prelever",
                        style: TextStyle(fontSize: 18),
                      ))),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(2),
            color: Colors.white,
            width: 650,
            child: FutureBuilder(
                future: _dataCotisations,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      cotisations.clear();
                      for (int i = 0; i < snapshot.data.length; i++) {
                        cotisations
                            .add(CotisationModel.fromJson(snapshot.data[i]));
                      }
                      return ListView(
                        children: [
                          Container(
                              height: 50,
                              child: Center(
                                  child: Text(
                                "Gains par agent: ${totalMontant} Fcfa",
                                style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w800),
                              ))),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.56,
                            child: ListView.builder(
                              itemCount: filteredCotisations.length,
                              itemBuilder: (context, index) {
                                mListColor = !mListColor;
                                return ViewClient(filteredCotisations[index]);
                              },
                            ),
                          ),
                        ],
                      );
                    } else
                      return Text("no Data Found");
                  }
                }),
          ),
        ],
      ),
    );
  }

  Future<void> ModifierAgent(AgentModel currAgentData) async {
    nom.text = currAgentData.nom;
    prenom.text = currAgentData.prenom;
    adresse.text = currAgentData.adresse;
    mdp.text = Encryption.DecryptPassword(currAgentData.mdp);
    telephone.text = currAgentData.telephone;
    zoneA.text = currAgentData.zoneAffectation;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 400,
            width: 500,
            child: Form(
              key: agentFormKey,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("MODIFIER L'AGENT",
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
                                last: currAgentData.nom),
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
                                last: currAgentData.prenom),
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
                            controller: adresse,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Champ obligatoire*";
                              }
                            },
                            decoration: formDecoration("Adresse : ",
                                last: currAgentData.adresse),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8.0),
                          width: textFieldWidth,
                          child: TextFormField(
                            controller: zoneA,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Champ obligatoire*";
                              }
                            },
                            decoration: formDecoration("Zone affetée : ",
                                last: currAgentData.zoneAffectation),
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
                            controller: telephone,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Champ obligatoire*";
                              }
                            },
                            decoration: formDecoration("Téléphone : ",
                                last: currAgentData.telephone),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8.0),
                          width: textFieldWidth,
                          child: TextFormField(
                            controller: mdp,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Champ obligatoire*";
                              }
                            },
                            decoration: formDecoration(
                              "Mot de passe : ",
                            ),
                          ),
                        )
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
                  if (agentFormKey.currentState!.validate()) {
                    AgentModel userModel = AgentModel(
                        id: currAgentData.id,
                        nom: nom.text,
                        prenom: prenom.text,
                        telephone: telephone.text,
                        adresse: adresse.text,
                        zoneAffectation: zoneA.text,
                        mdp: mdp.text);
                    AgentModel.modifierAgent(userModel, context);
                  }
                  nom.clear();
                  prenom.clear();
                  adresse.clear();
                  telephone.clear();
                  zoneA.clear();
                  mdp.clear();
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

  // Supression agent
  Future<void> deleteAgent(AgentModel currAgentData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Attention !"),
          content: Container(
              height: 100,
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Etes vous sûr de vouloir supprimer l'agent",
                      style:
                          TextStyle(fontSize: 26, fontFamily: globalTextFont)),
                  Text("${currAgentData.id}"),
                  Text("${currAgentData.nom} ${currAgentData.prenom}"),
                ],
              )),
          actions: [
            Container(
              margin: EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  AgentModel.deleteAgent(currAgentData.id!, context);
                  reloadPage(context);
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
