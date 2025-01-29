import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_content_recommendation_application/providers/homeProvider.dart';

class HomeTab extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: homeProvider.isEmpty
          ? _buildEmptyState()
          : _buildRecommendations(homeProvider.recommendations),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No recommendations yet.",
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Text(
            "Displaying some random content related to AI and current affairs.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("Fetch Random Content"),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(List<RecommendationData> recommendations) {
    return ListView.builder(
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final data = recommendations[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Query: ${data.query}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildMediaSection(data),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMediaSection(RecommendationData data) {
    return Column(
      children: [
        _buildImageSection(data.images),
        _buildVideoSection(data.videos),
      ],
    );
  }

  Widget _buildImageSection(List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (images.isNotEmpty) ...[
          Text("Images:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ...images.map((url) => Image.network(url)).toList(),
        ]
      ],
    );
  }

  Widget _buildVideoSection(List<String> videos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (videos.isNotEmpty) ...[
          Text("Videos:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ]
      ],
    );
  }


  
}
