import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import '../models/pubdev_package.dart';

class PubDevService {
  static const String baseUrl = 'https://pub.dev';

  Future<List<PubDevPackage>> searchPackages({
    String query = 'flutter',
    String sort = 'updated',
    int page = 1,
  }) async {
    final url = Uri.parse('$baseUrl/packages?q=$query&sort=$sort&page=$page');

    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'flutter_pubdev_client/1.0',
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        },
      );

      if (response.statusCode == 200) {
        return _parsePackagesFromHtml(response.body);
      } else {
        throw Exception('Failed to load packages: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching packages: $e');
      throw Exception('Network error: $e');
    }
  }

  List<PubDevPackage> _parsePackagesFromHtml(String html) {
    final packages = <PubDevPackage>[];

    // Split HTML by package items
    final packageSections = html.split('<div class="packages-item">');

    for (int i = 1; i < packageSections.length; i++) {
      try {
        final packageHtml = packageSections[i];
        final package = _parsePackageFromSection(packageHtml);
        if (package != null) {
          packages.add(package);
        }
      } catch (e) {
        debugPrint('Error parsing package: $e');
        // Continue with next package
      }
    }

    return packages;
  }

  PubDevPackage? _parsePackageFromSection(String html) {
    try {
      // Extract package name
      final nameMatch = RegExp(r'href="/packages/([^"]+)"').firstMatch(html);
      if (nameMatch == null) return null;
      final name = nameMatch.group(1)!;

      // Extract version
      final versionMatch =
          RegExp(r'copy "([^:]+): \^([^"]+)"').firstMatch(html);
      final version = versionMatch?.group(2) ?? 'unknown';

      // Extract description
      final descMatch = RegExp(r'<span>([^<]+)</span>').firstMatch(html);
      final description =
          descMatch?.group(1)?.trim() ?? 'No description available';

      // Extract metrics
      final likesMatch =
          RegExp(r'<span class="packages-score-value-number">(\d+)</span>')
              .firstMatch(html);
      final likes = int.tryParse(likesMatch?.group(1) ?? '0') ?? 0;

      final pointsMatches =
          RegExp(r'<span class="packages-score-value-number">(\d+)</span>')
              .allMatches(html)
              .toList();
      final pubPoints = pointsMatches.length >= 2
          ? int.tryParse(pointsMatches[1].group(1) ?? '0') ?? 0
          : 0;

      final downloadsMatches =
          RegExp(r'<span class="packages-score-value-number">([^<]+)</span>')
              .allMatches(html)
              .toList();
      final downloads = downloadsMatches.length >= 3
          ? downloadsMatches[2].group(1)?.trim() ?? '--'
          : '--';

      // Extract license
      final licenseMatch =
          RegExp(r'<img[^>]*/>([^<]*)</span>').firstMatch(html);
      final license = licenseMatch?.group(1)?.trim();

      // Extract publisher
      final publisherMatch =
          RegExp(r'<a href="/publishers/([^"]+)">').firstMatch(html);
      final publisher = publisherMatch?.group(1);
      final isVerifiedPublisher = html.contains('verified publisher');

      // Extract date
      final dateMatch =
          RegExp(r'\(([^)]+ago|in the last hour)\)').firstMatch(html);
      final publishedDate = dateMatch?.group(1) ?? 'Unknown';

      // Extract compatibility and features
      final isDart3Compatible = html.contains('Dart 3 compatible');
      final isRecentlyCreated = html.contains('recently created package');
      final recentlyCreatedMatch =
          RegExp(r'Added <b>([^<]+)</b>').firstMatch(html);
      final recentlyCreatedText = recentlyCreatedMatch?.group(1);
      final hasScreenshot = html.contains('screenshot');

      // Extract supported platforms
      final platformMatches = RegExp(
              r'title="Packages compatible with ([^"]+) platform">([^<]+)</a>')
          .allMatches(html);
      final supportedPlatforms =
          platformMatches.map((m) => m.group(2)!).toList();

      // Extract supported SDKs
      final sdkMatches =
          RegExp(r'title="Packages compatible with ([^"]+) SDK">([^<]+)</a>')
              .allMatches(html);
      final supportedSdks = sdkMatches.map((m) => m.group(2)!).toList();

      // Extract topics
      final topicMatches =
          RegExp(r'class="topics-tag"[^>]*>#([^<]+)</a>').allMatches(html);
      final topics = topicMatches.map((m) => m.group(1)!).toList();

      return PubDevPackage(
        name: name,
        version: version,
        description: description,
        likes: likes,
        pubPoints: pubPoints,
        downloads: downloads,
        publishedDate: publishedDate,
        license: license,
        publisher: publisher,
        isVerifiedPublisher: isVerifiedPublisher,
        isDart3Compatible: isDart3Compatible,
        supportedPlatforms: supportedPlatforms,
        supportedSdks: supportedSdks,
        topics: topics,
        isRecentlyCreated: isRecentlyCreated,
        recentlyCreatedText: recentlyCreatedText,
        hasScreenshot: hasScreenshot,
      );
    } catch (e) {
      debugPrint('Error parsing package section: $e');
      return null;
    }
  }
}
