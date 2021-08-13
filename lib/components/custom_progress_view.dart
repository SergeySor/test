import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CustomProgressView extends StatelessWidget {
  CustomProgressView({Key? key, required this.isVisible}) : super(key: key);

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration:
              new BoxDecoration(color: Colors.grey.shade500.withOpacity(0.5)),
          child: Center(
            child: SleekCircularSlider(
              appearance: CircularSliderAppearance(
                spinnerMode: true,
                spinnerDuration: 1500,
                size: 50,
                startAngle: 180,
                angleRange: 360,
                customColors: CustomSliderColors(
                    dotColor: Colors.white.withOpacity(0.1),
                    trackColor: Colors.transparent,
                    progressBarColors: [
                      Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
                      Theme.of(context).cardColor
                    ],
                    shadowColor: Color(0xFF0CA1BD),
                    shadowMaxOpacity: 0.05),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
