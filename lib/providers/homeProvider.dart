import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_content_recommendation_application/global_variable.dart';

class RecommendationData {
  final String query;
  final List<String> images;
  final List<String> videos;
  final List<String> articles;

  RecommendationData({
    required this.query,
    required this.images,
    required this.videos,
    required this.articles,
  });

  factory RecommendationData.fromJson(Map<String, dynamic> json) {
    return RecommendationData(
      query: json['query'],
      images: List<String>.from(json['images']),
      videos: List<String>.from(json['videos']),
      articles: List<String>.from(json['articles']),
    );
  }
}

class HomeProvider extends ChangeNotifier {
  List<RecommendationData> _recommendations = [];
  bool _isEmpty = true;

  List<RecommendationData> get recommendations => _recommendations;
  bool get isEmpty => _isEmpty;

  Future<void> fetchRecommendations() async {
    try {
      final response = await http.get(Uri.parse('$uri/api/recommendation/recommend'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['recommendations'].isEmpty) {
          _isEmpty = true;
        } else {
          _recommendations = (data['recommendations'] as List)
              .map((item) => RecommendationData.fromJson(item))
              .toList();
          _isEmpty = false;
        }
      } else {
        _isEmpty = true;
      }
    } catch (e) {
      _isEmpty = true;
    }
    notifyListeners();
  }

  void onNewQueryAdded() {
    fetchRecommendations();
  }
}
