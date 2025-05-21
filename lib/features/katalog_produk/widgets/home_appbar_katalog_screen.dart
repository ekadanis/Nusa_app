import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';
import '../../../core/styles.dart';
import '../../../widgets/back_button.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? categoryName;
  final List<String>? subcategories;

  const HomeAppBar({
    Key? key,
    this.categoryName,
    this.subcategories,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(22.h);

  @override
  Widget build(BuildContext context) {
    final isCultureSite = categoryName?.toLowerCase() == "cultural sites";
    final bannerImage = isCultureSite
        ? 'assets/banner/banner_cultural_sites.jpg'
        : 'assets/banner/banner.png';
        
    return SizedBox(
      height: 22.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 20.h,
            width: 100.w,
            padding: EdgeInsets.symmetric(
              horizontal: Styles.mdPadding,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary50,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomBackButton(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        iconColor: Colors.white,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              categoryName ?? "Cultural Sites",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
              ],
            ),
            foregroundDecoration: BoxDecoration(
              color: AppColors.primary50.withOpacity(0.6),
              backgroundBlendMode: BlendMode.multiply,
            ),
          ),
          // Banner image positioned behind the container
          Positioned.fill(
            bottom: 4.h, // To account for the rounded white overlay
            child: Image.asset(
              bannerImage,
              fit: BoxFit.cover,
              frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded || frame != null) {
                  return child;
                }
                return AnimatedOpacity(
                  opacity: 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: child,
                );
              },
              errorBuilder: (context, error, stackTrace) {
                // Return fallback color when image fails to load
                return Container(color: AppColors.primary50);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: 100.w,
              height: 4.h,
              clipBehavior: Clip.antiAlias,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Styles.lgRadius),
                    topRight: Radius.circular(Styles.lgRadius),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}