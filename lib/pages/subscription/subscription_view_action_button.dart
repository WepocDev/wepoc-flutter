import 'package:fluffychat/config/themes.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final void Function() onPressed;

  const ActionButton({
    super.key,
    required this.onPressed,
  });

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
            onPressed: onPressed,
            child: const Text('Continue'),
          ),
        ),
      ),
    );
  }
}
