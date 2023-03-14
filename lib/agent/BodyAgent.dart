import 'package:flutter/material.dart';
import 'package:ggc_desktop/Models/agent_model.dart';
import '../API/api_service.dart';
import '../Models/client_model.dart';
import '../Models/cotisation_model.dart';
import '../desktop_body.dart';
import '../loading.dart';
import '../theme.dart';
import 'list_agent.dart';

class BodyAgent extends StatefulWidget {
  const BodyAgent({Key? key}) : super(key: key);

  @override
  State<BodyAgent> createState() => _BodyAgentState();
}

class _BodyAgentState extends State<BodyAgent> {  final agentFormKey = GlobalKey<FormState>();
final nom = TextEditingController();
final prenom = TextEditingController();
final adresse = TextEditingController();
final telephone = TextEditingController();
final zoneA = TextEditingController();
final mdp = TextEditingController();
final mdpConfirm = TextEditingController();
double textFieldWidth = 400;
Widget currentPage = ListAgent();


@override
Widget build(BuildContext context) {

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
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
          currentPage.toString()=="ListAgent"?
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(150,70),
                  backgroundColor: globalColor
              ),
              onPressed: (){
            setState(() {
              currentPage = AgentForm(context);
            });
          }, child: Text("+ Agent",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),)):
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150,70),
                backgroundColor: globalColor
              ),
              onPressed: (){
            setState(() {
              currentPage = ListAgent();
            });
          }, child: Text("Liste agent",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),)),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.93,
              child: currentPage),
        ],
      )
    ],
  );
}

AgentForm(context) {
  return Form(
    key: agentFormKey,
    child: Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue,width: 1.5),
        borderRadius: BorderRadius.circular(8.0),

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("ENREGISTRER UN AGENT",
                style: TextStyle(fontSize: 26, fontFamily: globalTextFont)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
            mainAxisAlignment: MainAxisAlignment.center,
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
            mainAxisAlignment: MainAxisAlignment.center,
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
              )
            ],
          ),
          Container(
            margin: EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                if (agentFormKey.currentState!.validate()) {
                  AgentModel userModel = AgentModel(
                      nom: nom.text,
                      prenom: prenom.text,
                      telephone: telephone.text,
                      adresse: adresse.text,
                      zoneAffectation: zoneA.text,
                      mdp: mdp.text);
                  AgentModel.insertAgent(userModel,context);
                  reloadPage(context);
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
