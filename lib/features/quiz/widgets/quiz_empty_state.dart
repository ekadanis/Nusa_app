import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../core/app_colors.dart';

class QuizEmptyState extends StatelessWidget {
  final String selectedFilter;
  final VoidCallback onTakeQuizPressed;

  const QuizEmptyState({
    super.key,
    required this.selectedFilter,
    required this.onTakeQuizPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppColors.grey10,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              IconsaxPlusBold.document_text,
              size: 15.w,
              color: AppColors.grey50,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            selectedFilter == 'All'
                ? 'No Quiz History'
                : 'No Quiz for $selectedFilter',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey70,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            selectedFilter == 'All'
                ? 'Start taking quizzes to see your history here'
                : 'Try a different time filter or take more quizzes',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey60,
                ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: onTakeQuizPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary50,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Take a Quiz'),
          ),
        ],
      ),
    );
  }
}
