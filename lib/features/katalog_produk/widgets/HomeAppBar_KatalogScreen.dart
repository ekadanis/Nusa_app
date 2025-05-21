import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';
import '../../../core/styles.dart';
import '../../../widgets/back_button.dart';

class HomeAppBar extends StatelessWidget {
  final String? categoryName;
  final List<String>? subcategories;

  const HomeAppBar({
    Key? key,
    this.categoryName,
    this.subcategories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Back button is now included in the row with the title
          Container(
            height: 20.h,
            width: 100.w,
            padding: EdgeInsets.symmetric(
              horizontal: Styles.mdPadding,
              vertical: 2.h,
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
                            if (subcategories != null &&
                                subcategories!.isNotEmpty)
                              Text(
                                "${subcategories!.length} subcategories available",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
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
