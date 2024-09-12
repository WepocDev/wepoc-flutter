import 'package:fluffychat/config/themes.dart';
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

class Subscription extends StatelessWidget {
  const Subscription({super.key});

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
          const SubscriptionOption(),
          const ActionButton(),
        ],
      ),
    );
  }
}

class SubscriptionOption extends StatefulWidget {
  const SubscriptionOption({super.key});

  @override
  SubscriptionOptionState createState() => SubscriptionOptionState();
}

class SubscriptionOptionState extends State<SubscriptionOption> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yearly Subscription',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'R 2,999',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Checkbox(
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value ?? false;
                });
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
          child: SizedBox(
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
              child: Image(
                width: MediaQuery.of(context).size.width,
                height: containerHeight,
                fit: BoxFit.cover,
                image: const AssetImage('assets/sub-temp.jpeg'),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({super.key});

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
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => const CustomAlertDialog(),
              );
            },
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
