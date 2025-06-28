import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/content_item.dart';

class YouTubeService {
  static const String apiKey =
      'YOUR_YOUTUBE_API_KEY'; // You'll need to get this from Google Cloud Console
  static const String baseUrl = 'https://www.googleapis.com/youtube/v3';

  Future<List<ContentItem>> searchFlutterVideos({
    String query = 'flutter tutorial',
    int maxResults = 20,
    String order = 'relevance', // relevance, date, rating, viewCount
  }) async {
    if (apiKey == 'YOUR_YOUTUBE_API_KEY') {
      // Return mock data for demo purposes
      return _getMockFlutterVideos();
    }

    final url = Uri.parse(
        '$baseUrl/search?part=snippet&q=$query&type=video&maxResults=$maxResults&order=$order&key=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final items = json['items'] as List;

        // Get video details for each video
        final videoIds = items.map((item) => item['id']['videoId']).join(',');
        final detailsUrl = Uri.parse(
            '$baseUrl/videos?part=statistics,contentDetails&id=$videoIds&key=$apiKey');

        final detailsResponse = await http.get(detailsUrl);
        final detailsJson = jsonDecode(detailsResponse.body);
        final detailsItems = detailsJson['items'] as List;

        final videos = <ContentItem>[];
        for (int i = 0; i < items.length; i++) {
          final item = items[i] as Map<String, dynamic>;
          final details = detailsItems[i] as Map<String, dynamic>;

          final videoData = <String, dynamic>{
            ...item,
            'statistics': details['statistics'],
            'duration': details['contentDetails']['duration'],
          };

          videos.add(ContentItem.fromYouTube(videoData));
        }

        return videos;
      } else {
        throw Exception(
            'Failed to load YouTube videos: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching YouTube videos: $e');
      // Return mock data on error
      return _getMockFlutterVideos();
    }
  }

  List<ContentItem> _getMockFlutterVideos() {
    return [
      ContentItem.fromYouTube({
        'id': 'v1',
        'title': 'Flutter Tutorial for Beginners - Build Your First App',
        'description':
            'Learn Flutter from scratch and build your first mobile app in this comprehensive tutorial.',
        'channelTitle': 'Flutter Official',
        'publishedAt':
            DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
        'statistics': {
          'viewCount': '125000',
          'likeCount': '3200',
        },
        'duration': 'PT15M30S',
        'thumbnails': {
          'high': {
            'url':
                'https://via.placeholder.com/480x360/FF0000/FFFFFF?text=Flutter+Tutorial'
          },
        },
        'tags': ['flutter', 'tutorial', 'beginners'],
      }),
      ContentItem.fromYouTube({
        'id': 'v2',
        'title': 'Building a Real-Time Chat App with Flutter and Firebase',
        'description':
            'Step-by-step guide to create a chat application using Flutter and Firebase.',
        'channelTitle': 'Flutter Community',
        'publishedAt':
            DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
        'statistics': {
          'viewCount': '89000',
          'likeCount': '2100',
        },
        'duration': 'PT25M15S',
        'thumbnails': {
          'high': {
            'url':
                'https://via.placeholder.com/480x360/FF0000/FFFFFF?text=Chat+App'
          },
        },
        'tags': ['flutter', 'firebase', 'chat', 'real-time'],
      }),
      ContentItem.fromYouTube({
        'id': 'v3',
        'title': 'Flutter State Management with Provider - Complete Guide',
        'description':
            'Master state management in Flutter using the Provider package.',
        'channelTitle': 'Flutter Dev',
        'publishedAt':
            DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        'statistics': {
          'viewCount': '67000',
          'likeCount': '1800',
        },
        'duration': 'PT18M45S',
        'thumbnails': {
          'high': {
            'url':
                'https://via.placeholder.com/480x360/FF0000/FFFFFF?text=State+Management'
          },
        },
        'tags': ['flutter', 'provider', 'state-management'],
      }),
    ];
  }
}
