import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:collapsible_sidebar/collapsible_sidebar/collapsible_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggc_desktop/Tontine/Cotisation.dart';
import 'package:ggc_desktop/admin/AdminBody.dart';
import 'package:ggc_desktop/backup/backup.dart';
import 'package:ggc_desktop/historique/historiques.dart';
import '../agent/BodyAgent.dart';
import '../theme.dart';
import '../utils/constants.dart';
import 'Connection.dart';
import 'client/BodyClient.dart';
import 'notification.dart';

String bgImageName = "bg5.jpg";

class DesktopBody extends StatefulWidget {
  @override
  State<DesktopBody> createState() => _DesktopBodyState();
}

class _DesktopBodyState extends State<DesktopBody> {
  String _selectedItem = 'car1.jpeg';

  final List<String> _items = [
    'car1.jpeg',
    'car2.jpg',
    'bg5.jpg',
    'beautiful.jpg',
    'bg1.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sidebar ui',
      home: Scaffold(
        drawerEnableOpenDragGesture: false,
        endDrawer: Drawer(
            backgroundColor: Color.fromRGBO(224, 225, 220, 1),
            width: MediaQuery
                .of(context)
                .size
                .width / 4,
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 0.5,
                          offset: Offset(0.5, 0.5),
                        ),
                      ]
                  ),
                  child: Center(child: Text("Notifications"),),
                ),
                Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height - 100,
                    child: Notifications())
              ],
            )
        ),
        appBar: AppBar(
            backgroundColor: kBackgroundColor,
            flexibleSpace: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
            Container(
            margin: EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/ggc_logo.png',
              width: 150,
            )),
                  SizedBox(width: 20,),
        Container(
            margin: EdgeInsets.all(8.0),
            child: Row(
                children: <Widget>[
                IconButton(
                onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>AdminBody()));
        }, icon: Icon(Icons.contacts_sharp)),
                  SizedBox(width: 20,),
        IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Connection()));
            },
            icon: Icon(Icons.logout)),
        SizedBox(width: 20,),
        Container(
          child: Builder(
              builder: (context) {
                return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    icon: Icon(Icons.notifications_active_outlined));
              }
          ),
        ),          SizedBox(width: 20,),
                  Container(
          child: Builder(
              builder: (context) {
                return IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>BackupBody()));
                    },
                    icon: Icon(Icons.backup_outlined));
              }
          ),
        ), SizedBox(width: MediaQuery
          .of(context)
          .size
          .width * 0.7,),
        Container(
          child: Builder(
              builder: (context) {
                return DropdownButton<String>(
                  value: _selectedItem,
                  items: _items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (selectedItem) {
                    setState(() {
                      _selectedItem = selectedItem!;
                      bgImageName = selectedItem;
                    });
                  },
                );
              }
          ),
        ),
          ],
        ),
      )
      ],
    ),
    ],
    ),
    ),
    body: SidebarPage()
    ,
    )
    ,
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
    headline = _items
        .firstWhere((item) => item.isSelected)
        .text;
  }

  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        text: 'Home',
        icon: Icons.home_filled,
        onPressed: () {
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
          text: 'Cotisations',
          icon: Icons.date_range,
          onPressed: () {
            setState(() {
              headline = 'Cotisations';
              currentPage = CotisationBoard();
            });
          }),
      CollapsibleItem(
          text: 'Tontines',
          icon: Icons.book_sharp,
          onPressed: () {
            setState(() {
              headline = 'Tontines';
              currentPage = CotisationBoard();
            });
          }),
      CollapsibleItem(
          text: 'Historiques',
          icon: Icons.calendar_view_day,
          onPressed: () {
            setState(() {
              headline = 'Historiques';
              currentPage = Historique();
            });
          }),

    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: CollapsibleSidebar(
        unselectedIconColor: globalColor.withOpacity(0.5),
        selectedIconColor: Colors.white,
        selectedIconBox: globalColor,
        toggleTitle: "Reduire",
        //isCollapsed: MediaQuery.of(context).size.width <= 800,
        topPadding: 10,
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
                    "assets/images/${bgImageName}",
                  ),
                  fit: BoxFit.cover)),
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
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
