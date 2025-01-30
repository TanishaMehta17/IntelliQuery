import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_content_recommendation_application/content/services/contentService.dart';
import 'package:smart_content_recommendation_application/providers/homeProvider.dart';
import 'package:smart_content_recommendation_application/providers/userProvider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTab extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<String> hardcodedQueries = [
    'AI advancements and trends',
    'Current affairs in the world of AI',
    'Technology news AI',
    'Latest news in current affairs',
    'How AI is shaping the future',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      HomeProvider homeProvider =
          Provider.of<HomeProvider>(context, listen: false);
      homeProvider.fetchRecommendations(userProvider.user.id);

      // If recommendations are empty, set the hardcoded ones directly
      if (homeProvider.isEmpty) {
        homeProvider.setRecommendations(hardcodedQueries);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      body: _buildRecommendations(homeProvider.recommendations),
    );
  }

  Widget _buildRecommendations(List<String> recommendations) {
    ContentService contentService = ContentService();

    return ListView.builder(
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final query = recommendations[index];

        return FutureBuilder<List<dynamic>>(
          future: Future.wait([
            contentService
                .fetchImage(query), // Fetch image related to the query
            // contentService.fetchVideos(query), // Fetch
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error loading data"));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("No data available"));
            }

            final images = (snapshot.data![0] as List<dynamic>)
                .cast<Map<String, dynamic>>();
// final videos = (snapshot.data![1] as List<dynamic>)
//                // .cast<Map<String, dynamic>>();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(query,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    _buildImageGrid(images),
                    //  _buildVideoList(videos),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildImageGrid(List<Map<String, dynamic>> images) {
    return images.isEmpty
        ? Center(child: Text("No images available"))
        : GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: EdgeInsets.all(10),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = images[index];
              return Image.network(
                image['smallImageUrl'] ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          );
  }

  Widget _buildVideoList(List<Map<String, dynamic>> videos) {
    return videos.isEmpty
        ? Center(child: Text("No videos available"))
        : ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index] as Map<String, dynamic>;
              final videoUrl = video['videoUrl'] ?? '';
              final title = video['title'] ?? 'Untitled';
              final thumbnailUrl = getThumbnailUrl(videoUrl);

              return Card(
                child: ListTile(
                  leading: thumbnailUrl.isNotEmpty
                      ? Image.network(
                          thumbnailUrl,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.video_library, size: 50),
                  title: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    if (videoUrl.isNotEmpty && await canLaunch(videoUrl)) {
                      await launch(videoUrl);
                    } else {
                      throw 'Could not launch $videoUrl';
                    }
                  },
                ),
              );
            },
          );
  }

  String extractVideoId(String videoUrl) {
    final uri = Uri.tryParse(videoUrl);
    if (uri != null && uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v'] ?? '';
    }
    return '';
  }

  String getThumbnailUrl(String videoUrl) {
    final videoId = extractVideoId(videoUrl);
    return videoId.isNotEmpty
        ? 'https://img.youtube.com/vi/$videoId/0.jpg'
        : '';
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
