import 'package:purchases_flutter/purchases_flutter.dart';

Future<bool> checkSubscriptionStatus() async {
  try {
    final purchaserInfo = await Purchases.getCustomerInfo();
    print('purchase ${purchaserInfo.entitlements.active}');
    return purchaserInfo.entitlements.active.containsKey('your_entitlement_id');
  } catch (e) {
    return false;
  }
}
