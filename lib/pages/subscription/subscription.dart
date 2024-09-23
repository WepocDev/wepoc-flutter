import 'package:fluffychat/pages/subscription/subscription_view_action_button.dart';
import 'package:fluffychat/pages/subscription/subscription_view_banner.dart';
import 'package:fluffychat/pages/subscription/subscription_view_option.dart';
import 'package:fluffychat/pages/subscription/subscription_view_perks.dart';
import 'package:fluffychat/pages/subscription/subscription_view_title.dart';
import 'package:flutter/material.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  bool _isChecked = false;
  onchange(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              children: const [
                Column(
                  children: [
                    SubscriptionBannerImage(),
                    SubscriptionTitle(),
                    SubscriptionPerks(),
                  ],
                ),
              ],
            ),
          ),
          SubscriptionOption(isChecked: _isChecked, onchange: onchange),
          const ActionButton(),
        ],
      ),
    );
  }
}
