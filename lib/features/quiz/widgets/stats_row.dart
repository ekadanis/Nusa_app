import 'package:flutter/material.dart';
import '../../../models/quiz_models.dart';

class StatsRow extends StatelessWidget {
  final UserStats userStats;

  const StatsRow({super.key, required this.userStats});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem(
            context,
            '${userStats.quizzesCompleted}',
            'Quizzes\nCompleted',
          ),
          _buildStatItem(
            context,
            '${userStats.dayStreak}',
            'Day Streak',
          ),
          _buildStatItem(
            context,
            _formatXP(userStats.totalXP),
            'Total XP',
          ),
        ],
      ),
    );
  }

  String _formatXP(int xp) {
    if (xp < 1000) {
      return xp.toString();
    } else if (xp < 10000) {
      return '${(xp / 1000).toStringAsFixed(1)}k';
    } else {
      return '${(xp / 1000).toInt()}k';
    }
  }
  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}