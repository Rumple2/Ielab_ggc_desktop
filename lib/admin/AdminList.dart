import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggc_desktop/API/api_service.dart';
import 'package:ggc_desktop/API/config.dart';
import 'package:ggc_desktop/admin/AdminBody.dart';

import '../API/encryption.dart';
import '../Models/AdminModel.dart';
import '../Models/agent_model.dart';
import '../theme.dart';

class AdminList extends StatefulWidget {
  const AdminList({Key? key}) : super(key: key);

  @override
  State<AdminList> createState() => _AdminListState();
}

class _AdminListState extends State<AdminList> {
  ScrollController _scrollController = ScrollController();

  double textFieldWidth = 200;
  late List<AdminModel> adminList = [];
  late List<AdminModel> _filterAdminList = [];
  List<DataRow> _adminRow = [];
  final adminFormKey = GlobalKey<FormState>();
  final nom = TextEditingController();
  final telephone = TextEditingController();
  final mdp = TextEditingController();
  var _data;
  void searchFilter(String search) {
    List<AdminModel> results = [];
    if (search.isEmpty) {
      results = adminList;
    } else {
      results = adminList
          .where((admin) =>
          admin.nom.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    setState(() {
      _filterAdminList.clear();
      _filterAdminList = results;
    });
  }
  void initState(){
    _data = MongoDatabase.getCollectionData(Config.admin_collection);
    super.initState();
  }
  reloadPage(){
    setState(() {
      _data = MongoDatabase.getCollectionData(Config.admin_collection);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scrollbar(
        thumbVisibility: true,//always show scrollbar
        trackVisibility: true,
        thickness: 10, //width of scrollbar
        radius: Radius.circular(20), //corn// er radius of scrollbar
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
                      adminList.clear();
                      _adminRow.clear();
                      for (int i = 0; i < snapshot.data.length; i++) {
                        adminList.add(AdminModel.fromJson(snapshot.data[i]));
                      }
                      if (_filterAdminList.isEmpty) _filterAdminList = adminList;

                      for (int i = 0; i < _filterAdminList.length; i++) {
                        DataRow aRow = DataRow(
                          color: MaterialStateColor.resolveWith((states) {
                            //total = data[i]['nb_nuit'] * data[i]['cout']*1.0;
                            return const Color.fromRGBO(
                                213, 214, 2, 223); //make tha magic!
                          }),
                          cells: [
                            DataCell(Text("${i + 1}")),
                            DataCell(Text("${_filterAdminList[i].nom}")),
                            DataCell(Text("${_filterAdminList[i].telephone}")),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    ModifierAgent(_filterAdminList[i]);
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteAdmin(_filterAdminList[i]);
                                  },
                                  icon: Icon(Icons.delete),
                                )
                              ],
                            ))
                          ],
                        );
                        _adminRow.add(aRow);
                      }
                      return Container(
                        height: 500,
                        width:MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.all(8.0),
                        child: ListView(
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
                                      decoration: InputDecoration(
                                          labelText: "Recherche ...",
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        reloadPage();
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
                                rows: _adminRow),
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

    );
  }
  Future<void> ModifierAgent(AdminModel currAdminData) async {
    nom.text = currAdminData.nom;
    mdp.text = Encryption.DecryptPassword(currAdminData.mdp);
    telephone.text = currAdminData.telephone;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 400,
            width: 500,
            child: Form(
              key: adminFormKey,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("MODIFIER L'ADMIN",
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
                                last: currAdminData.nom),
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
                                last: currAdminData.telephone),
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
                  if (adminFormKey.currentState!.validate()) {
                    Navigator.of(context, rootNavigator: true).pop();
                    AdminModel adminModel = AdminModel(
                        id: currAdminData.id,
                        nom: nom.text,
                        telephone: telephone.text,
                        mdp: mdp.text);
                    AdminModel.modifierAdmin(adminModel, context).then((value) => reloadPage());
                  }
                  nom.clear();
                  telephone.clear();
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

  Future<void> deleteAdmin(AdminModel currAdminData) async {
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
                  Text("Etes vous sûr de vouloir supprimer l'admin",
                      style:
                      TextStyle(fontSize: 26, fontFamily: globalTextFont)),
                  Text("id : ${currAdminData.id}"),
                  Text("Nom: ${currAdminData.nom}"),
                  Text("Telephone : ${currAdminData.telephone}"),
                ],
              )),
          actions: [
            Container(
              margin: EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  AdminModel.deleteAdmin(currAdminData.id, context).then((value) => reloadPage());
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
}
