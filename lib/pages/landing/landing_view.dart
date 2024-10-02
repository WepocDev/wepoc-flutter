import 'package:flutter/material.dart';
import './landing_video_widget.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two videos per row
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 9 / 16, // Adjusted for better fit on screen
          ),
          itemCount: 8, // Replace with your actual video count
          itemBuilder: (context, index) {
            return VideoPlaceholder(
              title: 'Video Title $index',
              imageUrl:
                  'https://placehold.co/300x500', // Replace with actual image URL
            );
          },
        ),
      ),
    );
  }
}
