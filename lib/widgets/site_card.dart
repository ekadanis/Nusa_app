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
  final String? kategori;
  final int likeCount;
  final bool isCompact;
  final String? distance; // New parameter for displaying distance

  const SiteCard({
    Key? key,
    required this.title,
    required this.location,
    required this.imageUrl,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
    this.locationIcon,
    this.kategori,
    this.likeCount = 0,
    this.isCompact = false,
    this.distance, // Optional distance parameter
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isCompact ? 40.w : 45.w,
        height: isCompact ? 25.h : 30.h,
        margin: EdgeInsets.only(bottom: 0.5.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(Styles.mdRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey20.withValues(alpha: 0.6),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Styles.mdRadius),
                    topRight: Radius.circular(Styles.mdRadius),
                  ),
                  child: Image.network(
                    imageUrl,
                    width: isCompact ? 40.w : 45.w,
                    height: isCompact ? 11.h : 13.h,
                    fit: BoxFit.cover,
                  ),
                ),

                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Styles.mdRadius),
                    topRight: Radius.circular(Styles.mdRadius),
                  ),
                  child: Container(
                    width: isCompact ? 40.w : 45.w,
                    height: isCompact ? 9.h : 10.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),
                // Favorite button
                Positioned(
                  top: Styles.xsPadding,
                  right: Styles.xsPadding,
                  child: GestureDetector(
                    onTap: onFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color:
                            isFavorite ? AppColors.danger50 : AppColors.grey40,
                      ),
                    ),
                  ),
                ),
                // Like count badge
                Positioned(
                  bottom: Styles.xsPadding,
                  left: Styles.xsPadding,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 12,
                          color: AppColors.danger50,
                        ),
                        SizedBox(width: 4),
                        Text(
                          likeCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Content section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppColors.success50,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.grey50,
                                  fontSize: 11,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Show distance if available
                        if (distance != null) ...[
                          SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              distance!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 10),
                    // Category badge
                    if (kategori != null && kategori!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary10,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          kategori!,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.primary50,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
