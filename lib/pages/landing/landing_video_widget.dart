import 'package:flutter/material.dart';
import './full_screen_video_view.dart';

class VideoPlaceholder extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String videoUrl;

  const VideoPlaceholder(
      {required this.title,
      required this.imageUrl,
      required this.videoUrl,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenVideoView(
              videoTitle: title,
              videoUrl: videoUrl,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
