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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overview',
              style: context.textTheme.headlineSmall,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 0.8.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                subcategory,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),

        // Overview Content
        Text(
          overviewContent ?? 'Loading content...',
          style: context.textTheme.bodyMedium,
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 1.5.h),
      ],
    );
  }
}
