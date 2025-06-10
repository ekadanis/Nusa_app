import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String selectedFilter;
  final double selectedRadius;
  final VoidCallback? onAdjustRadius;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.selectedFilter,
    required this.selectedRadius,
    this.onAdjustRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.grey10.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.grey30.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              selectedFilter == "Nearby"
                  ? Icons.location_off
                  : IconsaxPlusLinear.document,
              color: AppColors.grey50,
              size: 32,
            ),
            const SizedBox(height: 8),            Text(
              selectedFilter == "Nearby"
                  ? 'No ${title.toLowerCase()} within ${selectedRadius.round()}km'
                  : 'No ${title.toLowerCase()} available',
              style: const TextStyle(
                color: AppColors.grey50,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,            ),
            const SizedBox(height: 4),
            Text(
              selectedFilter == "Nearby"
                  ? 'Try increasing the search radius'
                  : 'Check back later for new content',
              style: const TextStyle(
                color: AppColors.grey40,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            if (selectedFilter == "Nearby" && onAdjustRadius != null) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onAdjustRadius,
                icon: const Icon(
                  Icons.tune,
                  size: 16,
                  color: Colors.white,
                ),
                label: const Text('Adjust Radius'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary50,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
