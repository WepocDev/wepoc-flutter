import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeImage extends StatelessWidget {
  String userId;
  String link;

  QRCodeImage({
    super.key,
    required this.userId,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 100,
        // height: 200,
        color: Colors.white,
        child: QrImageView(
          data: '$link?userId=$userId',
          version: QrVersions.auto,
          // size: 200.0,
        ),
      ),
    );
  }
}
