import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/core/styles.dart';
import 'package:sizer/sizer.dart';

class CommonAppBar extends StatelessWidget {
  final String username;
  final String subtitle;
  final String avatarPath;
  final VoidCallback? onNotificationTap;

  const CommonAppBar({
    super.key,
    required this.username,
    required this.subtitle,
    required this.avatarPath,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15.h,
      child: Container(
        height: 14.h,
        width: 100.w,
        padding: EdgeInsets.symmetric(
          horizontal: 3.h,
          // vertical: 1.h,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                avatarPath,
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                      ),
                      const SizedBox(width: 4),
                      const Text("🟢", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
