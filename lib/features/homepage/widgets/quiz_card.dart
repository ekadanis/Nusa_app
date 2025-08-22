import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/app_colors.dart';
import '../../../core/styles.dart';
import '../../../routes/router.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Styles.mdPadding),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(Styles.lgRadius),
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(          onTap: () {
            // Use replace to prevent HomePageQuiz from being accessible via back button
            context.router.replace(const HomeRouteQuiz());
          },
          borderRadius: BorderRadius.circular(Styles.lgRadius),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Styles.lgRadius),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.quizBlue,
                  Color(0xFF1976D2),
                ],
              ),
            ),
            child: Row(
              children: [
                // Icon Quiz
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(Styles.mdRadius),
                  ),
                  child: Icon(
                    IconsaxPlusBold.document_text,
                    color: Colors.white,
                    size: 8.w,
                  ),
                ),
                SizedBox(width: 4.w),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Quiz Nusantara',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Test pengetahuan budaya Indonesia Anda',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Mulai Quiz',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Arrow Icon
                Icon(
                  IconsaxPlusBold.arrow_right_3,
                  color: Colors.white,
                  size: 6.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
