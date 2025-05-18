import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sizer/sizer.dart';
import '../../../core/styles.dart';
import '../../../widgets/search_category_card.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_featured_banner.dart';
import '../widgets/home_location_banner.dart';
import '../widgets/cultural_sites_section.dart';
import '../widgets/batik_section.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                const HomeAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        const SizedBox(height: Styles.smSpacing),
                        const HomeFeaturedBanner(),
                        const SizedBox(height: Styles.smSpacing),
                        const HomeLocationBanner(),
                        const SizedBox(height: Styles.mdSpacing),
                        const CulturalSitesSection(),
                        const SizedBox(height: Styles.mdSpacing),
                        const BatikSection(),
                        const SizedBox(height: Styles.xlSpacing),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 12.h,
              left: 0,
              right: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Styles.mdPadding),
                child: SearchCategoryCard(
                  hintText: "Find your culture",
                  onSearchTap: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
