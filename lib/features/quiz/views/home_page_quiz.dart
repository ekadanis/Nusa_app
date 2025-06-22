import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';
import '../../../routes/router.dart';
import '../../../models/quiz_models.dart';
import '../services/quiz_service.dart';
import '../widgets/user_level_card.dart';
import '../widgets/stats_row.dart';
import '../widgets/ai_info_section.dart';
import '../widgets/category_grid_section.dart';
import '../widgets/game_history_section.dart';
import '../widgets/quiz_debug_widget.dart'; // Import debug widget
import '../../../widgets/back_button.dart';

@RoutePage()
class HomePageQuiz extends StatelessWidget {
  const HomePageQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        // Navigate to dashboard when back is pressed
        context.router.replace(const DashboardRoute());
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
                // Header
                _buildHeader(context),

                // User Level Card
                _buildUserLevelCard(context),

                SizedBox(height: 3.h),

                // Stats Row
                _buildStatsRow(context),
                SizedBox(height: 2.h),

                _buildContentArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          CustomBackButton(
            backgroundColor: AppColors.white.withOpacity(0.2),
            iconColor: AppColors.white,
            onPressed: () {
              context.router.navigate(const DashboardRoute());
            },
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Study with Nusa',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserLevelCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: StreamBuilder<UserStats>(
        stream: QuizService.getUserStatsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return UserLevelCard(userStats: snapshot.data!);
          }
          return SizedBox(
            height: 12.h,
            child: const Center(
                child: CircularProgressIndicator(color: Colors.white)),
          );
        },
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: StreamBuilder<UserStats>(
        stream: QuizService.getUserStatsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StatsRow(userStats: snapshot.data!);
          }
          return SizedBox(
            height: 8.h,
            child: const Center(
                child: CircularProgressIndicator(color: Colors.white)),
          );
        },
      ),
    );
  }

  Widget _buildContentArea() {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main white container
          Container(
            margin: EdgeInsets.only(top: 4.h), 
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 6.h,
                  left: 4.w,
                  right: 4.w,
                  bottom: 4.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
          
                    SizedBox(height: 3.h),

                    SizedBox(height: 1.h), 
                    const CategoryGridSection(),
                    SizedBox(height: 2.h),
                    const GameHistorySection(),

                    // // Debug Widget - AKTIF untuk development
                    // // TODO: Remove before production
                    // const QuizDebugWidget(),

         
                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            ),
          ),        
          Positioned(
            top: 0,
            left: 4.w, 
            right: 4.w,
            child: StreamBuilder<UserStats>(
              stream: QuizService.getUserStatsStream(),
              builder: (context, snapshot) {
        
                final userLevel = snapshot.hasData ? snapshot.data!.level : 1;
                return AIInfoSection(userLevel: userLevel);
              },
            ),
          ),
        ],
      ),
    );
  }
}
