import 'package:flutter/material.dart';
import 'package:ggc_desktop/API/api_service.dart';
import 'package:ggc_desktop/API/encryption.dart';

import 'desktop_body.dart';

class Connection extends StatefulWidget {
  const Connection({Key? key}) : super(key: key);

  @override
  State<Connection> createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  bool _obscureText = true;
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
   final mdp = TextEditingController();
   String tempMdp = "";
   final numTel = TextEditingController();
   var Etext;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg8.jpg"),
            fit: BoxFit.cover
          ),
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.indigo,
              Colors.grey,
            ]
          )
        ),
        child: Center(
          child: Container(
            height: 400,
            width: 400,
            child: Form(
              key:  formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                  child: Image.asset("assets/images/ggc_logo.png", width: 200,),
              ),
                      const SizedBox(height: 15,),
                     const Text("Groupe Générale de Commerce et Partenaire",style: TextStyle(
                       fontFamily: "UnifrakturCook",
                       fontSize: 34,
                     ),textAlign: TextAlign.center,),
                     TextFormField(
                       onChanged: (value){
                         numTel.text = value.trim();
                       },                        decoration: const InputDecoration(
                          label: Text("Numero telephone"),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.call,color: Color.fromRGBO(1, 193, 204, 1))

                        ),
                       validator: (value){
                         if(value!.isEmpty){
                           return "Champs vide";
                         }
                       },
                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                        obscureText: _obscureText,
                       onChanged: (value){
                          mdp.text = value;

                       },
                        decoration: InputDecoration(
                            label: Text("Mot de passe"),
                            border: OutlineInputBorder(),
                        ),
                        validator: (value){
                         if(value!.isEmpty){
                           return "Champs vide";
                         }
                        },
                      ),
                      SizedBox(height: 10,),
                      ElevatedButton(onPressed: () async {
                        if(loading == false){

                          if(formKey.currentState!.validate()){
                            setState(() {
                              loading = true;
                            });
                            if(await MongoDatabase.adminLogin(numTel.text.trim(), mdp.text.trim()) == true){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>DesktopBody()));
                            }
                            else ScaffoldMessenger.of(context).showSnackBar((SnackBar(content: Text("Mot de passe ou numéro incorrect"),backgroundColor: Colors.red,)));
                            setState(() {
                              loading = false;
                            });
                          }

                        }
                        //Default pass Admin

                      }, child:loading? CircularProgressIndicator(color: Colors.white,): Text("Se Connecter"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200,50)
                      ),
                      )
                    ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
