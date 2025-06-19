import 'package:flutter/material.dart'; // Needed for debugPrint
import 'package:geolocator/geolocator.dart';
import 'dart:math'; // For max function

import '../../../../models/destination_model.dart';
import '../../../../services/firestore_service.dart';
import '../../../../services/location_service.dart';

class GenericSectionController {
  static const double defaultRadius = 500.0;

  static List<DestinationModel> filterItemsSync(
      List<DestinationModel> items,
      String filter,
      ) {
    debugPrint('DEBUG GenericSectionController: Applying sync filter: $filter to ${items.length} items');
    List<DestinationModel> filteredItems = List.from(items);

    switch (filter) {
      case "Most Like":
        filteredItems.sort((a, b) => b.like.compareTo(a.like));
        debugPrint('DEBUG GenericSectionController: Filtered by Most Like. First item like: ${filteredItems.isNotEmpty ? filteredItems.first.like : 'N/A'}');
        break;
      case "Recommended":
        filteredItems.sort((a, b) {
          int recommendationComparison = b.recommendation.compareTo(a.recommendation);
          if (recommendationComparison != 0) {
            return recommendationComparison;
          }
          return b.like.compareTo(a.like);
        });
        debugPrint('DEBUG GenericSectionController: Filtered by Recommended. First item recommendation: ${filteredItems.isNotEmpty ? filteredItems.first.recommendation : 'N/A'}');
        break;
      case "Discover":
      default:
        debugPrint('DEBUG GenericSectionController: No specific sync filter applied (Discover/Default).');
        break;
    }

    return filteredItems;
  }

  // === Perbaikan di sini: Menerima itemsToFilter daripada categoryName ===
  static Future<List<DestinationModel>> filterNearbyItems({
    required List<DestinationModel> itemsToFilter, // Mengganti categoryName dengan list item
    required Position userLocation,
    required double radius,
  }) async {
    try {
      debugPrint('DEBUG GenericSectionController: Applying Nearby filter to ${itemsToFilter.length} items.');
      debugPrint('DEBUG GenericSectionController: User location: ${userLocation.latitude}, ${userLocation.longitude}, Radius: $radius km');

      // Filter by distance langsung pada list yang sudah diberikan
      final nearbyDestinations = LocationService.filterByDistance(
        itemsToFilter, // Gunakan itemsToFilter
        userLocation,
        radius,
      );

      debugPrint('DEBUG GenericSectionController: Found ${nearbyDestinations.length} destinations within $radius km (Nearby filter).');

      return nearbyDestinations;
    } catch (e) {
      debugPrint('ERROR GenericSectionController: Error filtering nearby destinations: $e');
      return [];
    }
  }

  static void initializeLikeCounts(
      List<DestinationModel> items,
      Map<String, int> likeCount,
      ) {
    debugPrint('DEBUG GenericSectionController: Initializing like counts for ${items.length} items.');
    for (var item in items) {
      if (item.id != null) {
        likeCount[item.id!] = item.like;
      }
    }
    debugPrint('DEBUG GenericSectionController: Like counts initialized.');
  }

  static Future<void> loadFavoriteStatus(
      List<DestinationModel> items,
      String? userId,
      Map<String, bool> favoriteStatus,
      Function(VoidCallback) setState,
      ) async {
    debugPrint('DEBUG GenericSectionController: Loading favorite status for ${items.length} items. User ID: $userId');
    if (userId != null) {
      for (var item in items) {
        if (item.id != null) {
          try {
            final isFavorite = await FirestoreService.hasUserLikedDestination(
              userId,
              item.id!,
            );
            setState(() {
              favoriteStatus[item.id!] = isFavorite;
            });
          } catch (e) {
            debugPrint('ERROR GenericSectionController: Error loading favorite status for item ${item.id}: $e');
          }
        }
      }
    } else {
      debugPrint('DEBUG GenericSectionController: User ID is null, skipping loading favorite status.');
    }
    debugPrint('DEBUG GenericSectionController: Favorite status loaded.');
  }

  static Future<void> toggleFavorite(
      DestinationModel item,
      String? userId,
      Map<String, bool> favoriteStatus,
      Map<String, int> likeCount,
      Function(VoidCallback) setState,
      ) async {
    debugPrint('DEBUG GenericSectionController: Toggling favorite for item: ${item.title}');
    if (userId != null && item.id != null) {
      try {
        await FirestoreService.toggleDestinationLike(userId, item.id!);

        setState(() {
          final isCurrentlyFavorite = favoriteStatus[item.id!] ?? false;
          favoriteStatus[item.id!] = !isCurrentlyFavorite;

          // Update like count
          final currentLikeCount = likeCount[item.id!] ?? item.like;
          if (!isCurrentlyFavorite) {
            likeCount[item.id!] = currentLikeCount + 1;
            debugPrint('DEBUG GenericSectionController: Incremented like for ${item.title} to ${likeCount[item.id!]}');
          } else {
            // Menggunakan max(0, ...) untuk memastikan like tidak negatif
            likeCount[item.id!] = max(0, currentLikeCount - 1);
            debugPrint('DEBUG GenericSectionController: Decremented like for ${item.title} to ${likeCount[item.id!]}');
          }
        });

        debugPrint('DEBUG GenericSectionController: Favorite toggled for: ${item.title}, new status: ${favoriteStatus[item.id!]}, new like count: ${likeCount[item.id!]}');
      } catch (e) {
        debugPrint('ERROR GenericSectionController: Error toggling favorite for ${item.title}: $e');
      }
    } else {
      debugPrint('DEBUG GenericSectionController: Cannot toggle favorite. User ID or Item ID is null.');
    }
  }
}
