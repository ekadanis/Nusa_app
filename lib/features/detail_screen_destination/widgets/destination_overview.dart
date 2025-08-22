import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/util/extensions.dart';

class DestinationOverview extends StatelessWidget {
  final String? overviewContent;
  final String subcategory;

  const DestinationOverview({
    Key? key,
    required this.overviewContent,
    required this.subcategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overview Title
        Text(
          'Overview',
          style: context.textTheme.headlineSmall,
        ),
        SizedBox(height: 1.5.h),
        
        // Overview Content
        Text(
          overviewContent ?? 'Loading content...',
          style: context.textTheme.bodyMedium,
        ),
        SizedBox(height: 1.5.h),

        // Category Badge
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 0.8.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary10,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            subcategory,
            style: context.textTheme.labelMedium?.copyWith(
              color: AppColors.primary50,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
