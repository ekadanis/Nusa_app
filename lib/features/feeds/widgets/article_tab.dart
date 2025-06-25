import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/features/feeds/widgets/build_category_name.dart';
import 'package:nusa_app/models/article_model.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:nusa_app/services/firestore_service.dart';
import 'package:nusa_app/util/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/fetch_news.dart';

class ArticleTab extends StatefulWidget {
  const ArticleTab({super.key});

  @override
  State<ArticleTab> createState() => _ArticleTabState();
}

class _ArticleTabState extends State<ArticleTab> {
  List<NewsArticle> _articles = [];
  List<NewsArticle> _featuredArticles = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = "Discover";

  final Map<String, String> _categoryMap = {
    "Discover": "",
    "Cultural Sites": "indonesian cultural sites",
    "Local Foods": "indonesian foods",
    "Traditional Wear": "indonesian traditional wear",
    "Arts & Culture": "indonesian art and culture",
    "Folk Instruments": "indonesian instruments",
    "Crafts & Artifacts": "indonesian crafts and artifacts"
  };

  @override
  void initState() {
    super.initState();
    _fetchArticles();
    _fetchFeaturedArticles();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchArticles,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildFeaturedCardsSection(context)),
          SliverToBoxAdapter(child: _buildCategoryChipsSection()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildArticleItem(context, _articles[index]),
              childCount: _articles.length,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    await _fetchArticles();
    await _fetchFeaturedArticles();
  }

  Future<void> _showOpenLinkConfirmation(BuildContext context, String url) async {
    final shouldOpen = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Open Article"),
        content: const Text("Do you want to visit the original page?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel", style: context.textTheme.labelLarge?.copyWith(
    color: AppColors.primary50,
    fontWeight: FontWeight.bold,
    ))
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(15)
            ),
            child:
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Visit", style: context.textTheme.labelLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              )),
            ),
          )
        ],
      ),
    );

    if (shouldOpen == true) {
      try {
        print("\n\nLINK ARTICLE: <<<${url}\n\n");
        if (await canLaunchUrl(Uri.parse(url))) {
          final launched = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication); // Added mode
          if (!launched) {
            throw 'Could not launch $url'; // This should now provide a more specific error
          }
        } else {
          throw 'Invalid URL: $url or no app to handle it.'; // More detailed message
        }
      } catch (e) {
        debugPrint('Error launching URL: $e'); // Use debugPrint for development
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Tidak bisa membuka link artikel: $e")), // Show the error in the SnackBar
          );
        }
      }
    }
  }

  Future<void> _fetchArticles({String? categoryId}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final query = categoryId?.isNotEmpty == true ? categoryId! : 'indonesia culture';
      print("\n\n<<<QUERY: ${query}\n\n");
      final articles = await fetchIndonesianCultureNews(query: query);

      setState(() {
        _articles = articles;
        _isLoading = false;
      });

      debugPrint('✅ Loaded ${articles.length} articles for $query');
    } catch (e) {
      debugPrint('❌ Error fetching articles: $e');
      setState(() {
        _error = "Failed to load articles: $e";
        _isLoading = false;
      });
    }
  }


  Future<void> _fetchFeaturedArticles() async {
    try {
      final featuredArticles = await fetchFeaturedNewsArticles();

      setState(() {
        _featuredArticles = featuredArticles.take(5).toList();
      });

      debugPrint('✅ Loaded ${_featuredArticles.length} featured articles');
    } catch (e) {
      debugPrint('❌ Error fetching featured articles: $e');
      setState(() {
        _featuredArticles = [];
      });
    }
  }

    Future<List<NewsArticle>> fetchFeaturedNewsArticles() async {
    return await fetchIndonesianCultureNews();
  }

  Future<void> _onCategorySelectedAndFetch(String label) async {
    if (_selectedCategory == label) return;

    setState(() {
      _selectedCategory = label;
    });

    final categoryId = _categoryMap[label];
    await _fetchArticles(categoryId: categoryId);
  }

  Widget _buildFeaturedCardsSection(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.only(bottom: 16),
      child: _featuredArticles.isEmpty
          ? Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "Belum ada artikel populer",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      )
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _featuredArticles.length,
        itemBuilder: (context, index) {
          final article = _featuredArticles[index];
          return _buildFeaturedCard(context, article);
        },
      ),
    );
  }

  Widget _buildCategoryChipsSection() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: _categoryMap.keys.map((label) {
          return GestureDetector(
            onTap: () => _onCategorySelectedAndFetch(label),
            child: _buildCategoryChip(label, isSelected: _selectedCategory == label),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, NewsArticle article) {


    return InkWell(
      onTap: () => _showOpenLinkConfirmation(context, article.url!),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Article image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                article.image,
                width: 200,
                height: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.brown[400]!, Colors.brown[600]!],
                      ),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.brown[400]!, Colors.brown[600]!],
                      ),
                    ),
                    child: const Center(child: Icon(Icons.error, color: Colors.white)),
                  );
                },
              ),
            ),
            // Overlay gradient
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? '-',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary20 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? Border.all(color: AppColors.primary20, width: 1) : null,
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: AppColors.primary20.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ]
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? AppColors.primary50 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildArticleItem(BuildContext context, NewsArticle article) {

    return InkWell(
      onTap: () => _showOpenLinkConfirmation(context, article.url!),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.brown[300]!, Colors.brown[500]!],
                  ),
                ),
                child: Image.network(
                  article.image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error));
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    article.title ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          article.publishedAt != null
                              ? DateFormat('dd MMMM yyyy').format(article.publishedAt!)
                              : '-',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),

                      ),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
