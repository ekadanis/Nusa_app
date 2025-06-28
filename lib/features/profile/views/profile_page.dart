import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../models/quiz_models.dart';
import '../../../models/achievement_model.dart';
import '../../../services/google_auth_service.dart';
import '../../../services/user_profile_service.dart';
import '../../quiz/services/quiz_firebase_service.dart';
import '../services/achievement_service.dart';
import '../widgets/profile_header.dart';
import '../widgets/floating_stats_container.dart';
import '../widgets/content_section.dart';
import '../widgets/edit_profile_dialog.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  void _showEditProfileDialog(UserProfileData userProfile) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditProfileDialog(
        currentName: userProfile.name,
        currentAvatar: userProfile.photoUrl,
      ),
    );
    
    if (result == true && mounted) {
      // Profile updated, trigger rebuild by calling setState
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<UserProfileData>(
        stream: UserProfileService.getCurrentUserProfileStream(),
        builder: (context, profileSnapshot) {
          if (profileSnapshot.connectionState == ConnectionState.waiting) {
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

          final userProfile = profileSnapshot.data ?? _getDefaultUserProfile();

          return StreamBuilder<UserStats>(
            stream: QuizFirebaseService.getUserStatsStream(),
            builder: (context, statsSnapshot) {
              final userStats = statsSnapshot.data ?? _getDefaultUserStats();
              
              return StreamBuilder<List<Achievement>>(
                stream: AchievementService.getAchievementsStream(),
                builder: (context, achievementsSnapshot) {
                  final achievements = achievementsSnapshot.data ?? [];
                  
                  return Container(
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
                            ProfileHeader(
                              userProfile: userProfile,
                              onEditPressed: () => _showEditProfileDialog(userProfile),
                            ),
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
          );
        },
      ),
    );
  }

  UserProfileData _getDefaultUserProfile() {
    final user = GoogleAuthService.currentUser;
    return UserProfileData(
      name: user?.displayName ?? 'User',
      email: user?.email ?? 'user@example.com',
      photoUrl: user?.photoURL,
    );
  }

  UserStats _getDefaultUserStats() {
    final user = GoogleAuthService.currentUser;
    return UserStats(
      name: user?.displayName ?? 'User',
      email: user?.email ?? 'user@example.com',
      photoUrl: user?.photoURL,
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
