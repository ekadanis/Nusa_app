import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:auto_route/auto_route.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/app_colors.dart';
import '../../../../widgets/site_card.dart';
import '../../../../routes/router.dart';
import '../../../../models/destination_model.dart';
import '../../../../services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class ItemsListWidget extends StatelessWidget {
  final List<DestinationModel> items;
  final Map<String, int> likeCount;
  final Map<String, bool> favoriteStatus;
  final String selectedFilter;
  final Position? userLocation;
  final Widget? locationIcon;
  final Function(DestinationModel) onToggleFavorite;

  const ItemsListWidget({
    Key? key,
    required this.items,
    required this.likeCount,
    required this.favoriteStatus,
    required this.selectedFilter,
    required this.onToggleFavorite,
    this.userLocation,
    this.locationIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: IntrinsicHeight(
        child: Row(
          children: items.map((item) {
            // Calculate distance for display when using nearby filter
            String? distanceText;
            if (selectedFilter == "Nearby" && userLocation != null) {
              distanceText =
                  LocationService.getDistanceString(userLocation!, item);
            }

            return Padding(
              padding: EdgeInsets.only(
                right: item == items.last ? 0 : 4.w,
              ),
              child: SiteCard(
                title: item.title,
                location: item.address,
                imageUrl: item.imageUrl,
                likeCount: likeCount[item.id] ?? item.like,
                onTap: () {
                  debugPrint('Tapped on: ${item.title}');
                  context.router
                      .push(DetailRouteDestination(destination: item));
                },
                onFavorite: () => onToggleFavorite(item),
                isFavorite: favoriteStatus[item.id] ?? false,
                kategori: item.subcategory,
                isCompact: true,
                distance: distanceText,
                locationIcon: locationIcon ??
                    Icon(
                      IconsaxPlusBold.location,
                      color: AppColors.success50,
                      size: 16,
                    ),
                categoryId: item.categoryId,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
