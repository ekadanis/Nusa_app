import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'location_service.dart';

/// Singleton service to manage location state across the app
class SharedLocationService {
  static final SharedLocationService _instance = SharedLocationService._internal();
  factory SharedLocationService() => _instance;
  SharedLocationService._internal();

  Position? _currentLocation;
  bool _isLocationLoading = false;
  final _locationController = StreamController<Position?>.broadcast();

  /// Stream to listen for location updates
  Stream<Position?> get locationStream => _locationController.stream;

  /// Get current location (cached if available)
  Position? get currentLocation => _currentLocation;

  /// Check if location is currently being loaded
  bool get isLocationLoading => _isLocationLoading;

  /// Check if location is available
  bool get hasLocation => _currentLocation != null;

  /// Load user location (will use cache if available)
  Future<Position?> loadLocation() async {
    // Return cached location if available
    if (_currentLocation != null) {
      return _currentLocation;
    }

    // Don't load if already loading
    if (_isLocationLoading) {
      return _currentLocation;
    }

    _isLocationLoading = true;
    
    try {
      final position = await LocationService.getCurrentLocation();
      _currentLocation = position;
      
      // Notify all listeners
      _locationController.add(_currentLocation);
      
      return _currentLocation;
    } finally {
      _isLocationLoading = false;
    }
  }

  /// Clear location cache (force reload on next request)
  void clearLocation() {
    _currentLocation = null;
    _locationController.add(null);
  }

  /// Dispose resources
  void dispose() {
    _locationController.close();
  }
}
