import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/features/feeds/widgets/forum_tab.dart';
import 'package:nusa_app/features/feeds/widgets/article_tab.dart';
import 'package:nusa_app/features/feeds/widgets/feeds_app_bar.dart';
import 'package:nusa_app/features/feeds/widgets/feeds_floating_action_button.dart';

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
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            FeedsAppBar(tabController: _tabController),
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
      ),
      floatingActionButton: FeedsFloatingActionButton(
        showFAB: _currentIndex == 0,
      ),
    );
  }
}
