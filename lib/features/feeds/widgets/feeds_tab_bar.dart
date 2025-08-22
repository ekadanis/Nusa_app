import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:nusa_app/core/app_colors.dart';

class FeedsTabBar extends StatelessWidget {
  final TabController tabController;

  const FeedsTabBar({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 7.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: TabBar(
        controller: tabController,
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
}
