import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/app_colors.dart';
import '../filter_chip_widget.dart';

class FilterChipsRow extends StatelessWidget {
  final String selectedFilter;
  final bool isLoadingLocation;
  final bool hasUserLocation;
  final double selectedRadius;
  final Function(String) onFilterSelected;
  final VoidCallback onNearbyTapped;
  final VoidCallback onRadiusTapped;

  const FilterChipsRow({
    Key? key,
    required this.selectedFilter,
    required this.isLoadingLocation,
    required this.hasUserLocation,
    required this.selectedRadius,
    required this.onFilterSelected,
    required this.onNearbyTapped,
    required this.onRadiusTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: [
          FilterChipWidget(
            label: "Discover",
            isSelected: selectedFilter == "Discover",
            onTap: () => onFilterSelected("Discover"),
          ),
          FilterChipWidget(
            label: "Most Like",
            isSelected: selectedFilter == "Most Like",
            onTap: () => onFilterSelected("Most Like"),
          ),
          FilterChipWidget(
            label: "Recommended",
            isSelected: selectedFilter == "Recommended",
            onTap: () => onFilterSelected("Recommended"),
          ),
          // Custom Nearby chip with icon
          GestureDetector(
            onTap: onNearbyTapped,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              decoration: BoxDecoration(
                color: selectedFilter == "Nearby"
                    ? AppColors.primary50
                    : AppColors.grey10,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoadingLocation)
                    SizedBox(
                      width: 3.w,
                      height: 3.w,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Icon(
                      hasUserLocation ? Icons.location_on : Icons.location_off,
                      size: 16,
                      color: selectedFilter == "Nearby"
                          ? Colors.white
                          : AppColors.grey70,
                    ),
                  SizedBox(width: 1.w),
                  Text(
                    hasUserLocation && selectedFilter == "Nearby"
                        ? "Nearby (${selectedRadius.round()}km)"
                        : "Nearby",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: selectedFilter == "Nearby"
                              ? Colors.white
                              : AppColors.grey70,
                        ),
                  ),
                ],
              ),
            ),
          ),
          if (selectedFilter == "Nearby" && hasUserLocation)
            GestureDetector(
              onTap: onRadiusTapped,
              child: Container(
                margin: EdgeInsets.only(left: 2.w),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppColors.primary50.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.tune,
                      size: 16,
                      color: AppColors.primary50,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Radius',
                      style: TextStyle(
                        color: AppColors.primary50,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
