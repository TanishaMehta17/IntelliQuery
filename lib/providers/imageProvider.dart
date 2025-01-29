import 'package:flutter/material.dart';
import 'package:smart_content_recommendation_application/content/services/contentService.dart';

class ImagesProvider with ChangeNotifier {
  final ContentService _contentService = ContentService();
  List<dynamic>? _images;
  String? _currentQuery;

  List<dynamic>? get images => _images;

  Future<void> fetchImages(String query) async {
    if (query != _currentQuery || _images == null) {
      _currentQuery = query;

      try {
        final fetchedImages = await _contentService.fetchImage(query);
        print("Fetched Images: $fetchedImages"); // Debugging

        _images = fetchedImages;
        notifyListeners();
      } catch (e) {
        print("Error fetching images: $e");
      }
    }
  }
}
