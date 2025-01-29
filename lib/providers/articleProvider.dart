import 'package:flutter/material.dart';
import 'package:smart_content_recommendation_application/content/services/contentService.dart';


class ArticleProvider with ChangeNotifier {
  final ContentService _contentService = ContentService();
  List<Map<String, String>>? _articles;
  String? _currentQuery;

  List<Map<String, String>>? get articles => _articles;

  Future<void> fetchArticles(String query) async {
    if (query != _currentQuery || _articles == null) {
      _currentQuery = query;

      try {
        final fetchedArticles = await _contentService.fetchArticles(query);
        print("Fetched Articles: $fetchedArticles"); // Debugging

        _articles = fetchedArticles;
        notifyListeners();
      } catch (e) {
        print("Error fetching articles: $e");
      }
    }
  }
}
