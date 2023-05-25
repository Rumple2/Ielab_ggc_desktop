import 'package:flutter/material.dart';
import 'package:ggc_desktop/Models/agent_model.dart';
import '../theme.dart';
import 'addAgent.dart';
import 'list_agent.dart';

class BodyAgent extends StatefulWidget {
  const BodyAgent({Key? key}) : super(key: key);

  @override
  State<BodyAgent> createState() => _BodyAgentState();
}

class _BodyAgentState extends State<BodyAgent> {

  bool isListAgentBtn = false;
  bool isAddAgentBtn = false;
  Color BtnColor_list = globalColor;
  Color BtnColor_add = Colors.white38;

  MaterialStatesController controller = MaterialStatesController();

  Widget curAgentPage = ListAgent();
bool isCurAgentP = true;

@override
Widget build(BuildContext context) {

  return ConstrainedBox(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height,
      maxWidth: MediaQuery.of(context).size.width,
    ),
    child: SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(150,70),
                      backgroundColor: BtnColor_list
                  ),
                  onPressed: (){
                    setState(() {
                      BtnColor_list = globalColor;
                      BtnColor_add = Colors.white38;
                      curAgentPage = ListAgent();

                    });
                  }, child: Text("Liste agent",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),)),
              SizedBox(width: 50,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150,70),
                    backgroundColor: BtnColor_add,
                  ),
                  onPressed: (){
                setState(() {
                  BtnColor_add = globalColor;
                  BtnColor_list = Colors.white38;
                  curAgentPage = AddAgent();
                });
              }, child: Text("Nouvel agent",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),)),
            ],
          ),
              Container(
                  ///margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: curAgentPage),
            ],
      ),
    ),
  );
}


}
