import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';

class QuizFilterSection extends StatelessWidget {
  final List<String> filterOptions;
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const QuizFilterSection({
    super.key,
    required this.filterOptions,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filterOptions.length,
        itemBuilder: (context, index) {
          final filter = filterOptions[index];
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: GestureDetector(
              onTap: () => onFilterSelected(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.5.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary50.withOpacity(0.15)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primary50 : Colors.grey.shade300,
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary50.withOpacity(0.10),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: TextStyle(
                      color:
                          isSelected ? AppColors.primary50 : AppColors.grey70,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
