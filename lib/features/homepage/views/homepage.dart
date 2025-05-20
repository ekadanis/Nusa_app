import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sizer/sizer.dart';
import '../../../core/styles.dart';
import '../../../widgets/custom_search.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_featured_banner.dart';
import '../widgets/home_location_banner.dart';
import '../widgets/cultural_sites_section.dart';
import '../widgets/folk_instruments_section.dart';
import '../widgets/traditional_wear_section.dart';
import '../widgets/crafts_artifacts_section.dart';
import '../widgets/local_foods_section.dart';
import '../widgets/batik_section.dart';
import '../widgets/categories_section.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                        SizedBox(height: Styles.mdSpacing),
                        const CategoriesSection(),
                        const SizedBox(height: Styles.smSpacing),
                        const HomeFeaturedBanner(),
                        const SizedBox(height: Styles.smSpacing),
                        const HomeLocationBanner(),
                        const SizedBox(height: Styles.smSpacing),
                        const CulturalSitesSection(),
                        const SizedBox(height: Styles.smSpacing),
                        const BatikSection(),
                        const SizedBox(height: Styles.smSpacing),
                        const FolkInstrumentsSection(),
                        const SizedBox(height: Styles.smSpacing),
                        const TraditionalWearSection(),
                        const SizedBox(height: Styles.smSpacing),
                        const CraftsArtifactsSection(),
                        const SizedBox(height: Styles.smSpacing),
                        const LocalFoodsSection(),
                        const SizedBox(height: Styles.xlSpacing),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 15.h,
              left: 0,
              right: 0,
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Styles.mdPadding),
                  child: SearchWidget(
                    hintText: "Find your culture",
                    controller: _searchController,
                    onChanged: (text) {
                      debugPrint('Search text: $text');
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
