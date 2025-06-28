import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/pubdev_package.dart';
import '../services/pubdev_service.dart';

class PubDevPage extends StatefulWidget {
  const PubDevPage({super.key});

  @override
  State<PubDevPage> createState() => _PubDevPageState();
}

class _PubDevPageState extends State<PubDevPage> {
  final PubDevService _pubDevService = PubDevService();
  List<PubDevPackage> packages = [];
  bool isLoading = true;
  String searchQuery = 'flutter';
  String sortBy = 'updated';
  final TextEditingController _searchController = TextEditingController();
  String? launchingUrl;

  @override
  void initState() {
    super.initState();
    _searchController.text = searchQuery;
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    setState(() => isLoading = true);
    try {
      final result = await _pubDevService.searchPackages(
        query: searchQuery,
        sort: sortBy,
      );
      setState(() {
        packages = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading packages: $e')),
        );
      }
    }
  }

  void _onSearch() {
    searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      _loadPackages();
    }
  }

  void _onSortChanged(String? newSort) {
    if (newSort != null && newSort != sortBy) {
      setState(() => sortBy = newSort);
      _loadPackages();
    }
  }

  void _launchPackageUrl(String url) async {
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
            content: Text('Opening pub.dev package...'),
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
                'Could not open pub.dev page. Please check your internet connection.'),
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

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Flutter packages...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (_) => _onSearch(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _onSearch,
                child: const Text('Search'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Sort by: ',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              DropdownButton<String>(
                value: sortBy,
                onChanged: _onSortChanged,
                items: const [
                  DropdownMenuItem(
                      value: 'updated', child: Text('Recently Updated')),
                  DropdownMenuItem(value: 'top', child: Text('Overall Score')),
                  DropdownMenuItem(value: 'like', child: Text('Most Liked')),
                  DropdownMenuItem(value: 'points', child: Text('Pub Points')),
                  DropdownMenuItem(
                      value: 'downloads', child: Text('Downloads')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(PubDevPackage package) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: () => _launchPackageUrl(package.pubDevUrl),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with package name and badges
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              package.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '^${package.version}',
                                style: const TextStyle(
                                    fontSize: 12, fontFamily: 'monospace'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (package.publisher != null)
                          Row(
                            children: [
                              if (package.isVerifiedPublisher) ...[
                                const Icon(Icons.verified,
                                    size: 16, color: Colors.green),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                package.publisher!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  if (package.hasScreenshot)
                    const Icon(Icons.photo_library,
                        color: Colors.blue, size: 20),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                package.description,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Metrics row
              Row(
                children: [
                  _buildMetric(
                      Icons.favorite, package.likes.toString(), Colors.red),
                  const SizedBox(width: 16),
                  _buildMetric(
                    Icons.stars,
                    package.pubPoints.toString(),
                    package.pubPointsColor,
                  ),
                  const SizedBox(width: 16),
                  _buildMetric(
                      Icons.download, package.formattedDownloads, Colors.green),
                ],
              ),

              const SizedBox(height: 12),

              // Badges and platforms
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (package.isDart3Compatible)
                    _buildBadge('Dart 3', Colors.blue),
                  if (package.isRecentlyCreated)
                    _buildBadge('New!', Colors.orange),
                  if (package.license != null)
                    _buildBadge(package.license!, Colors.grey),
                  ...package.supportedSdks
                      .map((sdk) => _buildBadge(sdk, Colors.purple)),
                ],
              ),

              if (package.supportedPlatforms.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Platforms: ${package.platformsText}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],

              if (package.topics.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: package.topics
                      .take(5)
                      .map((topic) => Chip(
                            label: Text('#$topic'),
                            backgroundColor: Colors.blue.shade50,
                            labelStyle: const TextStyle(fontSize: 11),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ))
                      .toList(),
                ),
              ],

              const SizedBox(height: 8),

              // Footer with date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (package.isRecentlyCreated &&
                      package.recentlyCreatedText != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Added ${package.recentlyCreatedText}',
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    )
                  else
                    const SizedBox(),
                  Text(
                    'Updated ${package.publishedDate}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: Color.fromRGBO(
            (color.red * 0.7).round(),
            (color.green * 0.7).round(),
            (color.blue * 0.7).round(),
            1.0,
          ),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : packages.isEmpty
                  ? const Center(
                      child: Text(
                        'No packages found.\nTry a different search term.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadPackages,
                      child: ListView.builder(
                        itemCount: packages.length,
                        itemBuilder: (context, index) =>
                            _buildPackageCard(packages[index]),
                      ),
                    ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
