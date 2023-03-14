import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ggc_desktop/client/list_client.dart';

import '../Statistic/Board.dart';



class Agentcard extends StatelessWidget {
  const Agentcard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ItemCards(
                svgSrc:"assets/icons/user (1).svg",
                title: 'Jeans Yves',
                shopName: "+22890766655",

                nbclient: "nb 31",
                press: () {},
              ),
              ItemCards(
                svgSrc:"assets/icons/user (1).svg",
                title: 'Jeans Yves',
                shopName: "+22890766655",

                nbclient: " 1/31",
                press: () {},
              ),
              ItemCards(
                svgSrc:"assets/icons/user (1).svg",
                title: 'Jeans Yves',
                shopName: "+22890766655",

                nbclient: "Progression 1/31",
                press: () {},
              ),
              ItemCards(
                svgSrc:"assets/icons/user (1).svg",
                title: 'Jeans Yves',
                shopName: "+22890766655",

                nbclient: "Progression 1/31",
                press: () {},
              ),
              ItemCards(
                svgSrc:"assets/icons/user (1).svg",
                title: 'Jeans Yves',
                shopName: "+22890766655",

                nbclient: "Progression 1/31",
                press: () {},
              ),
              ItemCards(
                svgSrc:"assets/icons/user (1).svg",
                title: 'Jeans Yves',
                shopName: "+22890766655",

                nbclient: "nbclient 1/31",
                press: () {},
              ),
              ItemCards(
                svgSrc:"assets/icons/user (1).svg",
                title: 'Jeans Yves',
                shopName: "+22890766655",

                nbclient: "1/31",
                press: () {},
              ),
              ItemCards(
                svgSrc:"assets/icons/user (1).svg",
                title: 'Jeans Yves',
                shopName: "+22890766655",

                nbclient: " 1/31",
                press: () {},
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ItemCards extends StatelessWidget {
  final String title, shopName,svgSrc ,nbclient;
  final VoidCallback press;
  const ItemCards({
    Key? key,
    required this.title,
    required this.shopName,
    required this.svgSrc,
    required this.press,
    required this.nbclient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: Offset(0 ,4),
              blurRadius: 20,
              color: Color(0xFF6A727D).withOpacity(0.40),
            )
          ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: press,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children:<Widget> [
                Container(
                  //margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    svgSrc,
                    width: size.width * 0.049,
                    height: size.height *0.080,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                Text(title,
                  style: TextStyle(
                    fontWeight:FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(shopName,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10,),

                Text(nbclient),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BodyClient extends StatelessWidget {
  const BodyClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * .30,
            child: GlobalBoard()),
        Container(
            height: MediaQuery.of(context).size.height * 0.58,
            child: ListClient()),
      ],
    );
  }
}





