import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';

class OnboardingStepView extends StatelessWidget {
  final String title;
  final String description;
  final Image image;

  const OnboardingStepView({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF16181D),
      padding: const EdgeInsets.all(28.0),
      child: Column(
        children: [
          Container(
            height: 300.0,
            child: image,
          ),
          const SizedBox(height: 20.0),
          Text(
            "$title:",
            style: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.white,
              fontSize: FontSize.large.emValue,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            description,
            style: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: FontSize.medium.emValue,
            ),
          ),
        ],
      ),
    );
  }
}
