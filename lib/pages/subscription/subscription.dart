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

  Future<void> _purchaseSelectedPackage() async {
    if (selectedIndex != null) {
      try {
        final selectedPackage = availablePackages[selectedIndex!];
        print('Purchasing $selectedPackage');
        final customerInfo = await Purchases.purchasePackage(selectedPackage);

        print("Purchase successful: ${customerInfo.entitlements.active}");
        context.pop();
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
    // final backgroundColor = Theme.of(context).colorScheme.secondary;
    final backgroundColor = Color(0xff111216);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height * 0.4;
    return Scaffold(
      extendBodyBehindAppBar:
          true, // Extiende el cuerpo detrás del área del notch
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                // Imagen de fondo
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(50), // Esquinas redondeadas
                  child: Image.asset(
                    'assets/subscribe_banner.png', // Ruta de la imagen
                    width: width,
                    height: 285,
                    fit: BoxFit.cover, // contentMode: .fill
                  ),
                ),
                // Contenedor para la sombra y el desvanecimiento
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(50), // Esquinas redondeadas
                  child: Container(
                    width: width,
                    height: 285,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: backgroundColor.withOpacity(.999),
                          spreadRadius: height / 2,
                          blurRadius: height / 4,
                          // blurStyle: BlurStyle.outer,
                          offset: Offset(0, height),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(child: Column(children: [])),
                Expanded(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      Column(
                        children: [
                          // SubscriptionBannerImage(),
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
                    _purchaseSelectedPackage();
                  },
                  disabled: selectedIndex == null,
                )
              ],
            ),
          ),
        ],

        // body: Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Expanded(
        //       flex: 3,
        //       child: ListView(
        //         physics: const NeverScrollableScrollPhysics(),
        //         children: const [
        //           Column(
        //             children: [
        //               SubscriptionBannerImage(),
        //               SubscriptionTitle(),
        //               SubscriptionPerks(),
        //             ],
        //           ),
        //         ],
        //       ),
        //     ),

        // ),
      ),
    );
  }
}
