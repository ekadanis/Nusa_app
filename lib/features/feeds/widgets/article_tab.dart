import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/models/article_model.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/google_auth_service.dart';

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
  bool _isArticlesLoading = false;

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
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _fetchFeaturedArticles();
      print("✅ Loaded ${_featuredArticles.length} featured articles");
      await _fetchArticles();
      print("✅ Loaded ${_articles.length} articles");
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _isLoading = false; // <- ini penting agar layar loading hilang
        print("✅ Data loaded");
      });
    }
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
          SliverToBoxAdapter(
            child: _isArticlesLoading
                ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            )
                : Column(
              children: _articles.map((article) => _buildArticleItem(context, article)).toList(),
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
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Open Article',
      text: 'Do you want to visit the original page?',
      confirmBtnText: 'Visit',
      cancelBtnText: 'Cancel',
      confirmBtnColor: AppColors.success,
      titleColor: Theme.of(context).textTheme.headlineSmall?.color ?? Colors.black87,
      textColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black54,
      widget: Text(
        'This will open the article in your browser',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontFamily: 'Plus Jakarta Sans',
          color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black54,
        ),
        textAlign: TextAlign.center,
      ),
      onConfirmBtnTap: () async {
        Navigator.of(context).pop();
        await _openArticleLink(context, url);
      },
    );
  }

  Future<void> _openArticleLink(BuildContext context, String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        final launched = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        if (!launched) {
          throw 'Could not launch $url';
        }
        
        // Track article read for user profile
        await _trackArticleRead();
      } else {
        throw 'Invalid URL: $url or no app to handle it.';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Could not open article link',
          confirmBtnColor: AppColors.error,
          titleColor: Theme.of(context).textTheme.headlineSmall?.color ?? Colors.black87,
          widget: Text(
            'Please try again later',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Plus Jakarta Sans',
              color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }
    }
  }

  Future<void> _fetchArticles({String? categoryId}) async {
    setState(() {
      _isArticlesLoading = true;
      _error = null;
    });

    try {
      final query = categoryId?.isNotEmpty == true ? categoryId! : 'indonesia culture';
      final articles = await fetchIndonesianCultureNews(query: query);

      setState(() {
        _articles = articles;
        _isArticlesLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to load articles: $e";
        _isArticlesLoading = false;
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
      margin: const EdgeInsets.fromLTRB(0, 24, 0, 16), // Added top margin
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
      onTap: () => _showOpenLinkConfirmation(context, article.url),
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
                    article.title,
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
        color: isSelected 
            ? AppColors.primary50.withOpacity(0.1) 
            : AppColors.grey10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary50 : AppColors.grey200,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: isSelected ? AppColors.primary50 : AppColors.grey70,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildArticleItem(BuildContext context, NewsArticle article) {

    return InkWell(
      onTap: () => _showOpenLinkConfirmation(context, article.url),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              blurRadius: 6,
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
                    article.title,
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
                          DateFormat('dd MMMM yyyy').format(article.publishedAt),
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

  // Track article read for user profile
  Future<void> _trackArticleRead() async {
    try {
      final user = GoogleAuthService.currentUser;
      if (user == null) {
        print('❌ No user logged in');
        return;
      }

      final userStatsRef = FirebaseFirestore.instance
          .collection('user_stats')
          .doc(user.uid);

      // Check if document exists first
      final docSnapshot = await userStatsRef.get();
      
      if (docSnapshot.exists) {
        // Document exists, just increment
        await userStatsRef.update({
          'articlesRead': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        print('✅ Article read count incremented for user: ${user.uid}');
      } else {
        // Document doesn't exist, create it with initial data
        await userStatsRef.set({
          'name': user.displayName ?? 'User',
          'email': user.email ?? '',
          'photoUrl': user.photoURL,
          'level': 1,
          'levelTitle': 'Cultural Newbie',
          'currentXP': 0,
          'nextLevelXP': 100,
          'totalXP': 0,
          'quizzesCompleted': 0,
          'articlesRead': 1, // Set to 1 for first article read
          'dayStreak': 0,
          'accuracy': 0.0,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        print('✅ Created user_stats document and tracked first article read for user: ${user.uid}');
      }
    } catch (e) {
      print('❌ Error tracking article read: $e');
      // Show user-friendly error if needed
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to track article reading progress'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
