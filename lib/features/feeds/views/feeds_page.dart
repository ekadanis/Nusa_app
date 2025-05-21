import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/core/styles.dart';
import 'package:nusa_app/l10n/l10n.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/routes/router.dart';

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
  final TextEditingController _postController = TextEditingController();

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
    _postController.dispose();
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
            _buildTabBar(),

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
              onPressed: () => _showCreatePostDialog(context),
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
                  onPressed: () {},
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

  Widget _buildTabBar() {
    return Container(
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
        _buildFeaturedCardsSection(),

        // Category chips
        _buildCategoryChipsSection(),

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

  Widget _buildFeaturedCardsSection() {
    return SizedBox(
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
    );
  }

  Widget _buildCategoryChipsSection() {
    return Padding(
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
    );
  }

  Widget _buildForumPost(int index) {
    return InkWell(
      onTap: () => _showForumDetailPage(context),
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

  // Show create post dialog
  void _showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Share your message to the forum!',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.close, color: Colors.red, size: 18),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _postController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Write your message here...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Post the message
                      Navigator.of(context).pop();
                      _postController.clear();
                    },
                    child: const Text('Share'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show forum detail page with comments
  void _showForumDetailPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ForumDetailPage(),
      ),
    );
  }
}

// Forum Detail Page
class ForumDetailPage extends StatefulWidget {
  const ForumDetailPage({super.key});

  @override
  State<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Post content
          _buildPostContent(),

          // Divider and Comments label
          const Divider(),
          _buildCommentsHeader(),

          // Comments section
          Expanded(
            child: _buildCommentsList(),
          ),

          // Comment input field
          _buildCommentInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, size: 16),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          const Text(
            'Saif Desur',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.verified,
              size: 16,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Batik is a traditional fabric known for its detailed patterns and handmade dyeing process. Each design tells a unique cultural story.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite_border,
                      color: Colors.blue, size: 18),
                  const SizedBox(width: 4),
                  const Text('12rb', style: TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Icon(Icons.comment_outlined,
                      color: Colors.amber[600], size: 18),
                  const SizedBox(width: 4),
                  const Text('300', style: TextStyle(fontSize: 13)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsHeader() {
    return const Padding(
      padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Komentar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsList() {
    final comments = [
      {
        'name': 'Andi Pratama',
        'text':
            'Batik is a traditional fabric known for its detailed designs and unique hand-dyeing process. Each pattern has its own cultural story behind it.',
        'time': '1 jam yang lalu',
      },
      {
        'name': 'Ricky Hidayat',
        'text':
            'Making batik involves applying hot wax to fabric and then dyeing it in natural dye. It\'s a labor intensive process to get all these intricate designs.',
        'time': '2 jam yang lalu',
      },
      {
        'name': 'Hikista Uzumaki',
        'text':
            'Batik is such an important part of our heritage, often tied to various animals, or even historical events. So it\'s more than just clothing - it\'s a way to tell a story.',
        'time': '3 jam yang lalu',
      },
      {
        'name': 'Bayu Ramadhan',
        'text':
            'Batik is a major part of Indonesian culture and was even recognized by UNESCO as an intangible cultural heritage. Different regions have their own styles like Pekalongan or Yogyakarta.',
        'time': '3 jam yang lalu',
      },
      {
        'name': 'Sakura Hando',
        'text':
            'Batik fabric is usually made from cotton or silk, making it comfy to wear. Silk batik is often used for fancy occasions, while cotton is great for everyday use.',
        'time': '3 jam yang lalu',
      },
      {
        'name': 'Mikaza Jaeger',
        'text':
            'Nowadays, batik is getting a modern twist, and people from all over the world are wearing it. It\'s cool to see how it\'s evolving!',
        'time': '3 jam yang lalu',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: comments.length,
      itemBuilder: (context, index) => _buildComment(
        comments[index]['name']!,
        comments[index]['text']!,
        comments[index]['time']!,
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.purple,
            child: Text('T', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Type your message here...',
                  hintStyle: TextStyle(fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComment(String name, String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommentAvatar(name),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentAvatar(String name) {
    // Assign avatar color based on first letter of name
    final Color avatarColor = _getAvatarColor(name);

    return CircleAvatar(
      radius: 16,
      backgroundColor: avatarColor,
      child: Text(
        name[0],
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Color _getAvatarColor(String name) {
    final firstLetter = name[0].toUpperCase();

    switch (firstLetter) {
      case 'A':
        return Colors.black;
      case 'R':
        return Colors.black;
      case 'H':
        return Colors.green;
      case 'B':
        return Colors.brown;
      case 'S':
        return Colors.orange;
      case 'M':
        return Colors.blue;
      default:
        return Colors.purple;
    }
  }
}
