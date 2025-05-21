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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(22.h),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const HomeAppBar(),
            Positioned(
              top: 16.5.h,
              left: Styles.mdPadding,
              right: Styles.mdPadding,
              child: Material(
                elevation: 10,
                shadowColor: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
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
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: Styles.lgSpacing),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(bottom: 24),
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(height: Styles.xsSpacing),
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
          ],
        ),
      ),
    );
  }
}
