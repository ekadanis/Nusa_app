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
  Size get preferredSize => Size.fromHeight(22.h);  @override
  Widget build(BuildContext context) {
    // Map category names to their corresponding banner images
    String getBannerImage() {
      switch (categoryName?.toLowerCase()) {
        case "cultural sites":
          return 'assets/banner/banner_cultural_sites.jpg';
        case "arts & culture":
          return 'https://images.unsplash.com/photo-1604973104381-870c92f10343?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8YmF0aWt8ZW58MHx8MHx8fDA%3D';
        case "folk instruments":
          return 'https://images.unsplash.com/photo-1626445829571-3c5d2131bb99?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

        case "traditional wear":
          return 'https://images.unsplash.com/photo-1630930014595-019a27a959b5?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

        case "crafts & artifacts":
          return 'https://cdn1-production-images-kly.akamaized.net/UUOy98Or7ugrSThuOz0mCM1AK5o=/1200x900/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/1994570/original/063692600_1521018806-9-museum_keris.jpg';
        case "local foods":
          return 'https://plus.unsplash.com/premium_photo-1664360228209-bb15b0c5be8f?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
        default:
          return 'assets/banner/banner.png';
      }
    }    final bannerImage = getBannerImage();
    final isNetworkImage = bannerImage.startsWith('http');

    return SizedBox(
      height: 22.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            bottom: 4.h,            child: isNetworkImage
                ? Image.network(
                    bannerImage,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AppColors.primary50,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: AppColors.primary50);
                    },
                  )                : Image.asset(
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
                      return Container(color: AppColors.primary50);
                    },
                  ),
          ),
          
          // Darkening overlay effect
          Container(
            height: 20.h,
            width: 100.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.6),
                  AppColors.primary50.withOpacity(0.4),
                ],
              ),
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
                      Expanded(                        child: Column(
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
}
