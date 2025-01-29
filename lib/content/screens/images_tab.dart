import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_content_recommendation_application/content/services/contentService.dart';
import 'package:smart_content_recommendation_application/providers/imageProvider.dart';
import 'package:smart_content_recommendation_application/providers/queryProvider.dart';

class ImageTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final query = Provider.of<QueryProvider>(context).query;
    final imageProvider = Provider.of<ImagesProvider>(context);
   

    return FutureBuilder(
      future: imageProvider.fetchImages(query),
      builder: (context, snapshot) {
        final images = imageProvider.images ?? [];

        if (snapshot.connectionState == ConnectionState.waiting && images.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else if (images.isEmpty) {
          return Center(child: Text('No images found'));
        } else {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: EdgeInsets.all(10),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = images[index];
              return GestureDetector(
                onTap: () => _showFullImage(context, image),
                child: Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          image['smallImageUrl'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          image['description'] ?? 'No description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Photo by ${image['photographer']}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  // Function to show full-screen image with download button
  void _showFullImage(BuildContext context, Map<String, dynamic> image) {
     ContentService contentService = ContentService();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(image['imageUrl'], fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                image['description'] ?? 'No description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.download),
                  label: Text("Download"),
                  onPressed: () async {
    //
    //
    await  contentService.downloadImage(context, image['imageUrl']);
  },
                ),
                TextButton(
                  child: Text("Close"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}
