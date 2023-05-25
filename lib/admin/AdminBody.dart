import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggc_desktop/admin/AdminList.dart';
import '../Models/AdminModel.dart';
import '../theme.dart';

class AdminBody extends StatefulWidget {
  const AdminBody({Key? key}) : super(key: key);

  @override
  State<AdminBody> createState() => _AdminBodyState();
}

class _AdminBodyState extends State<AdminBody> {
  final adminFormKey = GlobalKey<FormState>();
  final nom = TextEditingController();
  final telephone = TextEditingController();
  final mdp = TextEditingController();
  final mdpConfirm = TextEditingController();
  double textFieldWidth = 400;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: globalColor,
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex: 4,child: AdminForm(context), ),

            Expanded(flex: 3, child: AdminList())],
        ));
  }

  AdminForm(context) {
    return Form(
      key: adminFormKey,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 1.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("ENREGISTRER UN AUTRE ADMIN",
                  style: TextStyle(fontSize: 26, fontFamily: globalTextFont)),
            ),
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
                    decoration: formDecoration(
                      "Nom : ",
                    ),
                  ),
                ),
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
                    decoration: formDecoration(
                      "Téléphone : ",
                    ),
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
                      if (mdp.text != mdpConfirm.text) {
                        return "Passe different";
                      }
                    },
                    decoration: formDecoration(
                      "Mot de passe : ",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  width: textFieldWidth,
                  child: TextFormField(
                    controller: mdpConfirm,
                    onChanged: (value) {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Champ obligatoire*";
                      }
                      if (mdpConfirm.text != mdp.text) {
                        return "Passe different";
                      }
                    },
                    decoration: formDecoration(
                      "Confirmer Mot de passe : ",
                    ),
                  ),
                ),
            Container(
              margin: EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  if (adminFormKey.currentState!.validate()) {
                    AdminModel userModel = AdminModel(
                        nom: nom.text,
                        telephone: telephone.text,
                        mdp: mdp.text);
                    AdminModel.insertAdmin(userModel, context);
                  }
                },
                child: Text("Ajouter"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
