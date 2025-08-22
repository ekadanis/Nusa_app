import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/util/extensions.dart';
import 'package:nusa_app/widgets/back_button.dart';
import '../../../models/destination_model.dart';

class DestinationHeader extends StatelessWidget {
  final DestinationModel destination;

  const DestinationHeader({
    Key? key,
    required this.destination,
  }) : super(key: key);

  Future<void> _openMaps(BuildContext context) async {
    final latitude = destination.location.latitude;
    final longitude = destination.location.longitude;

    final googleMapsUrl = 'google.navigation:q=$latitude,$longitude';
    final webMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    try {
      final googleMapsUri = Uri.parse(googleMapsUrl);
      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri);
      } else {
        // Fallback to web maps
        final webMapsUri = Uri.parse(webMapsUrl);
        await launchUrl(webMapsUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error opening maps: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open maps application'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      child: SizedBox(
        height: 30.h,
        width: 100.w,
        child: Stack(
          children: [
            // Background Image
            Container(
              width: 100.w,
              child: Image.network(
                destination.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.grey20,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: AppColors.grey40,
                    ),
                  );
                },
              ),
            ),
            // Dark overlay
            Container(
              width: 100.w,
              height: 30.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(25, 0, 0, 0),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // Back Button
            Positioned(
              top: 5.h,
              left: 5.w,
              child: CustomBackButton(
                backgroundColor: AppColors.grey60.withOpacity(0.3),
                onPressed: () {
                  context.router.maybePop();
                },
                iconColor: AppColors.grey10,
              ),
            ),
            // Title and Location
            Positioned(
              bottom: 3.h,
              left: 5.w,
              right: 5.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.title,
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () => _openMaps(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                children: [
                                  // Black shadow positioned slightly offset
                                  Positioned(
                                    left: 1.5,
                                    top: 1.5,
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.black.withOpacity(0.8),
                                      size: 16,
                                    ),
                                  ),
                                  // Main green icon
                                  Icon(
                                    Icons.location_on,
                                    color: AppColors.success50,
                                    size: 16,
                                  ),
                                ],
                              ),
                              SizedBox(width: 1.w),
                              Expanded(
                                child: Text(
                                  destination.address,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.7),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
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
                            SizedBox(width: 1.w),
                            Text(
                              destination.like.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
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
