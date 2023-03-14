import 'package:flutter/material.dart';
import 'package:ggc_desktop/API/api_service.dart';
import 'package:ggc_desktop/API/config.dart';
import 'package:ggc_desktop/Models/cotisation_model.dart';
import 'package:ggc_desktop/Models/notif_model.dart';
import 'package:ggc_desktop/theme.dart';
import 'package:intl/intl.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd().format(DateTime.now());
    List<CotisationModel> allCotisation = [];
    List<CotisationModel>  notifCotisationPage = [];
    List<CotisationModel>  notifCotisationCase = [];
     return FutureBuilder(
       future: MongoDatabase.getCollectionData(Config.cotisation_collection),
       builder: (context,AsyncSnapshot snapshot){
         if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
           allCotisation.clear();
           for(int i = 0; i<snapshot.data.length; i++){
             allCotisation.add(CotisationModel.fromJson(snapshot.data[i]));
           }
           if(notifCotisationPage.isEmpty) {
             for (int i = 0; i < allCotisation.length; i++) {
               int posPage = allCotisation[i].posPage;
                if(allCotisation[i].pages[posPage].length >= 10){
                  notifCotisationCase.add(allCotisation[i]);
                }
                if(allCotisation[i].pages.length >=14){
                  notifCotisationPage.add(allCotisation[i]);
                }
             }
           }
           return ListView.builder(
             itemCount: notifCotisationPage.length,
             itemBuilder: (context,index){
               return Container(
                 margin: EdgeInsets.all(10.0),
                 padding: EdgeInsets.all(10.0),
                 color: Colors.white,
                 width: double.infinity,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text("New Notifications ($df)",style: staticInfoTextStyle,),
                         SizedBox(height: 10,),
                         Text("Le client ${notifCotisationCase[index].id_client} : à atteint sa 15eme Page e Cotisation. ",style: TextStyle(fontWeight: FontWeight.w700, fontFamily: "RobotoRegular"),),

                       ],
                     ),
                     IconButton(onPressed: (){
                      NotificationModel.getNotif();
                     }, icon: Icon(Icons.delete_rounded,color: Colors.grey,)),

                   ],
                 ),
               );
             },
           );
         }
         if(snapshot.connectionState == ConnectionState.waiting){
           return Center(child: CircularProgressIndicator(),);
         }
         return Center(child: Text("Pas de notification"),);
       },
     );
  }
}
