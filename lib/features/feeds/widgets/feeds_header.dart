import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/core/styles.dart';

class FeedsHeader extends StatelessWidget {
  const FeedsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      width: 100.w,
      padding: EdgeInsets.symmetric(
        horizontal: Styles.mdPadding,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        image: DecorationImage(
          image: const AssetImage('assets/banner/banner.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.primary50,
            BlendMode.multiply,
          ),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon for Cultural Feeds
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(3.w),
                  child: Icon(
                    Icons.forum,
                    color: Colors.white,
                    size: 8.w,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Cultural Feeds',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        "Share & Discover Indonesian Culture",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }
}
