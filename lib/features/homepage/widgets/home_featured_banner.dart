import 'package:flutter/material.dart';
import 'featured_banner.dart';

class HomeFeaturedBanner extends StatelessWidget {
  const HomeFeaturedBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FeaturedBanner(
      title: "Step Inside Indonesia's Cultural Treasure",
      imageUrl: "https://images.unsplash.com/photo-1604999286549-9877dea7ac0a",
      buttonText: "Explore Now",
      onTap: () {},
    );
  }
}