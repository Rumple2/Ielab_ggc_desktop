import 'package:flutter/material.dart';
import 'package:ggc_desktop/API/api_service.dart';
import 'package:ggc_desktop/API/encryption.dart';

import 'desktop_body.dart';

class Connection extends StatelessWidget {
  const Connection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   final mdp = TextEditingController();
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
                     controller: numTel,
                      decoration: InputDecoration(
                        label: Text("Numero telephone"),
                        border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 30,),
                    TextFormField(
                     controller: mdp,
                      decoration: InputDecoration(
                          label: Text("Mot de passe"),
                          border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(onPressed: () async {
                     if(await MongoDatabase.adminLogin(numTel.text, mdp.text) == true){
                       Navigator.pop(context);
                       Navigator.push(context, MaterialPageRoute(builder: (_)=>DesktopBody()));
                     }
                     else ScaffoldMessenger.of(context).showSnackBar((SnackBar(content: Text("Mot de passe ou numéro incorrect"),backgroundColor: Colors.red,)));
                      //Default pass Admin

                    }, child: Text("Se Connecter"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200,50)
                    ),
                    )
                  ],
            ),
          ),
        ),
      ),
    );
  }
}
