import 'dart:convert';
// import 'dart:typed_data';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
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
        print(data); // Print the response for debugging

        // Ensure that the data is a List of maps
        return List<Map<String, dynamic>>.from(
            data.map((item) => item as Map<String, dynamic>));
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

  // Future<void> downloadImage(BuildContext context, String imageUrl) async {
  //   try {
  //     // Request storage permission for Android (not needed for Android 13+)
  //     if (await Permission.storage.request().isGranted ||
  //         await Permission.photos.request().isGranted) {
  //       // Download image bytes
  //       var response = await Dio().get(
  //         imageUrl,
  //         options: Options(responseType: ResponseType.bytes),
  //       );

  //       if (response.statusCode == 200) {
  //         Uint8List imageBytes = Uint8List.fromList(response.data);

  //         // Save to gallery
  //         final result = await ImageGallerySaver.saveImage(imageBytes);

  //         if (result != null) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text("Image saved to gallery!")),
  //           );
  //         } else {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text("Failed to save image!")),
  //           );
  //         }
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Storage permission denied")),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Download failed: $e")),
  //     );
  //   }
  // }

  Future<void> saveQuery(String query, String userId) async {
  final response = await http.post(
    Uri.parse('$uri/api/query/save-query'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'query': query,
      'userId': userId,
      'timeStamp': DateTime.now().toIso8601String(),
    }),
  );

  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}"); // Debugging

  if (response.statusCode == 201) {
    print('Query saved successfully');
  } else {
    throw Exception('Failed to save query: ${response.body}');
  }
}

}
