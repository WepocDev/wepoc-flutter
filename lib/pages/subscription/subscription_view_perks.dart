import 'package:flutter/material.dart';

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
              physics: const NeverScrollableScrollPhysics(),
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
