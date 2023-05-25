import 'package:ggc_desktop/API/config.dart';
import 'package:ggc_desktop/Models/achatTrans_model.dart';
import 'package:ggc_desktop/Models/cotisation_model.dart';
import 'package:ggc_desktop/client/achat_trans.dart';
import 'package:intl/intl.dart';
import '../Models/client_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../API/api_service.dart';
import '../../theme.dart';
import '../Models/tontine_model.dart';

class CotisationBoard extends StatefulWidget {
  const CotisationBoard({Key? key}) : super(key: key);

  @override
  State<CotisationBoard> createState() => _CotisationBoardState();
}

class _CotisationBoardState extends State<CotisationBoard> {

  double textFieldWidth = 400;
  bool loading = false;
  final miseFormKey = GlobalKey<FormState>();
  final retraitFormKey = GlobalKey<FormState>();

  bool mListColor = false;
  bool eListColor = false;
  String currMiseId = "";
  TontineModel currTontineModel = TontineModel();
  List onePage = [];
  List datesPage = [];
  int numPage = 0;
  int sizePage = 0;
  var _data;
  CotisationModel cotisationModel = CotisationModel();
  ClientModel clModel = ClientModel();
  List<TontineModel> tontineList = [];
  List<TontineModel> _filteredTontineList = [];

  // var clientCotDate = [];
  //double soldeClient = 0.0;
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

  //Filtrage de la liste de tontine par le type de tontine
  void searchFilterTontine(String search) {
    List<TontineModel> results = [];
    if (search.isEmpty) {
      results = tontineList;
    } else {
      results = tontineList
          .where((tontine) =>
              tontine.typeTontine.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredTontineList.clear();
      _filteredTontineList = results;
    });
  }

  void initState() {
    _data = MongoDatabase.getCollectionData(Config.tontine_collection);
    super.initState();
  }

  reloadPage() {
    setState(() {
      _data = MongoDatabase.getCollectionData(Config.tontine_collection);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // currentPage = const MiseBoard();
                  reloadPage();
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width / 5,
                  child: TontineForm(),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Column(
                      children: [
                        TontineList(),
                        const SizedBox(
                          height: 20,
                        ),
                        MembresTontine(),
                      ],
                    )),
                SizedBox(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: 0.5,
                    color: Colors.blueGrey,
                  ),
                ),
                ClientCalendar(cotisationModel),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour afficher le calendrier de cotisation
  ClientCalendar(CotisationModel cotisationModel) {
    List pages = cotisationModel.pages;
    List dates = cotisationModel.dates_cot;
    sizePage = pages.length - 1;

    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      color: Colors.black12,
      child: Column(
        children: [
          SizedBox(
            child: Container(
              margin: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.height * 0.7,
              height: 0.5,
              color: Colors.blueGrey,
            ),
          ),
          Text(" ${clModel.id}: ${clModel.nom} ${clModel.prenom} ",
              style: TextStyle(fontSize: 24, fontFamily: globalTextFont)),
          SizedBox(
            child: Container(
              margin: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.height * 0.7,
              height: 0.5,
              color: Colors.blueGrey,
            ),
          ),
          Container(
            color: Colors.black12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Calendrier"),
                Container(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          color: Colors.red,
                          onPressed: () {
                            if (numPage > 0) {
                              setState(() {
                                numPage--;
                                onePage = pages.elementAt(numPage);
                                datesPage = dates.elementAt(numPage);
                              });
                            }
                          },
                          icon: Icon(Icons.arrow_back_ios_new_sharp)),
                      SizedBox(
                        width: 50,
                      ),
                      Text("Pages ${numPage + 1} sur ${sizePage + 1}"),
                      SizedBox(
                        width: 50,
                      ),
                      IconButton(
                          color: Colors.red,
                          onPressed: () {
                            if (numPage < sizePage) {
                              setState(() {
                                numPage++;
                                onePage = pages.elementAt(numPage);
                                datesPage = dates.elementAt(numPage);
                              });
                            }
                          },
                          icon: Icon(Icons.arrow_forward_ios_sharp))
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: GridView.builder(
                        itemCount: 31,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7),
                        itemBuilder: (context, index) {
                          int caseC = index + 1;
                          String date = "";
                          bool color = false;
                          if (onePage.isNotEmpty && index < onePage.length) {
                            if (onePage.elementAt(index) == 1) {
                              color = true;
                              Intl.defaultLocale = "en_US";
                              date = DateFormat.yMMMd()
                                  .format(datesPage.elementAt(index))
                                  .toString();
                            }
                          }
                          return Container(
                            margin: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: color ? Colors.green : Colors.white),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    caseC.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                  Text("$date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                          );
                        }))
              ],
            ),
          ),
          SizedBox(
            child: Container(
              margin: EdgeInsets.all(8.0),
              //width: MediaQuery.of(context).size.height * 0.7,
              height: 0.5,
              color: Colors.blueGrey,
            ),
          ),
          Text("SOLDE DU CLIENT : ${cotisationModel.solde} Fcfa",
              style: TextStyle(fontSize: 24, fontFamily: globalTextFont)),
          SizedBox(
            child: Container(
              margin: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.height * 0.7,
              height: 0.5,
              color: Colors.blueGrey,
            ),
          ),
              Container(
                margin: EdgeInsets.all(8.0),
                height: 50,
                width: MediaQuery.of(context).size.width * 0.3,
                child: ElevatedButton(
                  onPressed: () {
                    Retrait(cotisationModel);
                  },
                  child: Text("Retrait ${cotisationModel.id_client} "),
                  style: ElevatedButton.styleFrom(minimumSize: Size(100, 50)),
                ),
              ),
          Container(
            margin: EdgeInsets.all(8.0),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.3,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ClientAchatTrans()));
              },
              child: Text("Achats et transactions "),
              style: ElevatedButton.styleFrom(minimumSize: Size(100, 50)),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.3,
            child: ElevatedButton(
              onPressed: () {
                if (cotisationModel != CotisationModel() &&
                    clModel != ClientModel() &&
                    currTontineModel != TontineModel()) {
                  finCotisationClient(cotisationModel, clModel, currTontineModel);
                }
              },
              child: Text("Fin de cotisation ${currTontineModel.typeTontine} "),
              style: ElevatedButton.styleFrom(minimumSize: Size(100, 50)),
            ),
          ),
        ],
      ),
    );
  }

  TontineForm() {
    TontineModel miseModel = TontineModel();
    final typeTontine = TextEditingController();
    final montantTontine = TextEditingController();
    final montantMiseTontine = TextEditingController();
    final montantPreleverTontine = TextEditingController();

    return Form(
      key: miseFormKey,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blue, width: 1)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Enregistrer un type de tontine",
                  style: TextStyle(fontSize: 26, fontFamily: globalTextFont)),
            ),
            TextFormField(
              controller: typeTontine,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Champ obligatoire*";
                }
              },
              decoration: formDecoration(
                "Nom de la tontine : ",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: montantTontine,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Champ obligatoire*";
                }
              },
              decoration: formDecoration("Montant de la tontine : "),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: montantMiseTontine,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Champ obligatoire*";
                }
              },
              decoration: formDecoration("Montant à misé / J : "),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: montantPreleverTontine,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Champ obligatoire*";
                }
              },
              decoration: formDecoration("Gains à préléver / mois : "),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if(loading ==false){
                  if (miseFormKey.currentState!.validate()) {
                    miseModel.typeTontine = typeTontine.text;
                    miseModel.montantPrelever =
                        double.parse(montantPreleverTontine.text);
                    miseModel.montantTontine = double.parse(montantTontine.text);
                    miseModel.montantParMise =
                        double.parse(montantMiseTontine.text);
                    setState(() {
                      loading = true;
                    });
                    TontineModel.insertMise(miseModel, context).whenComplete((){
                      setState(() {
                        _data = MongoDatabase.getCollectionData(
                            Config.tontine_collection);
                        typeTontine.clear();
                        montantMiseTontine.clear();
                        montantTontine.clear();
                        montantPreleverTontine.clear();
                        loading = false;
                      });
                    });

                  }
                }

              },
              child: loading?CircularProgressIndicator(color: Colors.white,):Text("Ajouter"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ViewTontine(TontineModel tontineM) {
    return GestureDetector(
      onTap: () {
        setState(() {
          onePage = [];
          numPage = 0;
          sizePage = 0;
          currMiseId = tontineM.id;
          //currTontineName = tontineM.typeTontine;
          currTontineModel = tontineM;
        });
      },
      child: Container(
        margin: EdgeInsets.all(2.0),
        padding: EdgeInsets.all(2.0),
        color: eListColor ? Colors.white60 : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                highlightColor: Colors.red,
                hoverColor: Colors.red,
                onPressed: () async {
                  await TontineModel.verificationMise(tontineM.id, context);
                },
                icon: Icon(Icons.delete)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${tontineM.typeTontine}",
                  style: TextStyle(fontFamily: globalTextFont, fontSize: 18),
                ),
                Text(
                  "Montant Tontine: ${tontineM.montantTontine}",
                  style:
                      TextStyle(fontFamily: globalTextFont, color: Colors.grey),
                ),
                Text(
                  "Montant par mise: ${tontineM.montantParMise}",
                  style:
                      TextStyle(fontFamily: globalTextFont, color: Colors.grey),
                )
              ],
            ),
            SleekCircularSlider(
              min: 0,
              max: 9999999,
              initialValue: tontineM.montantTontine,
              appearance: CircularSliderAppearance(
                  animationEnabled: true,
                  size: 70,
                  customWidths: CustomSliderWidths(
                      trackWidth: 0.5, shadowWidth: 0.5, handlerSize: 0.5),
                  infoProperties: InfoProperties(
                      topLabelStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                      modifier: (value) {
                        return percentageModifier(value);
                      })),
            )
          ],
        ),
      ),
    );
  }

  TontineList() {
    return ExpansionTile(
      collapsedBackgroundColor: globalColor.withOpacity(0.3),
      collapsedIconColor: Colors.white,
      title: Row(
        children: [
          Container(
              width: 100,
              child: Text(
                "Tontines",
                style: TextStyle(
                    fontSize: 26,
                    fontFamily: globalTextFont,
                    fontWeight: FontWeight.w700),
                overflow: TextOverflow.clip,
              )),
          Container(
            padding: EdgeInsets.all(8.0),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.095,
            child: TextField(
              onChanged: (value) {
                searchFilterTontine(value);
              },
              decoration: InputDecoration(
                hintText: "Recherche ...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: StatefulBuilder(
            builder: (context, setState) {
              return FutureBuilder(
                  future: _data,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasData) {
                        tontineList.clear();
                        for (int i = 0; i < snapshot.data.length; i++) {
                          tontineList
                              .add(TontineModel.fromJson(snapshot.data[i]));
                        }
                        if (_filteredTontineList.isEmpty) {
                          _filteredTontineList = tontineList;
                        }
                        nombreMise = tontineList.length;
                        return ListView.builder(
                            itemCount: _filteredTontineList.length,
                            itemBuilder: (context, index) {
                              eListColor = !eListColor;
                              return ViewTontine(_filteredTontineList[index]);
                            });
                      } else
                        return Text(
                            "No data found ${snapshot.connectionState}");
                    }
                  });
            },
          ),
        )
      ],
    );
  }

  Widget ViewClient(ClientModel clientModel) {
    return GestureDetector(
      onTap: () {
        setState(() {
          numPage = 0;
          sizePage = 0;
          cotisationModel = clientModel.cModel;
          clModel = clientModel;
          onePage = clientModel.cModel.pages.elementAt(0);
          datesPage = clientModel.cModel.dates_cot.elementAt(0);
          sizePage = clientModel.cModel.pages.length - 1;
        });
      },
      child: Container(
        height: 40,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: mListColor ? Colors.white : Colors.white,
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


//Liste des membres adherer aux types de tontine
  MembresTontine() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Membres de la tontine : ${currTontineModel.typeTontine}",
              style: TextStyle(
                  fontSize: 26,
                  fontFamily: globalTextFont,
                  fontWeight: FontWeight.w700)),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          height: 50,
          width: MediaQuery.of(context).size.width * 0.3,
          child: TextField(
            onChanged: (value) {
              searchFilter(value);
            },
            decoration: InputDecoration(
              label: Text(currMiseId),
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: FutureBuilder(
              future: MongoDatabase.getCotisationByTontineId(currMiseId),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    List<CotisationModel> cotModelList = [];
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        mListColor = !mListColor;
                        CotisationModel cotModel =
                            CotisationModel.fromJson(snapshot.data[index]);
                        return FutureBuilder(
                            future:
                                MongoDatabase.getClientById(cotModel.id_client),
                            builder: (context, AsyncSnapshot snap) {
                              if(snap.connectionState == ConnectionState.waiting){
                                return Text("Chargement ...");
                              }
                              if (snap.data != null) {
                                allClient.clear();
                                ClientModel clientModel = snap.data;
                                clientModel.cModel = cotModel;
                                allClient.add(clientModel);
                                if (_foundClient.isEmpty)
                                  _foundClient = allClient;

                                // return ViewClient(clientModel,cotModel);
                                return ViewClient(clientModel);
                              } else
                                return Text(
                                    "Pas de client pour cette Tontine ");
                            });
                      },
                    );
                  } else
                    return Text("no Data Found");
                }
              }),
        ),
      ],
    );
  }


  //Permet de mettre fin definitivement à la cotisation d'un client
  // Il verfie d'abord si un client à une cotisation en cours ou pas avant de valider la suppression.
  Future<void> finCotisationClient(CotisationModel cotM,
      ClientModel clientModel, TontineModel tontineM) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Attention !"),
          content: Container(
              height: 200,
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                      "Etes vous sûr de vouloir mettre fin à la Tontine de :  ",
                      style:
                          TextStyle(fontSize: 26, fontFamily: globalTextFont)),
                  Text("${clientModel.id}"),
                  Text(
                      "${clientModel.nom} ${clientModel.prenom} pour la mise: ${tontineM.typeTontine}"),
                ],
              )),
          actions: [
            Container(
              margin: EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  CotisationModel.deleteCotisation(cotM, tontineM, context);
                  reloadPage();
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

  // PERMET d'effectuer un retrait à un client, son solde est directement debité
  Future<void> Retrait(CotisationModel cotisationModel) async {
    AchatTransModel achatTransModel = AchatTransModel();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState){
            return AlertDialog(
              content: Container(
                height: 300,
                width: 500,
                child: Form(
                  key: retraitFormKey,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child:  Column(
                      children: [
                        Text("Effectuer un retrait pour : ${cotisationModel.id_client}",
                            style: TextStyle(fontSize: 24, fontFamily: globalTextFont,decoration: TextDecoration.underline)),
                        Container(
                            margin: EdgeInsets.all(8.0),
                            width: textFieldWidth,
                            child: TextFormField(
                                onChanged: (value) {
                                  achatTransModel.designation = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Champ obligatoire*";
                                  }
                                },
                                decoration: formDecoration("Désignation : "))
                        ),
                        Container(
                          margin: EdgeInsets.all(8.0),
                          width: textFieldWidth,
                          child: TextFormField(
                            onChanged: (value) {
                              achatTransModel.retrait = double.parse(value);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Champ obligatoire*";
                              }
                            },
                            decoration: formDecoration("Montant : "),
                          ),)]

                ),
              ))),
              actions: [
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (retraitFormKey.currentState!.validate()) {
                        if (cotisationModel.id_client.isEmpty && clModel.id.isEmpty) {
                          AchatTransModel.retraitMontant(cotisationModel, achatTransModel,context);

                        }

                      }
                    },
                    child: Text("Retrait ${cotisationModel.id_client}"),
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
      },
    );
  }
}
