import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/core/styles.dart';
import 'package:nusa_app/l10n/l10n.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/routes/router.dart';

@RoutePage()
@RoutePage()
class FeedsPage extends StatefulWidget {
  const FeedsPage({super.key});

  @override
  State<FeedsPage> createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Blue Header - stays consistent across tabs
            _buildHeader(),

            // Tab Bar - also stays consistent
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Forum'),
                  Tab(text: 'Artikel'),
                ],
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                dividerColor: Colors.transparent,
              ),
            ),

            // Tab Content - changes based on selected tab
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Forum Tab
                  _buildForumContent(),
                  // Article Tab
                  _buildArticleContent(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // Add new forum post action
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF1A3B80),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Back button and title
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 18),
                  onPressed: () {
                    // Navigate back
                  },
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Feeds',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Search bar (only show in forum tab)
          if (_currentIndex == 0)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Find your culture',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildForumContent() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) => _buildForumPost(index),
    );
  }

  Widget _buildArticleContent() {
    return Column(
      children: [
        // Featured Cards
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(10),
            children: [
              _buildFeaturedCard(
                  "Evening Metropolis: A reflection on modern city life"),
              _buildFeaturedCard(
                  "Visit the Valley: Discover treasures that exist in nature"),
            ],
          ),
        ),

        // Category chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip("Discover", isSelected: true),
                _buildCategoryChip("Culture/Sites"),
                _buildCategoryChip("Food & Recipes"),
                _buildCategoryChip("Traditional Wear"),
              ],
            ),
          ),
        ),

        // Article Content
        Expanded(
          child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) => _buildArticleItem(),
          ),
        ),
      ],
    );
  }

  Widget _buildForumPost(int index) {
    return InkWell(
      onTap: () {
        // Navigate to forum post detail
        // context.pushRoute(ForumDetailRoute(id: index.toString()));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[400],
                    child:
                        const Text('S', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Saif Desur',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Senin, ${20 + index} Maret 2024',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Post content
              const Text(
                'Batik is a traditional fabric known for its detailed patterns and handmade dyeing process. Each design tells a unique cultural story.',
                style: TextStyle(fontSize: 15),
              ),

              const SizedBox(height: 12),

              // Interaction buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Like & Comment
                  Row(
                    children: [
                      const Icon(Icons.favorite_border,
                          color: Colors.blue, size: 20),
                      const SizedBox(width: 4),
                      const Text('12rb', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 16),
                      // Comment icon & count
                      Icon(Icons.comment_outlined,
                          color: Colors.amber[600], size: 20),
                      const SizedBox(width: 4),
                      const Text('300', style: TextStyle(fontSize: 13)),
                    ],
                  ),

                  // See more
                  Row(
                    children: [
                      const Text(
                        'Lihat Selengkapnya',
                        style: TextStyle(color: Colors.blue, fontSize: 13),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right,
                          color: Colors.blue, size: 18),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(String title) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.brown[300],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? Border.all(color: Colors.blue.shade300) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: isSelected ? Colors.blue.shade800 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildArticleItem() {
    return InkWell(
      onTap: () {
        // Navigate to article detail
        // context.pushRoute(ArticleDetailRoute(id: '1'));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.brown[400],
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category tag
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Culinary',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Title
                  const Text(
                    'Tahu Tek: A Flavorful Fusion of Tofu, Peanut Sauce, and Crunch',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Date
                  Text(
                    'Selasa, 20 Maret 2024',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
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
