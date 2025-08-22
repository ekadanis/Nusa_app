import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/util/extensions.dart';

class ImageResultOverview extends StatelessWidget {
  final String description;
  final String origin;

  const ImageResultOverview({
    Key? key,
    required this.description,
    required this.origin,
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
        
        // Description Content
        Text(
          description,
          style: context.textTheme.bodyMedium,
        ),
        SizedBox(height: 1.5.h),

        // Origin Badge
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
            origin,
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
