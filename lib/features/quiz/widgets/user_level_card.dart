import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../models/quiz_models.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class UserLevelCard extends StatelessWidget {
  final UserStats userStats;

  const UserLevelCard({super.key, required this.userStats});

  String _formatXP(int xp) {
    if (xp < 1000) {
      return xp.toString();
    } else if (xp < 10000) {
      return '${(xp / 1000).toStringAsFixed(1)}k';
    } else {
      return '${(xp / 1000).toInt()}k';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Level Badge
              Container(
                padding: EdgeInsets.all(2.w),                decoration: BoxDecoration(
                  color: Colors.orangeAccent.shade700, // Ganti dengan warna dari AppColors
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  IconsaxPlusBold.medal_star,
                  color: Colors.white,
                  size: 6.w,
                ),
              ),

              SizedBox(width: 3.w),

              // Level Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level ${userStats.level} - ${userStats.levelTitle}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${_formatXP(userStats.currentXP)} XP',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Accuracy
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${userStats.accuracy.toInt()}%',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Accuracy',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress Bar
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [                  Text(
                    '${_formatXP(userStats.nextLevelXP - userStats.currentXP)} XP to Level ${userStats.level + 1}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              LinearProgressIndicator(
                value: userStats.currentXP / userStats.nextLevelXP,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6,
              ),
            ],
          ),
        ],
      ),
    );
  }
}