import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:fluffychat/config/themes.dart';

final perks = [
  {
    'icon': Icons.all_inclusive,
    'message': 'Unlimited AI assistant',
  },
  {
    'icon': Icons.chat,
    'message': 'Secure Encrypted Chat',
  },
  {
    'icon': Icons.update,
    'message': 'Expert Networking Hub',
  },
];

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

  Future<void> _purchaseSelectedPackage() async {
    if (selectedIndex != null) {
      try {
        final selectedPackage = availablePackages[selectedIndex!];
        final customerInfo = await Purchases.purchasePackage(selectedPackage);

        print("Purchase successful: ${customerInfo.entitlements.active}");
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
          Expanded(
            child: ListView.builder(
              itemCount: availablePackages.length,
              itemBuilder: (context, index) {
                Package package = availablePackages[index];
                return SubscriptionOption(
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
          ActionButton(onPressed: _purchaseSelectedPackage)
        ],
      ),
    );
  }
}

class SubscriptionOption extends StatelessWidget {
  final Package package;
  final bool isChecked;
  final ValueChanged<bool> onCheckedChanged;

  const SubscriptionOption({
    super.key,
    required this.package,
    required this.isChecked,
    required this.onCheckedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16,
          top: 8.0,
          bottom: 8.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.grey,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.storeProduct.title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  package.storeProduct.priceString,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  package.storeProduct.description,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Checkbox(
              value: isChecked,
              onChanged: (bool? newValue) {
                onCheckedChanged(newValue ?? false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionPerks extends StatelessWidget {
  const SubscriptionPerks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            height: 200,
            child: ListView.separated(
              itemCount: perks.length,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 8,
                );
              },
              itemBuilder: (context, index) {
                return IconMessageWidget(
                  message: perks[index]['message'] as String,
                  icon: perks[index]['icon'] as IconData,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

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

class SubscriptionBannerImage extends StatelessWidget {
  const SubscriptionBannerImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double containerHeight = constraints.maxWidth > 600 ? 400 : 300;
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: containerHeight,
          child: ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                child: Image(
                  width: MediaQuery.of(context).size.width * 1.1,
                  height: containerHeight * 1.1,
                  fit: BoxFit.cover,
                  image: const AssetImage('assets/sub-temp.jpg'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

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

class IconMessageWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const IconMessageWidget({
    super.key,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Icon(
            icon,
            color: Colors.black,
            size: 18,
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
