import 'package:flutter/material.dart';
import 'package:ggc_desktop/theme.dart';
import 'API/api_service.dart';
import 'Connection.dart';

void main(){
  runApp(const MyApp());
  MongoDatabase.connect();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GGC & PARTENAIRES',
      debugShowCheckedModeBanner: false,
      color: globalColor,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'UnifrakturCook',
          textTheme: ThemeData.light().textTheme.copyWith(
              headline2: TextStyle(
                  fontFamily: 'UnifrakturCook'
              )
          )
      ),
      home: Connection(),//const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
