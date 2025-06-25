import 'package:geolocator/geolocator.dart';
import '../models/destination_model.dart';

class LocationService {

  /// Check and request location permissions
  static Future<bool> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Get current user location
  static Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return null;
      }      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 25),
      );

      return position;
    } catch (e) {
      // Error saat mendapatkan lokasi
      return null;
    }
  }


  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }
  static List<DestinationModel> filterByDistance(
    List<DestinationModel> destinations,
    Position userLocation,
    double radiusKm,
  ) {
    List<DestinationModel> nearbyDestinations = [];

    for (var destination in destinations) {
      double distance = calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        destination.location.latitude,
        destination.location.longitude,
      );

      if (distance <= radiusKm) {
        nearbyDestinations.add(destination);
      }
    }

    // Urutkan berdasarkan jarak (terdekat dulu)
    nearbyDestinations.sort((a, b) {
      double distanceA = calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        a.location.latitude,
        a.location.longitude,
      );
      double distanceB = calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        b.location.latitude,
        b.location.longitude,
      );
      return distanceA.compareTo(distanceB);
    });

    return nearbyDestinations;
  }

  /// Get formatted distance string
  static String getDistanceString(
    Position userLocation,
    DestinationModel destination,
  ) {
    double distance = calculateDistance(
      userLocation.latitude,
      userLocation.longitude,
      destination.location.latitude,
      destination.location.longitude,
    );

    if (distance < 1) {
      return '${(distance * 1000).round()}m away';
    } else {
      return '${distance.toStringAsFixed(1)}km away';
    }
  }

  /// Open device location settings
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Get location permission status
  static Future<LocationPermission> getLocationPermissionStatus() async {
    return await Geolocator.checkPermission();
  }
}

/// Extension to add distance-related methods to DestinationModel
extension DestinationModelDistance on DestinationModel {
  double distanceFrom(Position userLocation) {
    return LocationService.calculateDistance(
      userLocation.latitude,
      userLocation.longitude,
      location.latitude,
      location.longitude,
    );
  }

  String distanceStringFrom(Position userLocation) {
    return LocationService.getDistanceString(userLocation, this);
  }
}
