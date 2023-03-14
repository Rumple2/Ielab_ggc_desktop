import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:collapsible_sidebar/collapsible_sidebar/collapsible_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggc_desktop/API/api_service.dart';
import 'package:ggc_desktop/clientCotPage.dart';
import '../Mise/mise.dart';
import '../agent/BodyAgent.dart';
import '../theme.dart';
import '../utils/constants.dart';
import 'Connection.dart';
import 'Statistic/Board.dart';
import 'client/BodyClient.dart';
import 'notification.dart';

class DesktopBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sidebar ui',
      home: Scaffold(
        drawerEnableOpenDragGesture: false,
        endDrawer: Drawer(
          backgroundColor: Color.fromRGBO(224, 225, 220, 1),
          width: MediaQuery.of(context).size.width/4,
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 0.5,
                      offset: Offset(0.5,0.5),
                    ),
                  ]
                ),
                child: Center(child: Text("Notifications"),),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 100,
                  child: Notifications())
            ],
          )
        ),
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/ggc_logo.png',
                    width: 150,
                  )),

              Container(
                margin: EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                        onPressed: null, icon: Icon(Icons.contacts_sharp)),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Connection()));
                        },
                        icon: Icon(Icons.logout)),
                    Container(
                      child: Builder(
                          builder: (context) {
                            return IconButton(
                                onPressed: (){
                                  Scaffold.of(context).openEndDrawer();
                                },
                                icon: Icon(Icons.notifications_active_outlined));
                          }
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        body: SidebarPage(),
      ),
    );
  }
}



class SidebarPage extends StatefulWidget {
  @override
  _SidebarPageState createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {
  late List<CollapsibleItem> _items;

  AssetImage _avatarImg = AssetImage('assets/images/ggc_logo.png');

  @override
  void initState() {
    super.initState();
    _items = _generateItems;
    headline = _items.firstWhere((item) => item.isSelected).text;
  }

  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        text: 'Home',
        icon: Icons.home_filled,
        onPressed: (){

          //reloadPage(context);
          setState(() {
            currentPage = BodyClient();
            headline = 'Client';
          });
        },
        isSelected: true,
      ),
      CollapsibleItem(
          text: 'Agent',
          icon: Icons.support_agent,
          onPressed: () {
            setState(() {
              headline = 'Agent';
              currentPage = BodyAgent();
            });

          }),
      CollapsibleItem(
          text: 'Mises',
          icon: Icons.collections_bookmark,
          onPressed: () {
            setState(() {
              headline = 'Event';
              currentPage = MiseBoard();
            });
          }),
      CollapsibleItem(
          text: 'Settings',
          icon: Icons.settings,
          onPressed: () {
            setState(() {
              headline = 'Settings';
              //currentPage = BodyClient();
            });
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: CollapsibleSidebar(
        unselectedIconColor: globalColor.withOpacity(0.5),
        selectedIconColor: Colors.white,
        selectedIconBox: globalColor,
        toggleTitle: "Reduire",
        //isCollapsed: MediaQuery.of(context).size.width <= 800,
        items: _items,
        avatarImg: _avatarImg,
        title: 'Menu',
        onTitleTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Yay! Flutter Collapsible Sidebar!')));
        },
        body: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/bg5.jpg",
                  ),
                  fit: BoxFit.cover)),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(child: currentPage),
        ),
        //_body(size, context),
        backgroundColor: kBackgroundColor,
        selectedTextColor: Colors.limeAccent,
        textStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
        titleStyle: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
        toggleTitleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        sidebarBoxShadow: [
          BoxShadow(
            color: Colors.indigo,
            blurRadius: 20,
            spreadRadius: 0.01,
            offset: Offset(3, 3),
          ),
        ],
      ),
    );
  }

}
