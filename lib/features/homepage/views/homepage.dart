import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:nusa_app/features/homepage/widgets/quiz_card.dart';
import 'package:nusa_app/util/extensions.dart';
import 'package:nusa_app/core/services/fcm_service.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:geolocator/geolocator.dart'; // Import for Position
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../../core/styles.dart';
import '../../../core/app_colors.dart';
import '../../../widgets/custom_search.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_featured_banner.dart';
import '../widgets/categories_section.dart';
import '../widgets/generic_section.dart';
import '../widgets/generic_section/filter_chips_row.dart'; // Import FilterChipsRow
import '../widgets/generic_section/radius_bottom_sheet.dart'; // Import RadiusBottomSheet
import '../../../models/models.dart';
import '../../../services/firestore_service.dart';
import '../../../services/google_auth_service.dart';
import '../../../services/location_service.dart'; // Import LocationService
import '../widgets/location_permission_dialog.dart';
import '../widgets/generic_section/generic_section_controller.dart'; // Import GenericSectionController

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

  // === START: State baru untuk pencarian ===
  List<DestinationModel> _searchResults = [];
  bool _isSearching = false; // Indikator apakah mode pencarian aktif
  // === END: State baru untuk pencarian ===

  // === START: State Global untuk Filter ===
  String _globalSelectedFilter = "Discover";
  Position? _globalUserLocation;
  bool _globalIsLoadingLocation = false;
  double _globalSelectedRadius = GenericSectionController.defaultRadius;
  // === END: State Global untuk Filter ===


  @override
  void initState() {
    super.initState();
    FCMService.setupOnMessageListener();
    FirebaseMessaging.instance.getToken().then((token) {
      print("🎯 My FCM Token: $token");
    });
    _fetchAndFilterFirebaseData(); // Memanggil fungsi baru yang juga memfilter
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
    // Implementasi placeholder, bisa diganti dengan cek geolocator langsung
    // Misalnya: return await Geolocator.isLocationServiceEnabled();
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
    // Memuat lokasi global setelah izin diberikan
    _loadGlobalUserLocation();
    // Tidak perlu lagi loop _sectionKeys karena filter terpusat
  }

  Future<void> _fetchAndFilterFirebaseData() async {
    try {
      final categories = await FirestoreService.getCategories();
      Map<String, List<DestinationModel>> tempDestinationsByCategory = {};

      for (var category in categories) {
        final destinations = await FirestoreService.getDestinationsByCategory(
            category.id!,
            limit: 5);
        // Terapkan filter global ke setiap kategori
        final filteredDestinations = await _applyGlobalFilter(destinations);
        tempDestinationsByCategory[category.categoryName] = filteredDestinations;
      }

      setState(() {
        _categoriesData = categories;
        _destinationsByCategory = tempDestinationsByCategory;
      });
    } catch (e) {
      print("Error fetching and filtering firebase data: $e");
    }
  }

  // === START: Fungsi Global Filter ===
  Future<List<DestinationModel>> _applyGlobalFilter(List<DestinationModel> items) async {
    if (_globalSelectedFilter == "Nearby" && _globalUserLocation != null) {
      // Memanggil filter Nearby dari GenericSectionController
      return await GenericSectionController.filterNearbyItems(
        itemsToFilter: items,
        userLocation: _globalUserLocation!,
        radius: _globalSelectedRadius,
      );
    } else {
      // Memanggil filter sinkron untuk Discover, Most Like, Recommended
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
    // Saat filter berubah, muat ulang dan filter semua data
    await _fetchAndFilterFirebaseData();
    print('DEBUG: Global Filter "$filter" terpilih.');
  }

  Future<void> _onGlobalNearbyTapped() async {
    print('DEBUG: Global Nearby chip tapped');
    if (_globalUserLocation == null) {
      print('DEBUG: Global user location is null, loading location...');
      await _loadGlobalUserLocation();
    }
    if (_globalUserLocation != null) {
      print('DEBUG: Global user location available, filtering nearby items');
      _onGlobalFilterSelected("Nearby"); // Memicu pemfilteran dengan filter "Nearby"
    } else {
      print('DEBUG: Global user location still null after loading');
    }
  }

  Future<void> _loadGlobalUserLocation() async {
    debugPrint('DEBUG: _loadGlobalUserLocation called');
    setState(() {
      _globalIsLoadingLocation = true;
    });

    try {
      Position? position = await LocationService.getCurrentLocation();
      debugPrint('DEBUG: Global Location result: $position');
      if (position != null && mounted) {
        setState(() {
          _globalUserLocation = position;
        });
        debugPrint('DEBUG: Global User location set: ${position.latitude}, ${position.longitude}');
        // Setelah lokasi didapat, terapkan kembali filter global jika "Nearby" aktif
        if (_globalSelectedFilter == "Nearby") {
          await _fetchAndFilterFirebaseData();
        }
      } else {
        debugPrint('DEBUG: Failed to get global location or widget not mounted');
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
    debugPrint('DEBUG: _refreshGlobalUserLocation called from RadiusBottomSheet');

    // Force refresh by clearing current location first
    setState(() {
      _globalUserLocation = null;
      _globalIsLoadingLocation = true;
    });

    try {
      // Get fresh location data
      Position? position = await LocationService.getCurrentLocation();
      debugPrint('DEBUG: Fresh global location result: $position');

      if (position != null && mounted) {
        setState(() {
          _globalUserLocation = position;
        });
        debugPrint('DEBUG: Fresh global user location set: ${position.latitude}, ${position.longitude}');
        // Jika sedang melihat item Nearby, refresh daftar
        if (_globalSelectedFilter == "Nearby") {
          await _fetchAndFilterFirebaseData();
        }
      } else {
        debugPrint('DEBUG: Failed to get fresh global location or widget not mounted');
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
            await _fetchAndFilterFirebaseData(); // Memfilter ulang dengan radius baru
          }
        },
        onRefreshLocation: _refreshGlobalUserLocation,
      ),
    );
  }
  // === END: Fungsi Global Filter ===


  Future<void> _performSearch(String query) async {
    print('DEBUG: _performSearch dipanggil dengan query: "$query"');

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      print('DEBUG: Query kosong. Mode pencarian dinonaktifkan.');
      return;
    }

    setState(() {
      _isSearching = true;
    });
    print('DEBUG: Mode pencarian diaktifkan.');

    try {
      final results = await FirestoreService.searchDestinationsByTitle(query);
      print('DEBUG: Hasil dari FirestoreService.searchDestinationsByTitle: ${results.length} item');

      if (results.isNotEmpty) {
        print('DEBUG: Contoh data pertama hasil pencarian:');
        print('  ID: ${results[0].id}');
        print('  Title: ${results[0].title}');
        print('  Image URL: ${results[0].imageUrl}');
        print('  Location: ${results[0].location}');
        print('  Category ID: ${results[0].categoryId}');
      } else {
        print('DEBUG: Hasil pencarian kosong, tidak ada data untuk ditampilkan.');
      }

      setState(() {
        _searchResults = results;
      });
      print('DEBUG: _searchResults setelah setState: ${_searchResults.length} item');
    } catch (e) {
      print("ERROR: Terjadi kesalahan saat melakukan pencarian: $e");
      setState(() {
        _searchResults = [];
      });
    }
  }


  List<Map<String, String>> _getCategories() {
    if (_categoriesData.isNotEmpty) {
      // Definisikan urutan yang diinginkan
      final categoryOrder = [
        "Cultural Sites",
        "Arts & Culture", 
        "Folk Instruments",
        "Traditional Wear",
        "Crafts & Artifacts",
        "Local Foods",
      ];
      
      // Urutkan categories berdasarkan categoryOrder
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

  // _getDestinationsForSection sekarang mengembalikan items yang sudah difilter
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
                      _performSearch(text);
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
            // Removed SizedBox spacing to connect with home app bar
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchAndFilterFirebaseData, // Refresh akan memuat dan memfilter ulang
                color: AppColors.primary50,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Content sebelum filter chips (tidak sticky)
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // Removed top spacing to connect seamlessly with home app bar
                          const HomeFeaturedBanner(),
                          const SizedBox(height: Styles.smSpacing),
                          const CategoriesSection(),
                          const SizedBox(height: Styles.smSpacing),
                          QuizCard(),
                          const SizedBox(height: Styles.smSpacing),
                        ],
                      ),
                    ),
                    
                    // Sticky Header dengan Filter Chips
                    if (!_isSearching)
                      SliverStickyHeader(
                        header: Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 1.h), // Increased height from 1.h to 2.h
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
                              
                              // Tampilkan kategori normal jika tidak dalam mode pencarian
                              for (var category in categories) ...[
                                GenericSection(
                                  key: ValueKey('categorySection_${category["categoryName"]!}_$_globalSelectedFilter'),
                                  title: category["title"]!,
                                  categoryName: category["categoryName"]!,
                                  items: _getDestinationsForSection(category["categoryName"]!),
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
                              // Extra bottom padding untuk floating action button
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
                      ),
                    
                    // Content untuk mode pencarian (tanpa sticky header)
                    if (_isSearching)
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(height: 1.h),
                            
                            if (_searchResults.isNotEmpty)
                              GenericSection(
                                key: ValueKey('searchResultsSection_${_searchController.text}'),
                                title: "Search Results for '${_searchController.text}'",
                                categoryName: 'SearchResults',
                                items: _searchResults,
                                userId: GoogleAuthService.getAuthenticatedUserId(),
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
                                    "No destinations found for'${_searchController.text}'",
                                    style: context.textTheme.bodyLarge?.copyWith(color: AppColors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            
                            const SizedBox(height: Styles.smSpacing),
                            const SizedBox(height: Styles.xlSpacing),
                            // Extra bottom padding untuk floating action button
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
