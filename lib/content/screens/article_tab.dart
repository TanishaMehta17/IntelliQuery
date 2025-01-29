import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_content_recommendation_application/chatGPT/chat_screen.dart';
import 'package:smart_content_recommendation_application/providers/articleProvider.dart';
import 'package:smart_content_recommendation_application/providers/queryProvider.dart';

class ArticleTab extends StatefulWidget {
  @override
  _ArticleTabState createState() => _ArticleTabState();
}

class _ArticleTabState extends State<ArticleTab> {
  late Future<void> _fetchArticlesFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final query = Provider.of<QueryProvider>(context, listen: false).query;
    final articleProvider =
        Provider.of<ArticleProvider>(context, listen: false);

    _fetchArticlesFuture = articleProvider.fetchArticles(query);
  }

  @override
  Widget build(BuildContext context) {
    final articleProvider = Provider.of<ArticleProvider>(context);

    return Scaffold(
      body: FutureBuilder<void>(
        future: _fetchArticlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final articles = articleProvider.articles;
          if (articles == null || articles.isEmpty) {
            return Center(child: Text('No articles found.'));
          }
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, ChatScreen.routeName);
        },
        child: Image.asset(
          'assets/images/logo.png',
          height: 28,
          width: 28,
        ),
      ),
    );
  }
}
