import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/features/feeds/widgets/build_category_name.dart';
import 'package:nusa_app/models/article_model.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:nusa_app/services/firestore_service.dart';

class ArticleTab extends StatefulWidget {
  const ArticleTab({super.key});

  @override
  State<ArticleTab> createState() => _ArticleTabState();
}

class _ArticleTabState extends State<ArticleTab> {
  List<ArticleModel> _articles = [];
  List<ArticleModel> _featuredArticles = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = "Discover";
  final Map<String, String> _categoryMap = {
    "Discover": "",
    "Cultural Sites": "cultural_sites",
    "Local Foods": "local_foods",
    "Traditional Wear": "traditional_wear",
    "Arts & Culture": "art_and_culture",
    "Folk Instruments": "folk_instruments",
    "Crafts & Artifacts": "crafts_and_artifacts"
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
      return Center(child: Text(_error!));
    }
    return Column(
      children: [
        _buildFeaturedCardsSection(context),
        _buildCategoryChipsSection(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _articles.length, // TODO: Replace with actual data
            itemBuilder: (context, index) =>
                _buildArticleItem(context, _articles[index]),
          ),
        ),
      ],
    );
  }

  Future<void> _fetchArticles({String? categoryId}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      List<ArticleModel> articles;
      if (categoryId == null || categoryId.isEmpty) {
        articles = await FirestoreService.getArticles(limit: 10);
      } else {
        articles =
            await FirestoreService.getArticlesByCategory(categoryId, limit: 10);
      }
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to load articles: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchFeaturedArticles() async {
    final featured = await FirestoreService.getTopArticlesByLikes(limit: 5);
    setState(() {
      _featuredArticles = featured;
    });
  }

  Future<void> _onCategorySelectedAndFetch(String label) async {
    setState(() {
      _selectedCategory = label;
      _isLoading = true;
      _error = null;
    });

    try {
      String categoryId = "";
      if (label != "Discover") {
        // Ambil id kategori dari Firestore berdasarkan nama kategori
        categoryId = await FirestoreService.getCategoryIdByName(label);
      }
      await _fetchArticles(categoryId: categoryId);
    } catch (e) {
      setState(() {
        _error = "Failed to load articles: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  Widget _buildFeaturedCardsSection(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.only(bottom: 16),
      child: _featuredArticles.isEmpty
          ? const Center(child: Text("Belum ada artikel populer"))
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
            child: _buildCategoryChip(label,
                isSelected: _selectedCategory == label),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, ArticleModel article) {
    return InkWell(
      onTap: () {
        AutoRouter.of(context).push(ArticleRoute(article: article));
      },
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
                article.imageUrl,
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
                        colors: [
                          Colors.brown[400]!,
                          Colors.brown[600]!,
                        ],
                      ),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
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
                        colors: [
                          Colors.brown[400]!,
                          Colors.brown[600]!,
                        ],
                      ),
                    ),
                    child: const Center(
                        child: Icon(Icons.error, color: Colors.white)),
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
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
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
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.white.withOpacity(0.8),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${article.like ?? 0} likes',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
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

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary50 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? Border.all(color: AppColors.primary50, width: 1)
            : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary50.withOpacity(0.3),
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
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildArticleItem(BuildContext context, ArticleModel article) {
    return InkWell(
      onTap: () {
        AutoRouter.of(context).push(ArticleRoute(article: article));
      },
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
                  article.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary50.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: buildCategoryName(article.categoryId),
                  ),
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
                      Text(
                        article.date != null
                            ? "${article.date!.day}/${article.date!.month}/${article.date!.year}"
                            : '-',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.visibility,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        article.like.toString() ?? '-',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
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
