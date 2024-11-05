import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './landing_video_widget.dart';

final API_URL = 'https://dolphin-app-n69d4.ondigitalocean.app';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  Future<List<Video>> fetchVideos() async {
    final String? apiKey = dotenv.env['WEPOC_API_KEY'];

    final request = http.Request(
      'GET',
      Uri.parse('$API_URL/api/videos?populate=*'),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $apiKey',
    });

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final List<dynamic> data = jsonDecode(responseBody)['data'];
      return data.map((json) => Video.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load videos: ${response.reasonPhrase} $apiKey');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: CloseButton(
            onPressed: () {
              context.push('/rooms');
            },
          ),
        ),
        title: const Text('Landing'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Video>>(
            future: fetchVideos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No videos found.'),
                );
              }

              final videos = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 9 / 16,
                ),
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return VideoPlaceholder(
                    title: video.title,
                    imageUrl: video.thumbnailUrl,
                    videoUrl: video.videoUrl,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class Video {
  final int id;
  final String documentId;
  final String title;
  final String description;
  final DateTime createdAt;
  final String videoUrl;
  final String thumbnailUrl;

  Video({
    required this.id,
    required this.documentId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.videoUrl,
    required this.thumbnailUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    final videoUrl = json['Video']?['url'] ?? '';
    final thumbnailUrl = json['Thumbnail']?['formats']?['medium']?['url'] ??
        json['Thumbnail']?['url'] ??
        '';

    final resolvedVideoUrl =
        videoUrl.startsWith('http') ? videoUrl : '$API_URL$videoUrl';
    final resolvedThumbnailUrl = thumbnailUrl.startsWith('http')
        ? thumbnailUrl
        : '$API_URL$thumbnailUrl';

    return Video(
      id: json['id'] as int,
      documentId: json['documentId'] as String,
      title: json['Title'] as String,
      description: json['Description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      videoUrl: resolvedVideoUrl,
      thumbnailUrl: resolvedThumbnailUrl,
    );
  }
}
