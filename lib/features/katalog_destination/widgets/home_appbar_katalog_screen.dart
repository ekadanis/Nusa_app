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
    final bannerImage = bannerPicker(categoryName?.toLowerCase());
    print("<<<<<BANNER IMAGE:${bannerImage}");

    return SizedBox(
      height: 22.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            bottom: 4.h,
            child: Image.asset(
              bannerImage,
              fit: BoxFit.cover,
              frameBuilder: (BuildContext context, Widget child, int? frame,
                  bool wasSynchronouslyLoaded) {
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
          
          // Overlay with blue tint
          Container(
            height: 20.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: categoryColorPicker(categoryName?.toLowerCase()),
            ),
          ),
          
          // Content container with padding (including back button)
          Container(
            height: 20.h,
            width: 100.w,
            padding: EdgeInsets.symmetric(
              horizontal: Styles.mdPadding,
              vertical: 2.h,
            ),            child: Column(
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

  static bannerPicker(String? categoryName) {
    print("\n\n<<<<<CATEGORY NAME:${categoryName}\n\n");
    switch (categoryName) {
      case "local foods": return "assets/banner/banner_local_food.jpg";
      case "folk instruments": return "assets/banner/banner_folk_instrument.jpg";
      case "traditional wear": return "assets/banner/banner_traditional_wear.jpg";
      case "arts & culture": return "assets/banner/banner_arts_culture.jpg";
      case "crafts & artifacts": return "assets/banner/banner_craft_artifacts.jpeg";
      case "cultural sites": return "assets/banner/banner_cultural_sites.jpg";
      default: return "assets/banner/banner.png";
    }
  }

  static categoryColorPicker(String? categoryName) {
    switch (categoryName) {
      case 'local foods' : return AppColors.purple50.withOpacity(0.6);
      case 'folk instruments' : return AppColors.success50.withOpacity(0.6);
      case 'traditional wear' : return AppColors.yellow50.withOpacity(0.6);
      case'arts & culture' : return AppColors.warning50.withOpacity(0.6);
      case'crafts & artifacts' : return AppColors.danger50.withOpacity(0.6);
      case'cultural sites' : return AppColors.primary50.withOpacity(0.6);
      default: return AppColors.grey50.withOpacity(0.6);
    }
  }
}

