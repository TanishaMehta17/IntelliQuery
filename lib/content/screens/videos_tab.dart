import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_content_recommendation_application/providers/videoProivder.dart';
import 'package:smart_content_recommendation_application/providers/queryProvider.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoTab extends StatelessWidget {
  // Function to extract video ID from a YouTube URL
  String extractVideoId(String videoUrl) {
    final uri = Uri.tryParse(videoUrl);
    if (uri != null && uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v'] ?? '';
    }
    return '';
  }

  // Function to get the thumbnail URL
  String getThumbnailUrl(String videoUrl) {
    final videoId = extractVideoId(videoUrl);
    return videoId.isNotEmpty
        ? 'https://img.youtube.com/vi/$videoId/0.jpg'
        : '';
  }

  @override
  Widget build(BuildContext context) {
    final query = Provider.of<QueryProvider>(context).query;
    final videoProvider = Provider.of<VideoProvider>(context);

    return FutureBuilder(
      future: videoProvider.fetchVideos(query),
      builder: (context, snapshot) {
        final videos = videoProvider.videos ?? [];

        if (snapshot.connectionState == ConnectionState.waiting && videos.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else if (videos.isEmpty) {
          return Center(child: Text('No videos found.'));
        } else {
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index] as Map<String, dynamic>;
              final videoUrl = video['videoUrl'] ?? '';
              final title = video['title'] ?? 'Untitled';
              final thumbnailUrl = getThumbnailUrl(videoUrl);

              return Card(
                child: ListTile(
                  leading: thumbnailUrl.isNotEmpty
                      ? Image.network(
                          thumbnailUrl,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.video_library, size: 50),
                  title: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    if (videoUrl.isNotEmpty && await canLaunch(videoUrl)) {
                      await launch(videoUrl);
                    } else {
                      throw 'Could not launch $videoUrl';
                    }
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
