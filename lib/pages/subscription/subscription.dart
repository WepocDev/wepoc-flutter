import 'package:fluffychat/pages/subscription/subscription_view_action_button.dart';
import 'package:fluffychat/pages/subscription/subscription_view_banner.dart';
import 'package:fluffychat/pages/subscription/subscription_view_option.dart';
import 'package:fluffychat/pages/subscription/subscription_view_perks.dart';
import 'package:fluffychat/pages/subscription/subscription_view_title.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/material.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  List<Package> availablePackages = [];
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _fetchOffers();
  }

  Future<void> _fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        setState(() {
          availablePackages = offerings.current!.availablePackages;
        });
      }
    } catch (e) {
      print("Error fetching offers: $e");
    }
  }

  Future<void> _purchaseSelectedPackage(BuildContext context) async {
    if (selectedIndex != null) {
      try {
        final selectedPackage = availablePackages[selectedIndex!];
        final customerInfo = await Purchases.purchasePackage(selectedPackage);

        print("Purchase successful: ${customerInfo.entitlements.active}");
        context.push('/rooms');
      } catch (e) {
        // Manejo de errores
        print("Error purchasing package: $e");
      }
    } else {
      print("No package selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
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
          Flexible(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: availablePackages.length,
              itemBuilder: (context, index) {
                Package package = availablePackages[index];
                return SubscriptionListItem(
                  package: package,
                  isChecked: selectedIndex == index,
                  onCheckedChanged: (bool value) {
                    setState(() {
                      selectedIndex = value ? index : null;
                    });
                  },
                );
              },
            ),
          ),
          ActionButton(
            onPressed: () {
              _purchaseSelectedPackage(context);
            },
            disabled: selectedIndex == null,
          )
        ],
      ),
    );
  }
}
