import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'featured_banner.dart';

class HomeFeaturedBanner extends StatelessWidget {
  const HomeFeaturedBanner({Key? key}) : super(key: key);

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://museumnasional.iheritage-virtual.id/vr/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FeaturedBanner(
      title: "Travel Through Indonesia's Cultural History",
      image: "assets/banner/museum_indonesia.png",
      buttonText: "Explore Now",
      onTap: _launchUrl,
    );
  }
}