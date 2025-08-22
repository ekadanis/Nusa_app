import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../models/destination_model.dart';
import '../../../../services/firestore_service.dart';
import '../../../../services/location_service.dart';

class GenericSectionController {
  static const double defaultRadius = 500.0;

  static List<DestinationModel> filterItemsSync(
    List<DestinationModel> items,
    String filter,
  ) {
    List<DestinationModel> filteredItems = List.from(items);

    switch (filter) {
      case "Most Like":
        filteredItems.sort((a, b) => b.like.compareTo(a.like));
        break;
      case "Recommended":
        filteredItems.sort((a, b) {
          int recommendationComparison = b.recommendation.compareTo(a.recommendation);
          if (recommendationComparison != 0) {
            return recommendationComparison;
          }
          return b.like.compareTo(a.like);
        });
        break;
      case "Discover":
      default:
        break;
    }

    return filteredItems;
  }

  static Future<List<DestinationModel>> filterNearbyItems({
    required String categoryName,
    required Position userLocation,
    required double radius,
  }) async {
    try {
      debugPrint('Fetching ALL destinations for category: $categoryName');

      // Find the category ID first
      final categories = await FirestoreService.getCategories();
      final category = categories.firstWhere(
        (cat) => cat.categoryName == categoryName,
        orElse: () => throw Exception('Category not found'),
      );

      // Fetch ALL destinations from this category
      final allDestinations = await FirestoreService.getDestinationsByCategory(
        category.id!,
        limit: 1000, // Large limit to get all destinations
      );

      debugPrint('Fetched ${allDestinations.length} total destinations for $categoryName');
      debugPrint('User location: ${userLocation.latitude}, ${userLocation.longitude}');

      // Filter by distance
      final nearbyDestinations = LocationService.filterByDistance(
        allDestinations,
        userLocation,
        radius,
      );

      debugPrint('Found ${nearbyDestinations.length} destinations within $radius km');

      return nearbyDestinations;
    } catch (e) {
      debugPrint('Error fetching nearby destinations: $e');
      return [];
    }
  }
  static void initializeLikeCounts(
    List<DestinationModel> items,
    Map<String, int> likeCount,
  ) {
    for (var item in items) {
      if (item.id != null) {
        likeCount[item.id!] = item.like;
      }
    }
  }

  static Future<void> loadFavoriteStatus(
    List<DestinationModel> items,
    String? userId,
    Map<String, bool> favoriteStatus,
    Function(VoidCallback) setState,
  ) async {
    if (userId != null) {
      for (var item in items) {
        if (item.id != null) {
          final isFavorite = await FirestoreService.hasUserLikedDestination(
            userId,
            item.id!,
          );
          setState(() {
            favoriteStatus[item.id!] = isFavorite;
          });
        }
      }
    }
  }

  static Future<void> toggleFavorite(
    DestinationModel item,
    String? userId,
    Map<String, bool> favoriteStatus,
    Map<String, int> likeCount,
    Function(VoidCallback) setState,
  ) async {
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
          } else {
            likeCount[item.id!] = (currentLikeCount - 1).clamp(0, double.infinity).toInt();
          }
        });

        debugPrint('Favorite toggled for: ${item.title}, new like count: ${likeCount[item.id!]}');
      } catch (e) {
        debugPrint('Error toggling favorite: $e');
      }
    }
  }
}
