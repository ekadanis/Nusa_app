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

  Color _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return AppColors.primary50; // default color
    }

    try {
      // Remove # if present
      String cleanColor = colorString.replaceFirst('#', '');
      
      // Add alpha if not present (6 characters = RGB, need ARGB)
      if (cleanColor.length == 6) {
        cleanColor = 'FF$cleanColor'; // Add full opacity
      }
      
      return Color(int.parse(cleanColor, radix: 16));
    } catch (e) {
      debugPrint('Error parsing color "$colorString": $e');
      return AppColors.primary50; // fallback to default
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColorObj = _parseColor(categoryColor);
    
    // Debug print to check color values
    debugPrint('FilterChip - Label: $label, Color: $categoryColor, Parsed: ${categoryColorObj.value.toRadixString(16)}');

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
          boxShadow: isSelected ? [
            BoxShadow(
              color: categoryColorObj.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ] : [],
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isSelected ? categoryColorObj : AppColors.grey70,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}