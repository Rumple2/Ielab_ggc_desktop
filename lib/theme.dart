import 'package:flutter/material.dart';
import 'package:ggc_desktop/API/api_service.dart';
import 'package:ggc_desktop/client/BodyClient.dart';
import 'Mise/mise.dart';
import 'desktop_body.dart';

Widget currentPage = BodyClient();
String headline = "Home";
int nombreClient = 0;
int nombreAgent = 0;
int nombreMise = 0;
final globalTextFont = 'RobotoRegular';
final globalColorS = Color.fromRGBO(46, 14, 102, 1);
final globalColor = Color.fromRGBO(1,193, 204, 1);
final textFieldColor = Colors.transparent;//Color.fromRGBO(168, 226, 230, 0.5);
final columnTextStyle = TextStyle(color: Colors.white);
final staticInfoTextStyle = TextStyle(
  fontFamily: globalTextFont,
  fontSize: 16,
    color: Colors.black26
);
final infoClientTextStyle = TextStyle(
    fontFamily: globalTextFont,
    fontSize: 18,
    color: Colors.black
);
final formTextStyle = TextStyle(
  fontFamily: globalTextFont,
  fontSize: 14,
  color: Colors.black
);

InputDecoration formDecoration(String name,{last = ""}){
  return InputDecoration(
    label: Text(name,style: formTextStyle,),
     hintText: last,
    border:  OutlineInputBorder()
  );
}
String percentageModifier(double value) {
  final roundedValue = value.ceil().toInt().toString();
  return '$roundedValue F';
}
String nombreModifier(double value) {
  final roundedValue = value.ceil().toInt().toString();
  return '$roundedValue';
}
reloadPage(context) {
  if(!MongoDatabase.db.isConnected){
    MongoDatabase.db.open();
  }
  Navigator.pop(context);
  Navigator.push(context, MaterialPageRoute(builder: (_) => DesktopBody()));
}
