
import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF0C9869);
const kTextColor = Color(0xFF3C4046);
// list of colors that we use in our app
const kBackgroundColor = Colors.white;
const kBacseColor = Color(0xFF46A0AE);
const kSecolor = Colors.black;


const kPrimaryColorC = Colors.transparent;

const kTextLigntColor = Color(0xFF100F66);
const kTranspColor = Colors.transparent;
const kTextpagecardColor = Color(0xFF1EAE3FF);
//Widget currentPage = Reservation();
//Widget ?appbarPage =Chambreappbar();
const kPrimaryGradient = LinearGradient(
  colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
//final columnTextStyle = GoogleFonts.josefinSans(textStyle:TextStyle(color: Colors.white) );
final rowTextStyle = TextStyle(color: Colors.white);
const double kDefaultPadding = 20.0;
//const kDefaultMarding = 20.0;final columnTextStyle = GoogleFonts.josefinSans(textStyle:TextStyle(color: Colors.white) );
//final rowTextStyle = TextStyle(color: Colors.white);


// our default Shadow
const kDefaultShadow = BoxShadow(
  offset: Offset(0, 15),
  blurRadius: 27,
  color: Colors.black12, // Black color with 12% opacity
);

var defaultBackgroundColor =  kBackgroundColor;
var tilePadding = const EdgeInsets.only(left: 8.0, right: 8.0, top: 0);

class ButtonCard extends StatelessWidget {
  ButtonCard({required this.color, required this.cardChild, required this.onPress});

  final Color color;
  final Widget cardChild;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 2,
        child: cardChild,
        margin:EdgeInsets.fromLTRB(0, 10, 0, 10),

        decoration: BoxDecoration(
          color: color,

        ),
      ),
    );
  }
}
class ButtextCard extends StatelessWidget {
  ButtextCard ({required  this.bttext, required this.onPress, required this.color});
  final Color color;
  final String bttext;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: EdgeInsets.only(left: 20,top: 0,right: 20,bottom: 0),
            child:  TextButton(onPressed: onPress, child: Text("$bttext",style: TextStyle(
                fontSize: 20.0,
                color: kTextLigntColor
            ),))



    );
  }
}
