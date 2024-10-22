import 'package:flutter/material.dart';

class BenefitsView extends StatelessWidget {
  final String currentSubscriptionLevel =
      'Premium'; // Replace with your data source
  final List<String> benefits = [
    'Ad-free experience',
    'Access to exclusive content',
    'Priority customer support',
  ]; // Replace with your data source
  final String subscriptionExpirationDate = '2024-12-31';

  BenefitsView({super.key}); // Replace with your data source

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Benefits'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Subscription Level: $currentSubscriptionLevel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: benefits.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text(benefits[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Subscription Expiration Date: $subscriptionExpirationDate',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
