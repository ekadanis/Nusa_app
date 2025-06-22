import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';
import '../../../models/quiz_models.dart';

class ProfileHeader extends StatelessWidget {
  final UserStats userStats;

  const ProfileHeader({
    super.key,
    required this.userStats,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Profile Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 15.w,
                backgroundColor: Colors.white.withOpacity(0.3),
                backgroundImage: userStats.photoUrl != null
                    ? NetworkImage(userStats.photoUrl!)
                    : null,
                child: userStats.photoUrl == null
                    ? Text(
                        userStats.name.isNotEmpty
                            ? userStats.name.substring(0, 1).toUpperCase()
                            : 'U',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 4.w,
                    color: AppColors.grey50,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // User Info
          Text(
            userStats.name.isNotEmpty ? userStats.name : 'User',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          Text(
            userStats.email.isNotEmpty ? userStats.email : 'No email',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
          ),

          SizedBox(height: 3.h),

          // Level Progress
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Level ${userStats.level} - ${userStats.levelTitle}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      '${userStats.currentXP} / ${userStats.nextLevelXP} XP',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                LinearProgressIndicator(
                  value: userStats.nextLevelXP > 0
                      ? userStats.currentXP / userStats.nextLevelXP
                      : 0.0,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
