import 'package:flutter/material.dart';
import 'package:nusa_app/core/styles.dart';
import '../../../../core/app_colors.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const FilterChipWidget({
    Key? key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary50 : AppColors.grey10,
          borderRadius: BorderRadius.circular(Styles.lgRadius),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected ? AppColors.primary10 : AppColors.grey70,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}