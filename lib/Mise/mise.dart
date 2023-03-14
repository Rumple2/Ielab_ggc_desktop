import 'package:ggc_desktop/API/config.dart';
import 'package:ggc_desktop/Models/cotisation_model.dart';
import 'package:ggc_desktop/client/achat_trans.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../Models/client_model.dart';
import '../desktop_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../API/api_service.dart';
import '../../theme.dart';
import '../Models/mise_model.dart';
import '../loading.dart';

class MiseBoard extends StatefulWidget {
  const MiseBoard({Key? key}) : super(key: key);

  @override
  State<MiseBoard> createState() => _MiseBoardState();
}

class _MiseBoardState extends State<MiseBoard> {
  final miseFormKey = GlobalKey<FormState>();
  bool mListColor = false;
  bool eListColor = false;
  String currMiseId = "";
  String currMiseName = "";
  List onePage = [];
  List datesPage = [];
  int numPage = 0;
  int sizePage = 0;
  late final _data;
  CotisationModel cotisationModel = CotisationModel();
  ClientModel clModel = ClientModel();
  List<MiseModel> miseList = [];

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

  void initState() {
    _data = MongoDatabase.getCollectionData(Config.mise_collection);
    super.initState();
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
                  reloadPage(context);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 5,
                  child: MiseForm(),
                ),
                SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 4,
                    child: Column(
                      children: [
                        MiseList(),
                        const SizedBox(
                          height: 20,
                        ),
                        MembresMise(),
                      ],
                    )),
                SizedBox(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.7,
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

  ClientCalendar(CotisationModel cotisationModel) {
    List pages = cotisationModel.pages;
    sizePage = pages.length - 1;

    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.4,
      color: Colors.black12,
      child: Column(
        children: [
          SizedBox(
            child: Container(
              margin: EdgeInsets.all(8.0),
              width: MediaQuery
                  .of(context)
                  .size
                  .height * 0.7,
              height: 0.5,
              color: Colors.blueGrey,
            ),
          ),
          Text(" ${clModel.id}: ${clModel.nom} ${clModel.prenom}",
              style: TextStyle(fontSize: 24, fontFamily: globalTextFont)),
          SizedBox(
            child: Container(
              margin: EdgeInsets.all(8.0),
              width: MediaQuery
                  .of(context)
                  .size
                  .height * 0.7,
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
                          onPressed: () {
                            if (numPage > 0) {
                              setState(() {
                                numPage--;
                                onePage = pages.elementAt(numPage);
                              });
                            }
                          },
                          icon: Icon(Icons.arrow_back_ios_new_sharp)),
                      SizedBox(
                        width: 50,
                      ),
                      Text("Page ${numPage + 1}"),
                      SizedBox(
                        width: 50,
                      ),
                      IconButton(
                          onPressed: () {
                            if (numPage < sizePage) {
                              setState(() {
                                numPage++;
                                onePage = pages.elementAt(1);
                              });
                            }
                          },
                          icon: Icon(Icons.arrow_forward_ios_sharp))
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.5,
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
                              print(datesPage.elementAt(index));
                              Intl.defaultLocale = "en_US";
                              date = DateFormat.yMMMd().format(
                                  datesPage.elementAt(index)).toString();
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
                                  Text(caseC.toString(), style: TextStyle(
                                      fontWeight: FontWeight.w800),),
                                  Text("$date", style: TextStyle(
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
              width: MediaQuery
                  .of(context)
                  .size
                  .height * 0.7,
              height: 0.5,
              color: Colors.blueGrey,
            ),
          ),

          Container(
            margin: EdgeInsets.all(8.0),
            height: 50,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.3,
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
            width: MediaQuery
                .of(context)
                .size
                .width * 0.3,
            child: ElevatedButton(
              onPressed: () {
                finCotisationClient(cotisationModel.id, clModel, currMiseName);
              },
              child: Text("Fin de cotisation $currMiseName "),
              style: ElevatedButton.styleFrom(minimumSize: Size(100, 50)),
            ),
          ),
        ],
      ),
    );
  }

  MiseForm() {
    MiseModel miseModel = MiseModel();
    return Form(
      key: miseFormKey,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration:
        BoxDecoration(border: Border.all(color: Colors.blue, width: 1)),
        child: Column(
            children: [
        Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Enregistrer un type de tontine",
            style: TextStyle(fontSize: 26, fontFamily: globalTextFont)),
      ),
      TextFormField(
        onChanged: (value) {
          miseModel.typeTontine = value;
        },
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
        onChanged: (value) {
          miseModel.montantTontine = double.parse(value);
        },
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
        onChanged: (value) {
          miseModel.montantParMise = double.parse(value);
        },
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
        onChanged: (value) {
          miseModel.montantParMise = double.parse(value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return "Champ obligatoire*";
          }
        },
        decoration: formDecoration("Gains à préléver / mois : "),
      ),
      SizedBox(
        height: 20,),
        ElevatedButton(
          onPressed: () {
            if (miseFormKey.currentState!.validate()) {
              MiseModel.insertMise(miseModel, context);
            }
          },
          child: Text("Ajouter"),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(200, 50),
          ),
        )
        ],
      ),
    ),);
  }

  Widget ViewMise(MiseModel miseModel) {
    return GestureDetector(
      onTap: () {
        setState(() {
          onePage = [];
          numPage = 0;
          sizePage = 0;
          currMiseId = miseModel.id;
          currMiseName = miseModel.typeTontine;
        });
      },

      child: Container(
        margin: EdgeInsets.all(2.0),
        padding: EdgeInsets.all(2.0),
        color: eListColor ? Colors.black12 : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                highlightColor: Colors.red,
                hoverColor: Colors.red,
                onPressed: () async {
                  bool result = await MiseModel.deleteMise(
                      miseModel.id, context);
                  if (result) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                        SnackBar(content: Text("Cotisation Supprimer"),
                          backgroundColor: Colors.green,
                        ));
                    reloadPage(context);
                  }
                }, icon: Icon(Icons.delete)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${miseModel.typeTontine}",
                  style: TextStyle(fontFamily: globalTextFont, fontSize: 18),
                ),
                Text(
                  "Montant Tontine: ${miseModel.montantTontine}",
                  style:
                  TextStyle(fontFamily: globalTextFont, color: Colors.grey),
                ),
                Text(
                  "Montant par mise: ${miseModel.montantParMise}",
                  style:
                  TextStyle(fontFamily: globalTextFont, color: Colors.grey),
                )
              ],
            ),
            SleekCircularSlider(
              min: 0,
              max: 9999999,
              initialValue: miseModel.montantTontine,
              appearance: CircularSliderAppearance(
                  animationEnabled: true,
                  size: 70,
                  customWidths: CustomSliderWidths(
                      trackWidth: 0.5, shadowWidth: 0.5, handlerSize: 0.5),
                  infoProperties: InfoProperties(
                      topLabelStyle:
                      const TextStyle(
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

  MiseList() {
    return ExpansionTile(
      collapsedBackgroundColor: globalColor.withOpacity(0.3),
      collapsedIconColor: Colors.white,
      title: Center(
          child: Text("Tontines Disponible",
              style: TextStyle(
                  fontSize: 26,
                  fontFamily: globalTextFont,
                  fontWeight: FontWeight.w700))),
      children: [
        Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.4,
          child: FutureBuilder(
              future: _data,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: MyLoading());
                } else {
                  if (snapshot.hasData) {
                    miseList.clear();
                    for (int i = 0; i < snapshot.data.length; i++) {

                      miseList.add(MiseModel.fromJson(snapshot.data[i]));
                    }
                    nombreMise = miseList.length;
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          eListColor = !eListColor;
                          return ViewMise(
                              MiseModel.fromJson(snapshot.data[index]));
                        });
                  } else
                    return Text("No data found ${snapshot.connectionState}");
                }
              }),
        )
      ],
    );
  }

  Widget ViewClient(ClientModel clientModel) {
    return GestureDetector(
      onTap: () {
        setState(() {
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
          color: mListColor ? Colors.black12 : Colors.white,
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

  MembresMise() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Membres de la tontine : $currMiseName",
              style: TextStyle(
                  fontSize: 26,
                  fontFamily: globalTextFont,
                  fontWeight: FontWeight.w700)),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          height: 50,
          width: MediaQuery
              .of(context)
              .size
              .width * 0.3,
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
          height: MediaQuery
              .of(context)
              .size
              .height * 0.7,
          child: FutureBuilder(
              future: MongoDatabase.getCotisationByMiseId(currMiseId),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: MyLoading());
                } else {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
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
                                    "Pas de client pour cette Cotisation ");
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

  Future<void> finCotisationClient(String idCotisation, ClientModel clientModel,
      String miseName) async {
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
                  Text("Etes vous sûr de vouloir mettre à la Tontine de :  ",
                      style: TextStyle(
                          fontSize: 26, fontFamily: globalTextFont)),
                  Text("${clientModel.id}"),
                  Text("${clientModel.nom} ${clientModel
                      .prenom} pour la mise: $miseName"),
                ],
              )
          ),
          actions: [
            Container(
              margin: EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  CotisationModel.deleteCotisation(idCotisation, context);
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
