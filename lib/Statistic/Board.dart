import 'package:flutter/material.dart';
import 'package:ggc_desktop/API/api_service.dart';
import 'package:ggc_desktop/API/config.dart';
import 'package:ggc_desktop/Models/cotisation_model.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../Models/tontine_model.dart';
import '../theme.dart';

class GlobalBoard extends StatefulWidget {
  const GlobalBoard({Key? key}) : super(key: key);

  @override
  State<GlobalBoard> createState() => _GlobalBoardState();
}

class _GlobalBoardState extends State<GlobalBoard> {
  ScrollController _scrollController = ScrollController();
  late final _dataCotisation;
  late final _agentLength;
  late final _clientLength;
  late final _tontineLength;
  var _dataTontines;
  double soldeTotal = 0.0;
  double totalGains = 0.0;
  List<TontineModel> tontines = [];
  List<CotisationModel> cotisations = [];

  void initState() {
    _agentLength = MongoDatabase.getCollectionData(Config.agent_collection);
    _tontineLength = MongoDatabase.getCollectionData(Config.tontine_collection);
    _clientLength = MongoDatabase.getCollectionData(Config.client_collection);
    _dataCotisation =
        MongoDatabase.getCollectionData(Config.cotisation_collection);
    _dataTontines = MongoDatabase.getCollectionData(Config.tontine_collection)
        .then((value) {
      tontines.clear();
      for (int i = 0; i < value.length; i++) {
        tontines.add(TontineModel.fromJson(value[i]));
      }
    });
    super.initState();
  }

  TontineModel getMise(String search) {
    TontineModel filteredMises;
    List<TontineModel> results = [];
    results = tontines;
    results = tontines.where((mise) => mise.id == search).toList();
    filteredMises = results.first;
    return filteredMises;
  }

  double calculGainTotal(CotisationModel cotisation) {
    TontineModel tontine = getMise(cotisation.id_mise);
    double resultat = 0;
    if (cotisation.solde > 0) {
      double taux = tontine.montantPrelever * cotisation.pages.length;
      resultat = taux + tontine.montantParMise;
    }
    return resultat;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Center(
        child: Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      //always show scrollbar
      thickness: 10,
      //width of scrollbar
      radius: Radius.circular(20),
      //corner radius of scrollbar
      scrollbarOrientation: ScrollbarOrientation.bottom,
      interactive: true,
        child: ListView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(
              width: 100,
            ),
            FutureBuilder(
              future: _clientLength,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: SleekCircularSlider(
                      initialValue: snapshot.data.length.toDouble(),
                      max: snapshot.data.length.toDouble()==0.0?10 : snapshot.data.length.toDouble() * 2,
                      appearance: CircularSliderAppearance(
                          customWidths: CustomSliderWidths(
                              trackWidth: 10,
                              handlerSize: 5,
                              progressBarWidth: 15),
                          animationEnabled: true,
                          size: screenSize.width * 0.13,
                          infoProperties: InfoProperties(
                              mainLabelStyle: TextStyle(fontSize: 18),
                              topLabelText: "Clients",
                              topLabelStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              modifier: (value) {
                                return nombreModifier(value);
                              })),
                    ),
                  );
                }
                return SleekCircularSlider(
                  min: 0,
                  max: double.maxFinite,
                  appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(trackWidth: 20),
                      animationEnabled: true,
                      size: screenSize.width * 0.13,
                      infoProperties: InfoProperties(
                          topLabelText: "Clients",
                          topLabelStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          modifier: (value) {
                            return nombreModifier(value);
                          })),
                );
              },
            ),
            SizedBox(
              width: 20,
            ),
            FutureBuilder(
              future: _agentLength,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: SleekCircularSlider(
                      initialValue: snapshot.data.length.toDouble(),
                      max: snapshot.data.length.toDouble()==0.0? 10 : snapshot.data.length.toDouble() * 2,
                      appearance: CircularSliderAppearance(
                          customWidths: CustomSliderWidths(
                              trackWidth: 10,
                              handlerSize: 5,
                              progressBarWidth: 15),
                          animationEnabled: true,
                          size: screenSize.width * 0.13,
                          infoProperties: InfoProperties(
                              mainLabelStyle: TextStyle(fontSize: 18),
                              topLabelText: "Agents",
                              topLabelStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              modifier: (value) {
                                return nombreModifier(value);
                              })),
                    ),
                  );
                }
                return SleekCircularSlider(
                  min: 0,
                  max: double.maxFinite,
                  appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(trackWidth: 20),
                      animationEnabled: true,
                      size: screenSize.width * 0.13,
                      infoProperties: InfoProperties(
                          topLabelText: "Agents",
                          topLabelStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          modifier: (value) {
                            return nombreModifier(value);
                          })),
                );
              },
            ),
            SizedBox(
              width: 20,
            ),
            FutureBuilder(
              future: _tontineLength,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: SleekCircularSlider(
                      initialValue: snapshot.data.length.toDouble(),
                      max:snapshot.data.length.toDouble()==0.0? 10 : snapshot.data.length.toDouble() * 2,
                      appearance: CircularSliderAppearance(
                          customWidths: CustomSliderWidths(
                              trackWidth: 10,
                              handlerSize: 5,
                              progressBarWidth: 15),
                          animationEnabled: true,
                          size: screenSize.width * 0.13,
                          infoProperties: InfoProperties(
                              mainLabelStyle: TextStyle(fontSize: 18),
                              topLabelText: "Tontines",
                              topLabelStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              modifier: (value) {
                                return nombreModifier(value);
                              })),
                    ),
                  );
                }
                return SleekCircularSlider(
                  min: 0,
                  max: double.maxFinite,
                  appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(trackWidth: 20),
                      animationEnabled: true,
                      size: screenSize.width * 0.13,
                      infoProperties: InfoProperties(
                          topLabelText: "Tontines",
                          topLabelStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          modifier: (value) {
                            return nombreModifier(value);
                          })),
                );
              },
            ),
            SizedBox(
              width: 20,
            ),
            FutureBuilder(
              future: _dataCotisation,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: SleekCircularSlider(
                      initialValue: snapshot.data.length.toDouble(),
                      max: snapshot.data.length.toDouble()==0.0? 10 :snapshot.data.length.toDouble() * 2,
                      appearance: CircularSliderAppearance(
                          customWidths: CustomSliderWidths(
                              trackWidth: 10,
                              handlerSize: 5,
                              progressBarWidth: 15),
                          animationEnabled: true,
                          size: screenSize.width * 0.13,
                          infoProperties: InfoProperties(
                              mainLabelStyle: TextStyle(fontSize: 18),
                              topLabelText: "Cotisations en cours",
                              topLabelStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              modifier: (value) {
                                return nombreModifier(value);
                              })),
                    ),
                  );
                }
                return SleekCircularSlider(
                  min: 0,
                  max: double.maxFinite,
                  appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(trackWidth: 20),
                      animationEnabled: true,
                      size: screenSize.width * 0.13,
                      infoProperties: InfoProperties(
                          topLabelText: "Cotisations en cours",
                          topLabelStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          modifier: (value) {
                            return nombreModifier(value);
                          })),
                );
              },
            ),
            SizedBox(
              width: 20,
            ),
            FutureBuilder(
              future: _dataCotisation,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  cotisations.clear();
                  soldeTotal = 0.0;
                  for (int i = 0; i < snapshot.data.length; i++) {
                    cotisations.add(CotisationModel.fromJson(snapshot.data[i]));
                    soldeTotal += cotisations[i].solde;
                  }
                  totalGains = 0.0;
                  for (int i = 0; i < cotisations.length; i++) {
                    totalGains += calculGainTotal(cotisations[i]);
                  }
                  return Center(
                    child: SleekCircularSlider(
                      initialValue: soldeTotal,
                      max: soldeTotal==0?10:soldeTotal * 2,
                      appearance: CircularSliderAppearance(
                          customWidths: CustomSliderWidths(
                              trackWidth: 10,
                              handlerSize: 5,
                              progressBarWidth: 15),
                          animationEnabled: true,
                          size: screenSize.width * 0.13,
                          infoProperties: InfoProperties(
                              mainLabelStyle: TextStyle(fontSize: 18),
                              topLabelText: "Solde total",
                              topLabelStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              modifier: (value) {
                                return sleekExtMoney(value);
                              })),
                    ),
                  );
                }
                return SleekCircularSlider(
                  min: 0,
                  max: double.maxFinite,
                  appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(trackWidth: 20),
                      animationEnabled: true,
                      size: screenSize.width * 0.13,
                      infoProperties: InfoProperties(
                          topLabelText: "Solde total",
                          topLabelStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          modifier: (value) {
                            return sleekExtMoney(value);
                          })),
                );
              },
            ),
            SizedBox(
              width: 20,
            ),
            FutureBuilder(
              future: _dataCotisation,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  print("hbdjf : "+totalGains.toString());
                  return Center(
                    child: SleekCircularSlider(
                      initialValue: totalGains,
                      max: totalGains == 0.0? 10 : totalGains * 2,
                      appearance: CircularSliderAppearance(
                          customWidths: CustomSliderWidths(
                              trackWidth: 10,
                              handlerSize: 5,
                              progressBarWidth: 15),
                          animationEnabled: true,
                          size: screenSize.width * 0.13,
                          infoProperties: InfoProperties(
                              mainLabelStyle: TextStyle(fontSize: 18),
                              topLabelText: "Gains total",
                              topLabelStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              modifier: (value) {
                                return sleekExtMoney(value);
                              })),
                    ),
                  );
                }
                return SleekCircularSlider(
                  min: 0,
                  max: 10,
                  appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(trackWidth: 20),
                      animationEnabled: true,
                      size: screenSize.width * 0.13,
                      infoProperties: InfoProperties(
                          topLabelText: "Gains total",
                          topLabelStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          modifier: (value) {
                            return sleekExtMoney(value);
                          })),
                );
              },
            ),
          ],
        ),

    ));
  }
}
