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

 Future<String?> uploadFile(File selectedFile) async {
    try {
      Dio dio = Dio();
      String fileName = selectedFile.path.split('/').last;

      // Step 1: Request Pre-Signed URL from Backend
      final presignedResponse = await dio.post(
        "$uri/api/file/presigned-url",
        data: {"fileName": fileName},
      );

      if (presignedResponse.statusCode != 200 || 
          presignedResponse.data["url"] == null) {
        throw Exception("Failed to get pre-signed URL.");
      }

      String presignedUrl = presignedResponse.data["url"];
      String fileUrl = presignedResponse.data["fileUrl"]; // S3 URL

      // Step 2: Upload the File to S3
      final s3Response = await dio.put(
        presignedUrl,
        data: selectedFile.openRead(),
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
        }),
      );

      if (s3Response.statusCode != 200) {
        throw Exception("Failed to upload to S3.");
      }

      // Step 3: Notify Backend about Uploaded File URL
      final backendResponse = await dio.post(
        "$uri/api/file/save",
        data: {"fileUrl": fileUrl},
      );

      if (backendResponse.statusCode == 200) {
        return backendResponse.data["summary"] ?? "No summary available.";
      } else {
        return backendResponse.data["error"] ?? "Error in processing.";
      }
    } catch (e) {
      print("Upload Failed: $e");
      return "Error: Something went wrong!";
    }
  }

}
