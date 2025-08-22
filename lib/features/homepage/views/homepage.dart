import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../core/styles.dart';
import '../../../core/app_colors.dart';
import '../../../widgets/custom_search.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_featured_banner.dart';
import '../widgets/home_location_banner.dart';
import '../widgets/categories_section.dart';
import '../widgets/generic_section.dart';
import '../widgets/quiz_card.dart';
import '../../../models/models.dart';
import '../../../services/firestore_service.dart';
import '../../../services/google_auth_service.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, GlobalKey<GenericSectionState>> _sectionKeys = {};

  List<CategoryModel> _categoriesData = [];
  Map<String, List<DestinationModel>> _destinationsByCategory = {};

  @override
  void initState() {
    super.initState();
    _fetchFirebaseData();
  }

  void _onLocationEnabled() {
    // Trigger location update for all sections
    for (var key in _sectionKeys.values) {
      GenericSection.refreshLocationForKey(key);
    }
  }

  Future<void> _fetchFirebaseData() async {
    try {
      final categories = await FirestoreService.getCategories();

      Map<String, List<DestinationModel>> destinationsByCategory = {};
      for (var category in categories) {
        final destinations = await FirestoreService.getDestinationsByCategory(
            category.id!,
            limit: 5);
        destinationsByCategory[category.categoryName] = destinations;
      }

      setState(() {
        _categoriesData = categories;
        _destinationsByCategory = destinationsByCategory;
      });
    } catch (e) {
      // Handle error silently
    }
  }

  List<Map<String, String>> _getCategories() {
    if (_categoriesData.isNotEmpty) {
      return _categoriesData
          .map((category) => {
                "title": category.categoryName,
                "categoryName": category.categoryName,
              })
          .toList();
    }

    return [
      {"title": "Cultural Sites", "categoryName": "Cultural Sites"},
      {"title": "Arts & Culture", "categoryName": "Arts & Culture"},
      {"title": "Folk Instruments", "categoryName": "Folk Instruments"},
      {"title": "Traditional Wear", "categoryName": "Traditional Wear"},
      {"title": "Crafts & Artifacts", "categoryName": "Crafts & Artifacts"},
      {"title": "Local Foods", "categoryName": "Local Foods"},
    ];
  }

  List<DestinationModel> _getDestinationsForSection(String categoryName) {
    return _destinationsByCategory[categoryName] ?? [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _getCategories();    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        // Exit the app when back is pressed on homepage
        SystemNavigator.pop();
      },
      child: Scaffold(
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
                        // Handle search input
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
                child: RefreshIndicator(
                  onRefresh: _fetchFirebaseData,
                  color: AppColors.primary50,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(height: Styles.xsSpacing),
                      const CategoriesSection(),
                      const SizedBox(height: Styles.smSpacing),
                      const QuizCard(), // Quiz card baru ditambahkan
                      const SizedBox(height: Styles.smSpacing),
                      const HomeFeaturedBanner(),
                      const SizedBox(height: Styles.smSpacing),
                      HomeLocationBanner(
                        onLocationEnabled: _onLocationEnabled,
                      ),
                      const SizedBox(height: Styles.smSpacing),
                      for (var category in categories) ...[
                        GenericSection(
                          key: _sectionKeys.putIfAbsent(
                            category["categoryName"]!,
                            () => GlobalKey<GenericSectionState>(),
                          ),
                          title: category["title"]!,
                          categoryName: category["categoryName"]!,
                          items: _getDestinationsForSection(
                              category["categoryName"]!),
                          userId: GoogleAuthService.getAuthenticatedUserId(),
                          locationIcon: Icon(
                            IconsaxPlusBold.location,
                            color: AppColors.success50,
                            size: 16,
                          ),
                        ),
                        const SizedBox(height: Styles.smSpacing),
                      ],

                      const SizedBox(height: Styles.xlSpacing),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
