import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../core/app_colors.dart';
import '../../../models/quiz_models.dart';
import 'stat_card.dart';

class FloatingStatsContainer extends StatelessWidget {
  final UserStats userStats;

  const FloatingStatsContainer({
    super.key,
    required this.userStats,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 4.w,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [                Expanded(
                  child: StatCard(
                    icon: IconsaxPlusBold.book_1,
                    value: '${userStats.articlesRead}',
                    label: 'Articles Read',
                    color: AppColors.quizBlue,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: StatCard(
                    icon: IconsaxPlusBold.task_square,
                    value: '${userStats.quizzesCompleted}',
                    label: 'Quizzes Completed',
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [                Expanded(
                  child: StatCard(
                    icon: IconsaxPlusBold.calendar_1,
                    value: '${userStats.dayStreak}',
                    label: 'Day Streak',
                    color: AppColors.quizOrange,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                    
         
                  child: StatCard(
                    icon:   IconsaxPlusBold.star,
                    value: '${userStats.totalXP}',
                    label: 'Total XP',
                    color:    Colors.yellowAccent.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
