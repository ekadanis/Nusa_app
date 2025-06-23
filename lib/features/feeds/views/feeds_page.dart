import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/features/feeds/widgets/forum_tab.dart';
import 'package:nusa_app/features/feeds/widgets/article_tab.dart';
import 'package:nusa_app/features/feeds/widgets/create_post_dialog.dart';
import 'package:nusa_app/util/extensions.dart';

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
      backgroundColor: Colors.grey[50],
      body: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildHeader(), // Tinggi header tetap 120
                Positioned(
                  bottom: -20, // turunkan agar tidak menutupi teks header
                  left: 0,
                  right: 0,
                  child: _buildTabBar(),
                ),
              ],
            ),
            const SizedBox(height: 24), // spasi tambahan agar tidak overlap
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  ForumTab(),
                  ArticleTab(),
                ],
              ),
            ),
          ],
        ),

      floatingActionButton: _currentIndex == 0 ? _buildFAB() : null,
    );
  }


  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary50.withOpacity(0.4),
            spreadRadius: 4,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        backgroundColor: AppColors.primary50,
        shape: const CircleBorder(),
        elevation: 0,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }



  Widget _buildHeader() {
    return Container(
      height: 160, // lebih tinggi dari sebelumnya
      decoration: BoxDecoration(
        color: AppColors.primary50,
        image: DecorationImage(
          image: const AssetImage('assets/banner/banner.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.primary50,
            BlendMode.multiply,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withOpacity(0.2),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(IconsaxPlusBold.message_circle, color: AppColors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cultural Feeds',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Share & Discover Indonesian Culture',
                  style: context.textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.forum_outlined, size: 20),
                const SizedBox(width: 8),
                Text('Forum'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 20),
                const SizedBox(width: 8),
                Text('Articles'),
              ],
            ),
          ),
        ],
        labelColor: AppColors.primary50,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: AppColors.primary50,
        indicatorWeight: 3,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const CreatePostDialog();
      },
    );
  }
}
