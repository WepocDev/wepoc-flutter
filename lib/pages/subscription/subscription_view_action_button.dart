import 'package:fluffychat/config/themes.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final void Function() onPressed;
  final bool disabled;

  const ActionButton({
    super.key,
    required this.onPressed,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 50.0,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: disabled
                ? Theme.of(context)
                    .disabledColor // Set the background color when disabled
                : Theme.of(context)
                    .colorScheme
                    .primary, // Normal background color
            foregroundColor: disabled
                ? Colors.grey // Set text color when disabled
                : Colors.white, // Normal text color
          ),
          onPressed: disabled
              ? null
              : onPressed, // Disable button if 'disabled' is true
          child: const Text('Continue'),
        ),
      ),
    );
  }
}
