import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import '../models/content_item.dart';

class MediumService {
  // Medium RSS feeds for Flutter-related publications
  static const List<String> flutterRssFeeds = [
    'https://medium.com/feed/tag/flutter',
    'https://medium.com/feed/flutter-community',
    'https://medium.com/feed/flutter',
    'https://medium.com/feed/@flutter',
  ];

  Future<List<ContentItem>> searchFlutterArticles({
    String query = 'flutter',
    int maxResults = 20,
  }) async {
    try {
      final articles = <ContentItem>[];

      // Try to fetch from RSS feeds
      for (final feedUrl in flutterRssFeeds) {
        try {
          final feedArticles = await _fetchFromRssFeed(feedUrl, maxResults);
          articles.addAll(feedArticles);

          if (articles.length >= maxResults) {
            break;
          }
        } catch (e) {
          debugPrint('Error fetching from $feedUrl: $e');
          continue;
        }
      }

      // If RSS feeds fail, return mock data
      if (articles.isEmpty) {
        return _getMockFlutterArticles();
      }

      // Filter by query if provided
      if (query.isNotEmpty && query.toLowerCase() != 'flutter') {
        articles.removeWhere((article) =>
            !article.title.toLowerCase().contains(query.toLowerCase()) &&
            !(article.description
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false));
      }

      // Sort by date (newest first)
      articles.sort((a, b) => (b.publishedDate ?? DateTime.now())
          .compareTo(a.publishedDate ?? DateTime.now()));

      return articles.take(maxResults).toList();
    } catch (e) {
      debugPrint('Error fetching Medium articles: $e');
      return _getMockFlutterArticles();
    }
  }

  Future<List<ContentItem>> _fetchFromRssFeed(
      String feedUrl, int maxResults) async {
    final response = await http.get(
      Uri.parse(feedUrl),
      headers: {
        'User-Agent': 'flutter_medium_client/1.0',
        'Accept': 'application/rss+xml, application/xml, text/xml',
      },
    );

    if (response.statusCode == 200) {
      return _parseRssFeed(response.body, maxResults);
    } else {
      throw Exception('Failed to fetch RSS feed: ${response.statusCode}');
    }
  }

  List<ContentItem> _parseRssFeed(String xmlContent, int maxResults) {
    final articles = <ContentItem>[];
    try {
      final document = xml.XmlDocument.parse(xmlContent);
      final items = document.findAllElements('item');
      for (final item in items) {
        final title = item.getElement('title')?.text ?? '';
        final description = item.getElement('description')?.text ?? '';
        final link = item.getElement('link')?.text ?? '';
        final author = item.getElement('dc:creator')?.text ?? '';
        final pubDateStr = item.getElement('pubDate')?.text ?? '';
        DateTime? pubDate;
        try {
          pubDate = pubDateStr.isNotEmpty ? DateTime.parse(pubDateStr) : null;
        } catch (_) {
          pubDate = null;
        }
        final image = item.findElements('media:content').isNotEmpty
            ? item.findElements('media:content').first.getAttribute('url')
            : null;

        final article = ContentItem(
          id: link.hashCode.toString(),
          title: title,
          description: description,
          author: author,
          publishedDate: pubDate,
          url: link,
          platform: ContentPlatform.medium,
          type: ContentType.post,
          metrics: {
            'readingTime': _estimateReadingTime(description),
            'claps': 0,
            'responses': 0,
          },
          tags: _extractTags(description),
          thumbnailUrl: image,
          platformSpecificData: {
            'id': link.hashCode.toString(),
            'title': title,
            'description': description,
            'author': author,
            'publishedAt': pubDateStr,
            'link': link,
            'image': image,
            'readingTime': _estimateReadingTime(description),
            'claps': 0,
            'responses': 0,
            'tags': _extractTags(description),
          },
        );
        articles.add(article);
        if (articles.length >= maxResults) break;
      }
    } catch (e) {
      debugPrint('Error parsing RSS feed: $e');
    }
    return articles;
  }

  int _estimateReadingTime(String? content) {
    if (content == null || content.isEmpty) return 3;
    final wordCount = content.split(' ').length;
    return (wordCount / 200).ceil(); // Average reading speed: 200 words/minute
  }

  List<String> _extractTags(String? content) {
    if (content == null || content.isEmpty) return [];

    final tags = <String>[];
    final flutterKeywords = [
      'flutter',
      'dart',
      'mobile',
      'app',
      'development',
      'ui',
      'widget',
      'state',
      'provider',
      'bloc',
      'riverpod',
      'firebase',
      'api',
      'tutorial',
      'guide',
      'tips',
      'tricks',
      'best practices'
    ];

    final lowerContent = content.toLowerCase();
    for (final keyword in flutterKeywords) {
      if (lowerContent.contains(keyword)) {
        tags.add(keyword);
      }
    }

    return tags.take(5).toList(); // Limit to 5 tags
  }

  List<ContentItem> _getMockFlutterArticles() {
    return [
      ContentItem.fromMedium({
        'id': 'm1',
        'title': 'Building a Beautiful Flutter App with Material Design 3',
        'description':
            'Learn how to create stunning Flutter applications using the latest Material Design 3 guidelines. This comprehensive guide covers everything from basic widgets to advanced animations.',
        'author': 'Flutter Team',
        'publishedAt':
            DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        'link': 'https://medium.com/flutter/building-beautiful-apps',
        'image':
            'https://via.placeholder.com/800x400/00D4AA/FFFFFF?text=Material+Design+3',
        'readingTime': 8,
        'claps': 245,
        'responses': 12,
        'tags': ['flutter', 'material-design', 'ui', 'tutorial'],
      }),
      ContentItem.fromMedium({
        'id': 'm2',
        'title': 'State Management in Flutter: A Complete Guide to Provider',
        'description':
            'Master state management in Flutter using the Provider package. This article covers everything from basic state management to complex app architectures.',
        'author': 'Flutter Community',
        'publishedAt':
            DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
        'link':
            'https://medium.com/flutter-community/state-management-provider',
        'image':
            'https://via.placeholder.com/800x400/FF6B6B/FFFFFF?text=State+Management',
        'readingTime': 12,
        'claps': 189,
        'responses': 8,
        'tags': ['flutter', 'provider', 'state-management', 'architecture'],
      }),
      ContentItem.fromMedium({
        'id': 'm3',
        'title': 'Flutter Performance Optimization: 10 Tips for Better Apps',
        'description':
            'Discover proven techniques to optimize your Flutter app performance. From widget optimization to memory management, learn how to make your apps faster.',
        'author': 'Flutter Dev',
        'publishedAt':
            DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
        'link': 'https://medium.com/flutter-dev/performance-optimization',
        'image':
            'https://via.placeholder.com/800x400/4ECDC4/FFFFFF?text=Performance',
        'readingTime': 15,
        'claps': 312,
        'responses': 23,
        'tags': ['flutter', 'performance', 'optimization', 'tips'],
      }),
      ContentItem.fromMedium({
        'id': 'm4',
        'title': 'Integrating Firebase with Flutter: A Step-by-Step Guide',
        'description':
            'Learn how to integrate Firebase services into your Flutter app. This guide covers authentication, database, storage, and analytics.',
        'author': 'Firebase Team',
        'publishedAt':
            DateTime.now().subtract(Duration(days: 7)).toIso8601String(),
        'link': 'https://medium.com/firebase/flutter-integration',
        'image':
            'https://via.placeholder.com/800x400/FFA726/FFFFFF?text=Firebase+Flutter',
        'readingTime': 10,
        'claps': 156,
        'responses': 6,
        'tags': ['flutter', 'firebase', 'backend', 'authentication'],
      }),
      ContentItem.fromMedium({
        'id': 'm5',
        'title': 'Flutter Testing: Unit, Widget, and Integration Tests',
        'description':
            'Comprehensive guide to testing Flutter applications. Learn how to write effective unit tests, widget tests, and integration tests.',
        'author': 'Flutter Testing Expert',
        'publishedAt':
            DateTime.now().subtract(Duration(days: 10)).toIso8601String(),
        'link': 'https://medium.com/flutter/testing-guide',
        'image':
            'https://via.placeholder.com/800x400/9C27B0/FFFFFF?text=Testing',
        'readingTime': 18,
        'claps': 278,
        'responses': 15,
        'tags': ['flutter', 'testing', 'unit-tests', 'widget-tests'],
      }),
    ];
  }
}
