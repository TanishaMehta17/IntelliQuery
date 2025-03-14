import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_content_recommendation_application/global_variable.dart';
import 'package:provider/provider.dart';
import 'package:smart_content_recommendation_application/providers/userProvider.dart'; // Make sure to import provider

class HomeProvider extends ChangeNotifier {
  List<String> _recommendations = []; // Store only query strings
  bool _isEmpty = true;

  List<String> get recommendations => _recommendations;
  bool get isEmpty => _isEmpty;

  void setRecommendations(List<String> newRecommendations) {
    _recommendations = newRecommendations;
    _isEmpty = false; // When you set recommendations, it is no longer empty
    notifyListeners();
  }

  Future<void> fetchRecommendations(String userId) async {
    try {
      // Get userId from your user provider (assuming you have UserProvider)

      if (userId == null || userId.isEmpty) {
        print("User ID is not available.");
        return;
      }

      // Make the API call, passing the userId as a query parameter
      final response = await http.get(Uri.parse('$uri/api/recommendation/recommendation?userId=$userId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
       
        if (data['recommendations'] != null && data['recommendations'].isNotEmpty) {
          _recommendations = List<String>.from(data['recommendations']); // Store only queries
          _isEmpty = false; // We have data, so it's not empty
        } else {
          _isEmpty = true;
        }
      } else {
        _isEmpty = true;
      }
    } catch (e) {
      print("Error fetching recommendations: $e");
      _isEmpty = true;
    }
    notifyListeners();
  }
}
