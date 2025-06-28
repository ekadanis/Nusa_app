import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class ResultStatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const ResultStatItem({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.grey50,
              ),
        ),
      ],
    );
  }
}
