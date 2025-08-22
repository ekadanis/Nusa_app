import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';
import '../services/quiz_service.dart';
import '../widgets/game_history_item.dart';

class GameHistorySection extends StatelessWidget {
  const GameHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Game History Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Game History',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                context.router.pushNamed('/quiz-history');
              },
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.quizBlue,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 1.h), // Game History Items
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: QuizService.getQuizHistoryStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Column(
                children: snapshot.data!.take(3).map((history) {
                  return GameHistoryItem(
                    category: QuizService.getCategoryNameById(
                        history['categoryId'] ?? ''),
                    accuracy: (history['accuracy'] ?? 0).toInt(),
                    xp: history['xpEarned'] ?? 0,
                    timeAgo: QuizService.formatTimeAgo(history['completedAt']),
                    color: QuizService.getCategoryColor(history['categoryId']),
                  );
                }).toList(),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.quizBlue),
              );
            } else {
              // No data or empty history
              return _buildEmptyState(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              Icon(
                Icons.quiz_outlined,
                size: 8.w,
                color: AppColors.quizBlue,
              ),
              SizedBox(height: 1.h),
              Text(
                'No Quiz History Yet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.quizBlue,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Start your first quiz to see your history here!',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.grey70,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
