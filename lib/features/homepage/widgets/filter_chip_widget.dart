import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final String? selectedCategory;
  final String? categoryColor;

  const FilterChipWidget({
    Key? key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.selectedCategory,
    this.categoryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convert hex color to Color object
    Color categoryColorObj = AppColors.primary50; // default
    if (categoryColor != null && categoryColor!.isNotEmpty) {
      try {
        final buffer = StringBuffer();
        if (categoryColor!.length == 6) buffer.write('ff');
        buffer.write(categoryColor!.replaceFirst('#', ''));
        categoryColorObj = Color(int.parse(buffer.toString(), radix: 16));
      } catch (e) {
        categoryColorObj = AppColors.primary50; // fallback to default
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected 
              ? categoryColorObj.withOpacity(0.15) 
              : AppColors.grey10,
          borderRadius: BorderRadius.circular(20),
          border: isSelected 
              ? Border.all(color: categoryColorObj, width: 1.5)
              : Border.all(color: AppColors.grey200, width: 1),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected ? categoryColorObj : AppColors.grey70,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

}