import 'package:flutter/material.dart';
import 'package:nusa_app/core/styles.dart';
import '../../../../core/app_colors.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final String? selectedCategory;

  const FilterChipWidget({
    Key? key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.selectedCategory
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? chipsColorPicker(selectedCategory) : AppColors.grey10,
          borderRadius: BorderRadius.circular(Styles.lgRadius),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected ? labelColorPicker(selectedCategory) : AppColors.grey70,
                  fontWeight: FontWeight.w800,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Color chipsColorPicker(String? title) {
    switch (title) {
      case '7hdL7T5MpYY2SUqf0AC7' : return AppColors.purple50.withOpacity(0.4);
      case 'DhonyYdgjgC4TwXzbcGC' : return AppColors.success50.withOpacity(0.4);
      case 'PnzLyTwHbsC3ojAHjW3j' : return AppColors.yellow50.withOpacity(0.4);
      case 'PvuucOStwQrVUHhXBKDi' : return AppColors.warning50.withOpacity(0.4);
      case 'kQzkUbWuBC6Zrad0mVs2' : return AppColors.danger50.withOpacity(0.4);
      case 'nFpGFc2Rkxg2F9zjIx2x' : return AppColors.primary50.withOpacity(0.4);
      default: return AppColors.primary50.withOpacity(0.4); // Menggunakan warna abu-abu default untuk hasil pencarian
    }
  }

  Color labelColorPicker (String? title) {
    switch (title) {
      case '7hdL7T5MpYY2SUqf0AC7' : return AppColors.purple50;
      case 'DhonyYdgjgC4TwXzbcGC' : return AppColors.success50;
      case 'PnzLyTwHbsC3ojAHjW3j' : return AppColors.yellow50;
      case 'PvuucOStwQrVUHhXBKDi' : return AppColors.warning50;
      case 'kQzkUbWuBC6Zrad0mVs2' : return AppColors.danger50;
      case 'nFpGFc2Rkxg2F9zjIx2x' : return AppColors.primary50;
      default: return AppColors.primary50; // Menggunakan warna abu-abu default untuk hasil pencarian
    }
  }
}