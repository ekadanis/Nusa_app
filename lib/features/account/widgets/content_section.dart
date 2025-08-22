import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../models/achievement_model.dart';
import 'achievements_section.dart';
import 'logout_section.dart';

class ContentSection extends StatelessWidget {
  final List<Achievement> achievements;
  final bool isLoading;

  const ContentSection({
    super.key,
    required this.achievements,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.h), // Space for floating stats
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 12.h, // Padding for floating stats
          left: 4.w,
          right: 4.w,
          bottom: 4.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Achievements Section
            AchievementsSection(
              achievements: achievements,
              isLoading: isLoading,
            ),

            SizedBox(height: 2.h),

            // Logout Button
            const LogoutSection(),
          ],
        ),
      ),
    );
  }
}
