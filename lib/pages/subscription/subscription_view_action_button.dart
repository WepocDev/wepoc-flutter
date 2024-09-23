import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/subscription/subscription_view_alert.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final elevatedButtonTheme =
        FluffyThemes.buildTheme(context, Brightness.dark)
            .elevatedButtonTheme
            .style;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 50.0,
          child: TextButton(
            style: elevatedButtonTheme,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => const CustomAlertDialog(),
              );
            },
            child: const Text('Continue'),
          ),
        ),
      ),
    );
  }
}
