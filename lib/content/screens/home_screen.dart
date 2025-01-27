import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smart_content_recommendation_application/content/screens/article_tab.dart';
import 'package:smart_content_recommendation_application/content/screens/images_tab.dart';
import 'package:smart_content_recommendation_application/content/screens/videos_tab.dart';
import 'package:smart_content_recommendation_application/global_variable.dart';
import 'package:smart_content_recommendation_application/providers/queryProvider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
            ),
            onSubmitted: (value) {
              Provider.of<QueryProvider>(context, listen: false).updateQuery(value);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Trigger search if needed
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            ImageTab(), // Home screen (default)
            ArticleTab(),
            VideoTab(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.image), text: 'Images'),
            Tab(icon: Icon(Icons.article), text: 'Articles'),
            Tab(icon: Icon(Icons.video_collection), text: 'Videos'),
          ],
        ),
      ),
    );
  }
}
