import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';
import '../../../routes/router.dart';
import './quiz_page.dart';
import '../widgets/empty_result_view.dart';
import '../widgets/result_card.dart';

@RoutePage()
class QuizResultPage extends StatelessWidget {
  const QuizResultPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Get result from the global variable
    final result = getLatestQuizResult();

    if (result == null) {
      return const EmptyResultView();
    }
    
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
      
        context.router.navigate(const DashboardRoute(children: [HomeRoute()]));
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.quizBlue, Color(0xFF1976D2)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 8.h),

                // Trophy Icon
                _buildTrophyIcon(),

                SizedBox(height: 4.h),

                // Title
                _buildTitle(context),

                SizedBox(height: 2.h),

                _buildSubtitle(context),

                SizedBox(height: 6.h),

                // Results Card
                Expanded(
                  child: ResultCard(result: result),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTrophyIcon() {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.emoji_events,
        color: Colors.amber,
        size: 12.w,
      ),
    );
  }
  
  Widget _buildTitle(BuildContext context) {
    return Text(
      'Quiz Complete!',
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
    );
  }
  
  Widget _buildSubtitle(BuildContext context) {
    return Text(
      'Congratulations! You\'ve completed the quiz',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
      textAlign: TextAlign.center,
    );
  }
}
