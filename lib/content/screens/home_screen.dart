import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_content_recommendation_application/content/screens/article_tab.dart';
import 'package:smart_content_recommendation_application/content/screens/file_upload.dart';
import 'package:smart_content_recommendation_application/content/screens/home_Tab.dart';
import 'package:smart_content_recommendation_application/content/screens/images_tab.dart';
import 'package:smart_content_recommendation_application/content/screens/videos_tab.dart';
import 'package:smart_content_recommendation_application/content/services/contentService.dart';
import 'package:smart_content_recommendation_application/providers/queryProvider.dart';
import 'package:smart_content_recommendation_application/providers/userProvider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  final TextEditingController queryController =
      TextEditingController(); // Define the query controller

  void saveQuery(BuildContext context) {
    final query = queryController.text; // Get the current query
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;
    ContentService contentService = ContentService();
    contentService.saveQuery(query, userId); // Pass parameters to the method
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller:
                queryController, // Set the controller for the text field
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
            ),
            onSubmitted: (value) {
              saveQuery(context);
              Provider.of<QueryProvider>(context, listen: false)
                  .updateQuery(value);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                saveQuery(
                    context); // You can trigger search on button press too
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            HomeTab(),
            ImageTab(),
            ArticleTab(),
            VideoTab(),
            FileUploadScreen(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home), text: 'Home',),
            Tab(icon: Icon(Icons.image), text: 'Images'),
            Tab(icon: Icon(Icons.article), text: 'Articles'),
            Tab(icon: Icon(Icons.video_collection), text: 'Videos'),
            Tab(icon: Icon(Icons.file_copy),text: 'File',)
          ],
        ),
      ),
    );
  }
}
