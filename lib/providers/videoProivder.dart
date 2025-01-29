import 'package:flutter/material.dart';
import 'package:smart_content_recommendation_application/content/services/contentService.dart';

class VideoProvider with ChangeNotifier {
  final ContentService _contentService = ContentService();
  List<dynamic>? _videos;
  String? _currentQuery;

  List<dynamic>? get videos => _videos;

  Future<void> fetchVideos(String query) async {
    if (query != _currentQuery || _videos == null) {
      _currentQuery = query;

      try {
        final fetchedVideos = await _contentService.fetchVideos(query);
        print("Fetched Videos: $fetchedVideos"); // Debugging

        _videos = fetchedVideos;
        notifyListeners();
      } catch (e) {
        print("Error fetching videos: $e");
      }
    }
  }
}
