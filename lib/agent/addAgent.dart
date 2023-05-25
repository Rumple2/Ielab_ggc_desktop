import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/agent_model.dart';
import '../theme.dart';

class AddAgent extends StatefulWidget {
  AddAgent({Key? key}) : super(key: key);

  @override
  State<AddAgent> createState() => _AddAgentState();
}

class _AddAgentState extends State<AddAgent> {
  final agentFormKey = GlobalKey<FormState>();

  final nom = TextEditingController();

  final prenom = TextEditingController();

  final adresse = TextEditingController();

  final telephone = TextEditingController();

  final zoneA = TextEditingController();

  final mdp = TextEditingController();

  final mdpConfirm = TextEditingController();

  double textFieldWidth = 400;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: agentFormKey,
          child: Container(
            padding: EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height * 0.7,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue,width: 1.5),
              borderRadius: BorderRadius.circular(8.0),

            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.all(8.0),child: Text("AJOUTER UN AGENT",style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),),

                  Row(
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
                              decoration: formDecoration(
                                "Nom : ",
                              ),
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
                              decoration: formDecoration(
                                "Prenom : ",
                              ),
                            ),
                          ), Container(
                            margin: EdgeInsets.all(8.0),
                            width: textFieldWidth,
                            child: TextFormField(
                              onChanged: (value) {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Champ obligatoire*";
                                }
                              },
                              decoration: formDecoration(
                                "N° identité : ",
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
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
                              decoration: formDecoration(
                                "Adresse : ",
                              ),
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
                              decoration: formDecoration(
                                "Zone affetée : ",
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
                        ],
                      ),
                      Row(
                        children: [
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
                                if(mdp.text != mdpConfirm.text){
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
                                if(mdpConfirm.text != mdp.text){
                                  return "Passe different";
                                }
                              },
                              decoration: formDecoration(
                                "Confirmer Mot de passe : ",
                              ),
                            ),
                          ),
                        ],
                      ),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if(loading == false){
                          if (agentFormKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });

                            AgentModel userModel = AgentModel(
                                nom: nom.text,
                                prenom: prenom.text,
                                telephone: telephone.text,
                                adresse: adresse.text,
                                zoneAffectation: zoneA.text,
                                mdp: mdp.text);
                            AgentModel.insertAgent(userModel,context).whenComplete((){
                              setState(() {
                                loading = false;
                              });
                              nom.clear();
                              prenom.clear();
                              telephone.clear();
                              adresse.clear();
                              zoneA.clear();
                              mdp.clear();
                            });

                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50),
                      ),
                      child: loading? CircularProgressIndicator(color: Colors.white,): Text("Ajouter"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
