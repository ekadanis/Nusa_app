import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';
import '../../../models/quiz_models.dart';
import '../../../routes/router.dart';
import '../widgets/result_stat_item.dart';
import '../widgets/motivation_section.dart';

class ResultCard extends StatelessWidget {
  final QuizResult result;

  const ResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          children: [
            // Score
            Text(
              '${result.accuracy.toInt()}%',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.primary50,
                    fontWeight: FontWeight.w700,
                    fontSize: 48,
                  ),
            ),

            Text(
              'Final Score',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.grey50,
                  ),
            ),

            SizedBox(height: 4.h),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ResultStatItem(
                  value: '${result.correctAnswers}',
                  label: 'Correct',
                  color: AppColors.success,
                ),
                ResultStatItem(
                  value: '${result.wrongAnswers}',
                  label: 'Wrong',
                  color: AppColors.error,
                ),
                ResultStatItem(
                  value: '+${result.xpEarned}',
                  label: 'XP',
                  color: AppColors.primary50,
                ),
              ],
            ),

            SizedBox(height: 4.h),

            // Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${result.correctAnswers}/${result.totalQuestions}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.grey50,
                      ),
                ),
              ],
            ),

            SizedBox(height: 6.h),

            // Back to Study Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate back to homepage (beranda quiz detail)
                  context.router.navigate(const HomeRouteQuiz());
                },
                label: const Text('Back to Study'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary50,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Motivation Section
            const MotivationSection(),
          ],
        ),
      ),
    );
  }
}
