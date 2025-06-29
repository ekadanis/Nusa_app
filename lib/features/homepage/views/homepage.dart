import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:nusa_app/features/homepage/widgets/quiz_card.dart';
import 'package:nusa_app/util/extensions.dart';
import 'package:nusa_app/core/services/fcm_service.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../../core/styles.dart';
import '../../../core/app_colors.dart';
import '../../../widgets/custom_search.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_featured_banner.dart';
import '../widgets/categories_section.dart';
import '../widgets/generic_section.dart';
import '../widgets/generic_section/filter_chips_row.dart';
import '../widgets/generic_section/radius_bottom_sheet.dart';
import '../../../models/models.dart';
import '../../../services/firestore_service.dart';
import '../../../services/google_auth_service.dart';
import '../../../services/location_service.dart';
import '../widgets/location_permission_dialog.dart';
import '../widgets/generic_section/generic_section_controller.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  List<CategoryModel> _categoriesData = [];
  Map<String, List<DestinationModel>> _destinationsByCategory = {};
  bool _hasShownLocationPopup = false;

  List<DestinationModel> _searchResults = [];
  bool _isSearching = false;

  String _globalSelectedFilter = "Discover";
  Position? _globalUserLocation;
  bool _globalIsLoadingLocation = false;
  double _globalSelectedRadius = GenericSectionController.defaultRadius;

  @override
  void initState() {
    super.initState();
    FCMService.setupOnMessageListener();
    FirebaseMessaging.instance.getToken().then((token) {
      print("🎯 My FCM Token: $token");
    });
    _fetchAndFilterFirebaseData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowLocationPopup();
    });
  }

  Future<void> _checkAndShowLocationPopup() async {
    if (_hasShownLocationPopup) return;

    bool isLocationEnabled = await _checkLocationStatus();

    if (!isLocationEnabled && mounted) {
      _showLocationPermissionDialog();
    }

    _hasShownLocationPopup = true;
  }

  Future<bool> _checkLocationStatus() async {
    return false;
  }

  void _showLocationPermissionDialog() {
    LocationPermissionDialog.show(
      context,
      onEnablePressed: _onLocationEnabled,
      onMaybeLaterPressed: () {
        // Handle maybe later action if needed
      },
      barrierDismissible: false,
    );
  }

  void _onLocationEnabled() {
    _loadGlobalUserLocation();
  }

  Future<void> _fetchAndFilterFirebaseData() async {
    try {
      final categories = await FirestoreService.getCategories();
      Map<String, List<DestinationModel>> tempDestinationsByCategory = {};

      for (var category in categories) {
        final destinations = await FirestoreService.getDestinationsByCategory(
            category.id!,
            limit: 5);
        final filteredDestinations = await _applyGlobalFilter(destinations);
        tempDestinationsByCategory[category.categoryName] =
            filteredDestinations;
      }

      setState(() {
        _categoriesData = categories;
        _destinationsByCategory = tempDestinationsByCategory;
      });
    } catch (e) {
      print("Error fetching and filtering firebase data: $e");
    }
  }

  Future<List<DestinationModel>> _applyGlobalFilter(
      List<DestinationModel> items) async {
    if (_globalSelectedFilter == "Nearby" && _globalUserLocation != null) {
      return await GenericSectionController.filterNearbyItems(
        itemsToFilter: items,
        userLocation: _globalUserLocation!,
        radius: _globalSelectedRadius,
      );
    } else {
      return GenericSectionController.filterItemsSync(
        items,
        _globalSelectedFilter,
      );
    }
  }

  Future<void> _onGlobalFilterSelected(String filter) async {
    setState(() {
      _globalSelectedFilter = filter;
    });
    await _fetchAndFilterFirebaseData();
  }

  Future<void> _onGlobalNearbyTapped() async {
    if (_globalUserLocation == null) {
      await _loadGlobalUserLocation();
    }
    if (_globalUserLocation != null) {
      _onGlobalFilterSelected("Nearby");
    }
  }

  Future<void> _loadGlobalUserLocation() async {
    setState(() {
      _globalIsLoadingLocation = true;
    });

    try {
      Position? position = await LocationService.getCurrentLocation();
      if (position != null && mounted) {
        setState(() {
          _globalUserLocation = position;
        });
        if (_globalSelectedFilter == "Nearby") {
          await _fetchAndFilterFirebaseData();
        }
      }
    } catch (e) {
      debugPrint('ERROR: Error loading global location: $e');
    } finally {
      if (mounted) {
        setState(() {
          _globalIsLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _refreshGlobalUserLocation() async {
    setState(() {
      _globalUserLocation = null;
      _globalIsLoadingLocation = true;
    });

    try {
      Position? position = await LocationService.getCurrentLocation();
      if (position != null && mounted) {
        setState(() {
          _globalUserLocation = position;
        });
        if (_globalSelectedFilter == "Nearby") {
          await _fetchAndFilterFirebaseData();
        }
      } else {
        throw Exception('Unable to get current location');
      }
    } catch (e) {
      debugPrint('ERROR: Error refreshing global location: $e');
      rethrow;
    } finally {
      if (mounted) {
        setState(() {
          _globalIsLoadingLocation = false;
        });
      }
    }
  }

  void _showGlobalRadiusBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => RadiusBottomSheet(
        initialRadius: _globalSelectedRadius,
        onRadiusChanged: (radius) async {
          setState(() {
            _globalSelectedRadius = radius;
          });
          if (_globalSelectedFilter == "Nearby") {
            await _fetchAndFilterFirebaseData();
          }
        },
        onRefreshLocation: _refreshGlobalUserLocation,
      ),
    );
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await FirestoreService.searchDestinationsByTitle(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print("ERROR: Terjadi kesalahan saat melakukan pencarian: $e");
      setState(() {
        _searchResults = [];
      });
    }
  }

  List<Map<String, String>> _getCategories() {
    if (_categoriesData.isNotEmpty) {
      final categoryOrder = [
        "Cultural Sites",
        "Arts & Culture",
        "Folk Instruments",
        "Traditional Wear",
        "Crafts & Artifacts",
        "Local Foods",
      ];

      final sortedCategories = <CategoryModel>[];
      for (String categoryName in categoryOrder) {
        final category = _categoriesData.firstWhere(
          (cat) => cat.categoryName == categoryName,
          orElse: () => CategoryModel(categoryName: categoryName),
        );
        if (category.categoryName.isNotEmpty) {
          sortedCategories.add(category);
        }
      }

      return sortedCategories
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
    final categories = _getCategories();

    return Scaffold(
      backgroundColor: AppColors.primary50,
      body: Stack(
        children: [
          // Background layer with HomeAppBar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HomeAppBar(),
          ),

          // White container layer
          Positioned(
            top: 18.h, // Adjust this value to move container up/down
            left: 0,
            right: 0,
            bottom: 0,
            child: Material(
              elevation: 20,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: ClipRRect(
                // Tambahkan ClipRRect di sini
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: RefreshIndicator(
                    onRefresh: _fetchAndFilterFirebaseData,
                    color: AppColors.primary50,
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              SizedBox(height: 4.h),
                              const HomeFeaturedBanner(),
                              SizedBox(height: 2.h),
                              const CategoriesSection(),
                              SizedBox(height: 2.h),
                              QuizCard(),
                              SizedBox(height: 2.h),
                            ],
                          ),
                        ),
                        if (!_isSearching)
                          SliverStickyHeader(
                            header: Container(
                              padding: EdgeInsets.only(top: 3.1.h, bottom: 1.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // borderRadius: BorderRadius.circular(
                                //     Bottom), // Border radius for filter background
                              ),
                              child: FilterChipsRow(
                                selectedFilter: _globalSelectedFilter,
                                isLoadingLocation: _globalIsLoadingLocation,
                                hasUserLocation: _globalUserLocation != null,
                                selectedRadius: _globalSelectedRadius,
                                onFilterSelected: _onGlobalFilterSelected,
                                onNearbyTapped: _onGlobalNearbyTapped,
                                onRadiusTapped: _showGlobalRadiusBottomSheet,
                              ),
                            ),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  SizedBox(height: 1.h),
                                  for (var category in categories) ...[
                                    GenericSection(
                                      key: ValueKey(
                                          'categorySection_${category["categoryName"]!}_$_globalSelectedFilter'),
                                      title: category["title"]!,
                                      categoryName: category["categoryName"]!,
                                      items: _getDestinationsForSection(
                                          category["categoryName"]!),
                                      userId: GoogleAuthService
                                          .getAuthenticatedUserId(),
                                      locationIcon: Icon(
                                        IconsaxPlusBold.location,
                                        color: AppColors.success50,
                                        size: 16,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                  ],
                                  SizedBox(height: 4.h),
                                  const SizedBox(height: 80),
                                ],
                              ),
                            ),
                          ),
                        if (_isSearching)
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                SizedBox(height: 2.h),
                                if (_searchResults.isNotEmpty)
                                  GenericSection(
                                    key: ValueKey(
                                        'searchResultsSection_${_searchController.text}'),
                                    title:
                                        "Search Results for '${_searchController.text}'",
                                    categoryName: 'SearchResults',
                                    items: _searchResults,
                                    userId: GoogleAuthService
                                        .getAuthenticatedUserId(),
                                    locationIcon: Icon(
                                      IconsaxPlusBold.location,
                                      color: AppColors.success50,
                                      size: 16,
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: EdgeInsets.all(Styles.mdPadding),
                                    child: Center(
                                      child: Text(
                                        "No destinations found for '${_searchController.text}'",
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(color: AppColors.black),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 2.h),
                                SizedBox(height: 4.h),
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Search bar layer
          Positioned(
            top: 15.h, // Adjust this value to move search bar up/down
            left: Styles.mdPadding,
            right: Styles.mdPadding,
            child: Material(
              elevation: 10,
              shadowColor: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              child: SearchWidget(
                hintText: "Find your culture",
                controller: _searchController,
                onChanged: (text) {
                  _performSearch(text);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
