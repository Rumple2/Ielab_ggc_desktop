import 'package:flutter/material.dart';
import 'package:ggc_desktop/theme.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class MyLoading extends StatefulWidget {
  const MyLoading({Key? key}) : super(key: key);

  @override
  State<MyLoading> createState() => _MyLoadingState();
}

class _MyLoadingState extends State<MyLoading> {
  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      min: 0,
      max: 1000,
      initialValue: 1000,
      appearance: CircularSliderAppearance(
          animationEnabled: true,
          spinnerMode: true,
          size: 70,
          customWidths: CustomSliderWidths(
              trackWidth: 0.5,
              shadowWidth: 0.5,
              handlerSize: 0.5
          ),
          infoProperties: InfoProperties(
              topLabelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold
              ),
              modifier: (value){
                return percentageModifier(value);
              }
          )
      ),
    );
  }
}
