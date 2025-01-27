import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_content_recommendation_application/global_variable.dart';

class ContentService {
  
Future<List<dynamic>> fetchImage(String query) async {
  final response = await http.post(
    Uri.parse('$uri/api/content/images'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'query': query,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    // Ensure 'content' is treated as a List<dynamic>
    if (data is List) {
      return data; // Return the list directly
    } else {
      throw Exception('Unexpected response format: "content" is not a list.');
    }
  } else {
    throw Exception('Failed to load images');
  }
}

  // Future<List<dynamic>> fetchVideos(String query) async {
  //   final response = await http.post(
  //     Uri.parse('$uri/api/content/videos'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: json.encode({
  //       'query': query, // Send the query in the body as JSON
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     print(data['content']);
  //     return data['content']; // Extract the 'content' field
  //   } else {
  //     throw Exception('Failed to load articles');
  //   }
  // }

Future<List<Map<String, dynamic>>> fetchVideos(String query) async {
  final response = await http.post(
    Uri.parse('$uri/api/content/videos'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'query': query, // Send the query in the body as JSON
    }),
  );

  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(response.body);
      print(data);  // Print the response for debugging

      // Ensure that the data is a List of maps
      return List<Map<String, dynamic>>.from(data.map((item) => item as Map<String, dynamic>));
    } catch (e) {
      // Handle JSON parsing errors or other exceptions
      throw Exception('Failed to parse response: ${e.toString()}');
    }
  } else {
    // Handle HTTP errors
    throw Exception('Failed to load videos: ${response.statusCode}');
  }
}


  Future<List<Map<String, String>>> fetchArticles(String query) async {
  final response = await http.post(
    Uri.parse('$uri/api/content/articles'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'query': query,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    // Debugging
    print('Response Body: ${response.body}');
    print('Parsed Content: ${data['content']}');

    if (data['content'] is String) {
      // Wrap the single string content in a list of maps
      return [
        {'content': data['content']}
      ];
    } else {
      throw Exception('Unexpected "content" format: Not a String.');
    }
  } else {
    throw Exception('Failed to load articles');
  }
}



}
