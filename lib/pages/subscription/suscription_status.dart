import 'package:purchases_flutter/purchases_flutter.dart';

Future<bool> checkSubscriptionStatus() async {
  try {
    final purchaserInfo = await Purchases.getCustomerInfo();
    print('purchase ${purchaserInfo.entitlements.active}');
    return purchaserInfo.entitlements.active.containsKey('subscription.yearly');
  } catch (e) {
    return false;
  }
}
