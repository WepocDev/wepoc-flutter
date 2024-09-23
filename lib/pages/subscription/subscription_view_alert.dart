import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('You are currently subscribed to this'),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: const Text(
          'Your subscription to Yearly Subscriptions renews on 16 Nov 2023 for R 2,999. To review subscription options or cancel this subscription, tap Manage.',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Manage'),
          child: const Text('Manage'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
