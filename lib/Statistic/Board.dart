import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../theme.dart';

class GlobalBoard extends StatefulWidget {
  const GlobalBoard({Key? key}) : super(key: key);

  @override
  State<GlobalBoard> createState() => _GlobalBoardState();
}

class _GlobalBoardState extends State<GlobalBoard> {
  @override

  Widget build(BuildContext context) {
    print(nombreAgent);
    print(nombreClient);
    return Center(
        child: ListView(
          children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SleekCircularSlider(
                    min: nombreClient.toDouble(),
                    max: double.maxFinite,
                  appearance: CircularSliderAppearance(
                    customWidths: CustomSliderWidths(trackWidth: 20),
                   animationEnabled: true,
                   size: 300,
                    infoProperties: InfoProperties(
                      topLabelText: "Clients",
                      topLabelStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                      modifier: (value){
                       return nombreModifier(value);
                      }
                    )

                  ),
                  ),
                  SleekCircularSlider(
                    min: nombreAgent.toDouble(),
                    max: double.maxFinite,
                    appearance: CircularSliderAppearance(
                        customWidths: CustomSliderWidths(trackWidth: 20),
                        animationEnabled: true,
                        size: 300,
                        infoProperties: InfoProperties(
                            topLabelText: "Agents",
                            topLabelStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                            modifier: (value){
                              return nombreModifier(value);
                            }
                        )

                    ),
                  ),
                  SleekCircularSlider(
                    min: nombreMise.toDouble(),
                    max: double.maxFinite,
                    appearance: CircularSliderAppearance(
                        customWidths: CustomSliderWidths(trackWidth: 20),
                        animationEnabled: true,
                        size: 300,
                        infoProperties: InfoProperties(
                            topLabelText: "Types de tontine",
                            topLabelStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                            modifier: (value){
                              return nombreModifier(value);
                            }
                        )

                    ),
                  ),
                ],
              ),
          ],
    ));
  }
}
