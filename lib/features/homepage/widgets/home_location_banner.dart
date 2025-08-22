import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'location_banner.dart';
import '../../../services/location_service.dart';
import '../../../services/shared_location_service.dart';
import '../../../util/extensions.dart';

class HomeLocationBanner extends StatefulWidget {
  final VoidCallback? onLocationEnabled;
  
  const HomeLocationBanner({
    Key? key,
    this.onLocationEnabled,
  }) : super(key: key);

  @override
  State<HomeLocationBanner> createState() => _HomeLocationBannerState();
}

class _HomeLocationBannerState extends State<HomeLocationBanner> {
  bool _isLoading = false;
  Future<void> _handleLocationTap() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool serviceEnabled = await LocationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          context.showSnackBar(
            message: 'Please enable location services in device settings',
            isSuccess: false,
          );
          await LocationService.openLocationSettings();
        }
        return;
      }

      // Use shared location service
      Position? position = await SharedLocationService().loadLocation();
      
      if (position != null && mounted) {
        context.showSnackBar(
          message: 'Location enabled! You can now filter nearby destinations',
          isSuccess: true,
        );

        widget.onLocationEnabled?.call();
      } else {
        if (mounted) {
          context.showSnackBar(
            message: 'Unable to get location. Please check permissions',
            isSuccess: false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar(
          message: 'Error accessing location: ${e.toString()}',
          isSuccess: false,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LocationBanner(
      title: "Explore Culture With Nusa",
      subtitle: _isLoading 
          ? "Getting your location..." 
          : "Bring Your Cultural Journey from Your Location",
      onTap: _isLoading ? null : _handleLocationTap,
    );
  }
}