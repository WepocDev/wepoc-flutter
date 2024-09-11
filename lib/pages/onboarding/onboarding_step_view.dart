import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnboardingStepView extends StatelessWidget {
  const OnboardingStepView({super.key});

  final background = Colors.amberAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Hola")],
      ),
    );
  }
}
