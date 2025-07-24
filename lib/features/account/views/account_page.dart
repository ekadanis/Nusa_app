import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../models/quiz_models.dart';
import '../../../models/achievement_model.dart';
import '../../quiz/services/quiz_firebase_service.dart';
import '../services/achievement_service.dart';
import '../widgets/profile_header.dart';
import '../widgets/floating_stats_container.dart';
import '../widgets/content_section.dart';

@RoutePage()
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<UserStats>(
        stream: QuizFirebaseService.getUserStatsStream(),
        builder: (context, statsSnapshot) {
          if (statsSnapshot.connectionState == ConnectionState.waiting) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [AppColors.quizBlue, Color(0xFF1976D2)],
                ),
              ),
              child: const Center(
                  child: CircularProgressIndicator(color: Colors.white)),
            );
          }

          final userStats = statsSnapshot.data ?? _getDefaultUserStats();

          return StreamBuilder<List<Achievement>>(
            stream: AchievementService.getAchievementsStream(),
            builder: (context, achievementsSnapshot) {
              final achievements = achievementsSnapshot.data ?? [];              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [AppColors.quizBlue, Color(0xFF1976D2)],
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ProfileHeader(userStats: userStats),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ContentSection(
                              achievements: achievements,
                              isLoading: achievementsSnapshot.connectionState == ConnectionState.waiting,
                            ),

                            FloatingStatsContainer(userStats: userStats),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  UserStats _getDefaultUserStats() {
    return UserStats(
      name: 'User',
      email: 'user@example.com',
      photoUrl: null,
      level: 1,
      levelTitle: 'Beginner',
      currentXP: 0,
      nextLevelXP: 100,
      totalXP: 0,
      quizzesCompleted: 0,
      articlesRead: 0,
      dayStreak: 0,
      accuracy: 0.0,
    );
  }
}
