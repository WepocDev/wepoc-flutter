import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  Future<List<Video>> fetchVideos() async {
    final String? apiKey = dotenv.env['WEPOC_API_KEY'];

    final request = http.Request(
      'GET',
      Uri.parse('https://dolphin-app-n69d4.ondigitalocean.app/api/videos'),
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
                    imageUrl:
                        'https://placehold.co/300x500?text=${video.title}', // Placeholder de prueba
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

  Video({
    required this.id,
    required this.documentId,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as int,
      documentId: json['documentId'] as String,
      title: json['Title'] as String,
      description: json['Description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class VideoPlaceholder extends StatelessWidget {
  final String title;
  final String imageUrl;

  const VideoPlaceholder({
    required this.title,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
