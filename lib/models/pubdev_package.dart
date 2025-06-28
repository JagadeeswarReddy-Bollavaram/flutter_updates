import 'package:flutter/material.dart';

class PubDevPackage {
  final String name;
  final String version;
  final String description;
  final int likes;
  final int pubPoints;
  final String downloads;
  final String publishedDate;
  final String? license;
  final String? publisher;
  final bool isVerifiedPublisher;
  final bool isDart3Compatible;
  final List<String> supportedPlatforms;
  final List<String> supportedSdks;
  final List<String> topics;
  final bool isRecentlyCreated;
  final String? recentlyCreatedText;
  final bool hasScreenshot;

  PubDevPackage({
    required this.name,
    required this.version,
    required this.description,
    required this.likes,
    required this.pubPoints,
    required this.downloads,
    required this.publishedDate,
    this.license,
    this.publisher,
    required this.isVerifiedPublisher,
    required this.isDart3Compatible,
    required this.supportedPlatforms,
    required this.supportedSdks,
    required this.topics,
    required this.isRecentlyCreated,
    this.recentlyCreatedText,
    required this.hasScreenshot,
  });

  String get pubDevUrl => 'https://pub.dev/packages/$name';

  String get formattedDownloads {
    if (downloads == '--') return 'New package';
    return downloads;
  }

  Color get pubPointsColor {
    if (pubPoints >= 150) return const Color(0xFF4CAF50); // Green
    if (pubPoints >= 100) return const Color(0xFFFF9800); // Orange
    return const Color(0xFFF44336); // Red
  }

  String get platformsText {
    if (supportedPlatforms.isEmpty) return 'No platforms specified';
    if (supportedPlatforms.length > 3) {
      return '${supportedPlatforms.take(3).join(', ')} +${supportedPlatforms.length - 3}';
    }
    return supportedPlatforms.join(', ');
  }
}
