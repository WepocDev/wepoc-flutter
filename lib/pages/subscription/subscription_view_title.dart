import 'package:flutter/material.dart';

class SubscriptionTitle extends StatelessWidget {
  const SubscriptionTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 480),
      margin: const EdgeInsets.only(bottom: 8.0),
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(
          'Join the club',
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.displaySmall?.fontSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
