import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_content_recommendation_application/content/services/contentService.dart';
import 'package:smart_content_recommendation_application/providers/queryProvider.dart';

class ArticleTab extends StatelessWidget {
  final ContentService contentService = ContentService();

  @override
  Widget build(BuildContext context) {
    final query = Provider.of<QueryProvider>(context).query;
    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print(query);
    return FutureBuilder<List<Map<String, String>>>(
      future: contentService.fetchArticles(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No articles found.'));
        }

        final articles = snapshot.data!;
        return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Card(
              child: ListTile(
                subtitle: Text(article['content'] ?? 'No summary available.'),
                onTap: () {
                  // Handle tap
                },
              ),
            );
          },
        );
      },
    );
  }
}
