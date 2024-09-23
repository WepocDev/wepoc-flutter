import 'package:flutter/material.dart';

class SubscriptionBannerImage extends StatelessWidget {
  const SubscriptionBannerImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final containerHeight = constraints.maxWidth > 600 ? 400 : 300;
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: containerHeight as double,
          child: ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                child: Image(
                  width: MediaQuery.of(context).size.width *
                      1.1, // Increase width to overflow
                  height: containerHeight * 1.1, // Increase height to overflow
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
