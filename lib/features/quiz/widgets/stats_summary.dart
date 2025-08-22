import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../core/app_colors.dart';

class StatsSummary extends StatelessWidget {
  final int totalQuizzes;
  final String averageScore;
  final int totalXP;

  const StatsSummary({
    super.key,
    required this.totalQuizzes,
    required this.averageScore,
    required this.totalXP,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            'Total Quizzes',
            '$totalQuizzes',
            IconsaxPlusBold.document_text,
            Colors.blue.shade600,
          ),
          Container(
            height: 5.h,
            width: 1,
            color: AppColors.grey300,
          ),
          _buildStatItem(
            context,
            'Average Score',
            averageScore,
            IconsaxPlusBold.chart_square,
            Colors.redAccent.shade700,
          ),
          Container(
            height: 5.h,
            width: 1,
            color: AppColors.grey300,
          ),
          _buildStatItem(
            context,
            'Total XP',
            '$totalXP',
            IconsaxPlusBold.star,
            Colors.yellowAccent.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 6.w,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.grey90,
              ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey60,
              ),
        ),
      ],
    );
  }
}
