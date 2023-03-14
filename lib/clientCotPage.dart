import 'package:flutter/material.dart';

import 'Models/cotisation_model.dart';

class ClientCotPage extends StatefulWidget {
  ClientCotPage({required this.cotisationModel,Key? key}) : super(key: key);
  CotisationModel cotisationModel;

  @override
  State<ClientCotPage> createState() => _ClientCotPageState();
}

class _ClientCotPageState extends State<ClientCotPage> {
  List CotList = [];
  int numPage = 0;
  int sizePage = 0;

  @override
  Widget build(BuildContext context) {
    List pages = widget.cotisationModel.pages;
    if(pages.length > 0){
      sizePage = pages.length - 1;
      CotList = pages.elementAt(0);
    }
    return Container(
          width: MediaQuery.of(context).size.width * 0.3,
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
                              CotList = pages.elementAt(numPage);
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_back_ios_new_sharp)),
                    SizedBox(width: 50,),
                    Text("Page ${numPage}"),
                    SizedBox(width: 50,),
                    IconButton(
                        onPressed: () {
                          if (numPage < sizePage) {
                            setState(() {
                              numPage++;
                              CotList = pages.elementAt(numPage);
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_forward_ios_sharp))
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: GridView.builder(
                      itemCount: 31,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7),
                      itemBuilder: (context, index) {
                        int caseC = index+1;
                        bool color = false;
                        if(CotList.isNotEmpty && index < CotList.length){
                          if(CotList.elementAt(index) == 1)
                            color = true;
                        }
                        return Container(
                          margin: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: color?Colors.green : Colors.white),
                          child: Center(child: Text(caseC.toString()),),
                        );
                      }))
            ],
          ),
        );
  }
}
