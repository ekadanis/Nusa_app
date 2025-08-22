import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';

class GameHistoryItem extends StatelessWidget {
  final String category;
  final int accuracy;
  final int xp;
  final String timeAgo;
  final Color color;

  const GameHistoryItem({
    super.key,
    required this.category,
    required this.accuracy,
    required this.xp,
    required this.timeAgo,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey20.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // Trophy Icon
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.emoji_events,
              color: color,
              size: 5.w,
            ),
          ),

          SizedBox(width: 3.w),

          // Category and Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  timeAgo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey50,
                  ),
                ),
              ],
            ),
          ),

          // Accuracy Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
            decoration: BoxDecoration(
              color: AppColors.grey90,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$accuracy%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(width: 2.w),

          // XP
          Text(
            '+$xp XP',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.grey50,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}