import 'package:flutter/material.dart';

enum ContentPlatform {
  reddit,
  pubdev,
  medium,
  youtube,
  github,
  linkedin,
  twitter,
}

enum ContentType {
  post, // Reddit posts, Medium articles
  package, // pub.dev packages
  video, // YouTube videos
  repository, // GitHub repos
  job, // LinkedIn jobs
  tweet, // Twitter posts
}

class ContentItem {
  final String id;
  final String title;
  final String? description;
  final String? author;
  final String? authorAvatar;
  final DateTime? publishedDate;
  final String? url;
  final ContentPlatform platform;
  final ContentType type;
  final Map<String, dynamic> metrics;
  final List<String> tags;
  final String? thumbnailUrl;
  final Map<String, dynamic> platformSpecificData;

  ContentItem({
    required this.id,
    required this.title,
    this.description,
    this.author,
    this.authorAvatar,
    this.publishedDate,
    this.url,
    required this.platform,
    required this.type,
    this.metrics = const {},
    this.tags = const [],
    this.thumbnailUrl,
    this.platformSpecificData = const {},
  });

  // Helper getters for common metrics
  int get likes => metrics['likes'] ?? 0;
  int get views => metrics['views'] ?? 0;
  int get comments => metrics['comments'] ?? 0;
  int get shares => metrics['shares'] ?? 0;

  // Medium-specific getters
  int get readingTime => metrics['readingTime'] ?? 0;
  int get claps => metrics['claps'] ?? 0;
  int get responses => metrics['responses'] ?? 0;

  String get formattedDate {
    if (publishedDate == null) return 'Unknown';
    final now = DateTime.now();
    final difference = now.difference(publishedDate!);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Platform-specific icons
  IconData get platformIcon {
    switch (platform) {
      case ContentPlatform.reddit:
        return Icons.reddit;
      case ContentPlatform.pubdev:
        return Icons.developer_board;
      case ContentPlatform.medium:
        return Icons.article;
      case ContentPlatform.youtube:
        return Icons.play_circle;
      case ContentPlatform.github:
        return Icons.code;
      case ContentPlatform.linkedin:
        return Icons.work;
      case ContentPlatform.twitter:
        return Icons.flutter_dash;
    }
  }

  // Platform-specific colors
  Color get platformColor {
    switch (platform) {
      case ContentPlatform.reddit:
        return Colors.orange;
      case ContentPlatform.pubdev:
        return Colors.blue;
      case ContentPlatform.medium:
        return Colors.green;
      case ContentPlatform.youtube:
        return Colors.red;
      case ContentPlatform.github:
        return Colors.black;
      case ContentPlatform.linkedin:
        return Colors.blue.shade700;
      case ContentPlatform.twitter:
        return Colors.lightBlue;
    }
  }

  // Factory constructors for different platforms
  factory ContentItem.fromReddit(Map<String, dynamic> data) {
    return ContentItem(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['selftext'],
      author: data['author'],
      publishedDate: DateTime.fromMillisecondsSinceEpoch(
        (data['created_utc'] ?? 0) * 1000,
      ),
      url: 'https://www.reddit.com${data['permalink']}',
      platform: ContentPlatform.reddit,
      type: ContentType.post,
      metrics: {
        'likes': data['ups'] ?? 0,
        'comments': data['num_comments'] ?? 0,
        'upvoteRatio': data['upvote_ratio'] ?? 0.0,
      },
      tags: [data['link_flair_text']].whereType<String>().toList(),
      thumbnailUrl: data['preview']?['images']?[0]?['source']?['url']
          ?.replaceAll('&amp;', '&'),
      platformSpecificData: data,
    );
  }

  factory ContentItem.fromPubDev(Map<String, dynamic> data) {
    return ContentItem(
      id: data['name'] ?? '',
      title: data['name'] ?? '',
      description: data['description'] ?? '',
      author: data['publisher'],
      publishedDate: DateTime.now(), // pub.dev doesn't provide exact date
      url: 'https://pub.dev/packages/${data['name']}',
      platform: ContentPlatform.pubdev,
      type: ContentType.package,
      metrics: {
        'likes': data['likes'] ?? 0,
        'pubPoints': data['pubPoints'] ?? 0,
        'downloads': data['downloads'] ?? '--',
      },
      tags: data['topics'] ?? [],
      platformSpecificData: data,
    );
  }

  factory ContentItem.fromYouTube(Map<String, dynamic> data) {
    return ContentItem(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      author: data['channelTitle'],
      authorAvatar: data['thumbnails']?['default']?['url'],
      publishedDate: DateTime.parse(
          data['publishedAt'] ?? DateTime.now().toIso8601String()),
      url: 'https://www.youtube.com/watch?v=${data['id']}',
      platform: ContentPlatform.youtube,
      type: ContentType.video,
      metrics: {
        'views': int.tryParse(data['statistics']?['viewCount'] ?? '0') ?? 0,
        'likes': int.tryParse(data['statistics']?['likeCount'] ?? '0') ?? 0,
        'duration': data['duration'],
      },
      tags: data['tags'] ?? [],
      thumbnailUrl: data['thumbnails']?['high']?['url'],
      platformSpecificData: data,
    );
  }

  factory ContentItem.fromMedium(Map<String, dynamic> data) {
    return ContentItem(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      author: data['author']?['name'],
      authorAvatar: data['author']?['image'],
      publishedDate: DateTime.parse(
          data['publishedAt'] ?? DateTime.now().toIso8601String()),
      url: data['link'] ?? '',
      platform: ContentPlatform.medium,
      type: ContentType.post,
      metrics: {
        'readingTime': data['readingTime'] ?? 0,
        'claps': data['claps'] ?? 0,
        'responses': data['responses'] ?? 0,
      },
      tags: data['tags'] ?? [],
      thumbnailUrl: data['image'],
      platformSpecificData: data,
    );
  }
}
