import 'package:flutter/material.dart';
import 'location_banner.dart';

class HomeLocationBanner extends StatelessWidget {
  const HomeLocationBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LocationBanner(
      title: "Explore Culture With Nusa",
      subtitle: "Bring Your Cultural Journey from Your Location",
      onTap: null,
    );
  }
}