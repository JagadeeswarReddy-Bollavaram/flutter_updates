import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class RedditPage extends StatefulWidget {
  const RedditPage({super.key});

  @override
  State<RedditPage> createState() => _RedditPageState();
}

class _RedditPageState extends State<RedditPage> {
  List<dynamic> posts = [];
  bool isLoading = true;
  String? launchingUrl;

  @override
  void initState() {
    super.initState();
    fetchTopPosts();
  }

  Future<void> fetchTopPosts() async {
    setState(() => isLoading = true);
    final url = Uri.parse(
      'https://www.reddit.com/r/FlutterDev/top.json?t=week&limit=15',
    );

    try {
      final response = await http.get(url,
          headers: {'User-Agent': 'flutter_reddit_client/1.0 by yourusername'});

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final children = json['data']['children'] as List;
        setState(() {
          posts = children.map((e) => e['data']).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading Reddit posts: $e')),
        );
      }
    }
  }

  void _launchRedditPost(String permalink) async {
    final url = 'https://www.reddit.com$permalink';
    final uri = Uri.parse(url);

    // Show loading feedback
    setState(() => launchingUrl = url);

    try {
      // Try external application first
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to platform default
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening Reddit post...'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      debugPrint("Could not launch $url: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Could not open Reddit post. Please check your internet connection.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      // Clear loading state
      if (mounted) {
        setState(() => launchingUrl = null);
      }
    }
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    final author = post['author'] ?? '';
    final title = post['title'] ?? '';
    final permalink = post['permalink'] ?? '';
    final imageUrl = post['preview']?['images']?[0]?['source']?['url']
        ?.replaceAll('&amp;', '&');

    final ups = post['ups'] ?? 0;
    final downs = post['downs'] ?? 0;
    final score = post['score'] ?? 0;
    final upvoteRatio = post['upvote_ratio'] ?? 0.0;
    final comments = post['num_comments'] ?? 0;
    final visited = post['visited'] ?? false;
    final createdUtc = post['created_utc'] ?? 0;
    final flair = post['link_flair_text'];

    final date =
        DateTime.fromMillisecondsSinceEpoch((createdUtc * 1000).toInt());
    final formattedDate = DateFormat('yyyy-MM-dd – HH:mm').format(date);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      child: InkWell(
        onTap: () => _launchRedditPost(permalink),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top: Author & Flair
              Row(
                children: [
                  Text('u/$author', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(width: 10),
                  if (flair != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(flair, style: const TextStyle(fontSize: 12)),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              // Image if available
              if (imageUrl != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              // Footer: Metadata
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.arrow_upward,
                          size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text('$ups'),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_downward,
                          size: 16, color: Colors.blueGrey),
                      const SizedBox(width: 4),
                      Text('$downs'),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('$score'),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.comment, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('$comments'),
                      const SizedBox(width: 10),
                      Icon(
                        visited ? Icons.visibility : Icons.visibility_off,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Upvote Ratio: ${(upvoteRatio * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(formattedDate,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : posts.isEmpty
            ? const Center(
                child: Text(
                  'No posts found.\nPull to refresh.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              )
            : RefreshIndicator(
                onRefresh: fetchTopPosts,
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (_, index) => _buildPostCard(posts[index]),
                ),
              );
  }
}
