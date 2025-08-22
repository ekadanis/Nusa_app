import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';
import '../../../models/achievement_model.dart';

class AchievementItem extends StatelessWidget {
  final Achievement achievement;

  const AchievementItem({super.key, required this.achievement});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: achievement.isUnlocked 
              ? AppColors.quizBlue.withOpacity(0.3) 
              : AppColors.grey20,
        ),
      ),
      child: Row(
        children: [
          // Achievement Icon
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: achievement.isUnlocked 
                  ? AppColors.quizBlue.withOpacity(0.1) 
                  : AppColors.grey20.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: achievement.isUnlocked
                  ? Text(
                      achievement.icon,
                      style: TextStyle(
                        fontSize: 6.w,
                      ),
                    )
                  : Icon(
                      achievement.lockedIcon,
                      size: 6.w,
                      color: AppColors.grey50,
                    ),
            ),
          ),

          SizedBox(width: 3.w),          // Achievement Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: achievement.isUnlocked ? AppColors.grey90 : AppColors.grey50,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  achievement.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey50,
                  ),
                ),
              ],
            ),
          ),

          // Status Badge - only show for locked achievements
          if (!achievement.isUnlocked)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
              decoration: BoxDecoration(
                color: AppColors.grey20,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Locked',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}