import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:nusa_app/features/feeds/widgets/feeds_header.dart';
import 'package:nusa_app/features/feeds/widgets/feeds_tab_bar.dart';

class FeedsAppBar extends StatelessWidget {
  final TabController tabController;

  const FeedsAppBar({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const FeedsHeader(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FeedsTabBar(tabController: tabController),
          ),
        ],
      ),
    );
  }
}
