import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../models/achievement_model.dart';
import 'achievement_item.dart';

class AchievementsSection extends StatelessWidget {
  final List<Achievement> achievements;
  final bool isLoading;

  const AchievementsSection({
    super.key,
    required this.achievements,
    required this.isLoading,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h), // Added top padding for spacing from stats container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Achievements',
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          SizedBox(height: 2.h),

          // Achievements List
          Column(
            children: isLoading
                ? [const Center(child: CircularProgressIndicator())]
                : achievements
                    .map((achievement) => Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: AchievementItem(achievement: achievement),
                        ))
                    .toList(),
          ),
        ],
      ),
    );
  }
}
