import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';

class QuizErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final VoidCallback onExit;
  
  const QuizErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: AppColors.error, size: 10.w),
            SizedBox(height: 2.h),
            Text(
              'Error loading questions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Text(
                'Unable to generate quiz questions. Please check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 1.h),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Text(
                  'Error: ${errorMessage.length > 100 ? errorMessage.substring(0, 100) + "..." : errorMessage}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: Colors.red,
                  ),
                ),
              ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onRetry,
                  
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary50,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 3.w),
                OutlinedButton(
                  onPressed: onExit,
                  child: const Text('Go Back'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary50,
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
