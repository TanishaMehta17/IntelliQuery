import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_content_recommendation_application/global_variable.dart';

class ContentService {
  Future<List<dynamic>> fetchImage(String query) async {
    final response = await http.post(
      Uri.parse('$uri/content/images'),
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
      Uri.parse('$uri/content/videos'),
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
      Uri.parse('$uri/content/articles'),
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

  Future<void> saveQuery(String query, String userId) async {
  final response = await http.post(
    Uri.parse('$uri/query/query'),
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

 Future<void> downloadImage(BuildContext context, String imageUrl) async {
    // Request storage permission
    PermissionStatus permissionStatus = await Permission.storage.request();

    if (permissionStatus.isGranted) {
      try {
        // Get the directory to save the image
        final appDocDir = await getApplicationDocumentsDirectory();
        final savePath = '${appDocDir.path}/downloaded_image.jpg';

        // Start downloading the image
        Dio dio = Dio();
        Response response = await dio.get(
          imageUrl,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) => status! < 500,
          ),
        );

        // Save the image to the file
        File file = File(savePath);
        await file.writeAsBytes(response.data);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image downloaded successfully!')),
        );
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download image: $e')),
        );
      }
    } else {
      // If permission is not granted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission is required to download images')),
      );
    }
  }

 

}
