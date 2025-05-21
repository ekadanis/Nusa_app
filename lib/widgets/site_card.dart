import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/styles.dart';
import 'package:sizer/sizer.dart';

class SiteCard extends StatelessWidget {
  final String title;
  final String location;
  final String imageUrl;
  final Function()? onTap;
  final Function()? onFavorite;
  final bool isFavorite;
  final Widget? locationIcon;
  final String kategori;

  const SiteCard({
    Key? key,
    required this.title,
    required this.location,
    required this.imageUrl,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
    this.locationIcon,
    this.kategori = "Kategori",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45.w,
        height: 25.h,
        margin: EdgeInsets.only(bottom: 0.5.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(Styles.mdRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey20.withValues(alpha: 0.8),
              blurRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Styles.mdRadius),
                    topRight: Radius.circular(Styles.mdRadius),
                  ),
                  child: Image.network(
                    imageUrl,
                    width: 45.w,
                    height: 13.h,
                    fit: BoxFit.cover,
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Styles.mdRadius),
                    topRight: Radius.circular(Styles.mdRadius),
                  ),
                  child: Container(
                    width: 45.w,
                    height: 13.h,
                    color: Colors.black
                        .withOpacity(0.3),
                  ),
                ),
                Positioned(
                  top: Styles.xsPadding,
                  right: Styles.xsPadding,
                  child: GestureDetector(
                    onTap: onFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(Styles.xxsPadding),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(217, 234, 229, 229),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: Styles.mdIcon,
                        color:
                            isFavorite ? AppColors.danger50 : AppColors.grey40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(1.5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Styles.xxsSpacing),
                  Row(
                    children: [
                      locationIcon ??
                          Icon(
                            Icons.location_on,
                            size: 1.5.h,
                            color: AppColors.success50,
                          ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          location,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.grey50,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      kategori,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.primary50,
                            fontSize: 12.sp,
                          ),
                    ),
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
