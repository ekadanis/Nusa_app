import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:nusa_app/util/extensions.dart';
import 'package:sizer/sizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../core/styles.dart';
import '../../../widgets/custom_search.dart';
import '../widgets/home_appbar_katalog_screen.dart';
import '../widgets/product_grid_section.dart';
import '../../../services/firestore_service.dart';
import '../../../services/google_auth_service.dart';
import '../../../models/models.dart';
import 'dart:async';

@RoutePage()
class KatalogProdukPage extends StatefulWidget {
  final String? categoryName;
  final String? categoryColor;

  const KatalogProdukPage({Key? key, this.categoryName, this.categoryColor}) : super(key: key);

  @override
  State<KatalogProdukPage> createState() => _KatalogProdukPageState();
}

class _KatalogProdukPageState extends State<KatalogProdukPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DestinationModel> _destinationsList = [];
  List<DestinationModel> _filteredDestinations = [];
  List<String> _subcategories = [];
  bool _isLoading = true;
  CategoryModel? _selectedCategory;
  String _searchQuery = '';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      debugPrint('🔄 Starting to load catalog data...');

      // Get all categories to find the matching one
      final categories = await FirestoreService.getCategories();
      debugPrint('📂 Loaded ${categories.length} categories');

      if (widget.categoryName != null) {
        _selectedCategory = categories.firstWhere(
              (category) => category.categoryName == widget.categoryName,
          orElse: () => categories.first,
        );
        debugPrint('🎯 Selected category: ${_selectedCategory!.categoryName} (ID: ${_selectedCategory!.id})');
      } else {
        _selectedCategory = categories.first;
        debugPrint('🎯 Using first category: ${_selectedCategory!.categoryName}');
      }

      // Get destinations for this category
      final destinations = await FirestoreService.getDestinationsByCategory(
        _selectedCategory!.id!,
        limit: 50, // Get more destinations for catalog
      );

      debugPrint('🏛️ Raw destinations loaded: ${destinations.length}');

      // Debug: Print first few destinations
      if (destinations.isNotEmpty) {
        for (int i = 0; i < (destinations.length > 3 ? 3 : destinations.length); i++) {
          debugPrint('  ${i + 1}. ${destinations[i].title} (${destinations[i].subcategory})');
        }
      }

      // Get unique subcategories from destinations
      final subcategoriesSet = <String>{'All'};
      for (var destination in destinations) {
        if (destination.subcategory.isNotEmpty) {
          subcategoriesSet.add(destination.subcategory);
        }
      }

      setState(() {
        _destinationsList = destinations;
        _filteredDestinations = List.from(destinations); // Create a copy
        _subcategories = subcategoriesSet.toList();
        _isLoading = false;
      });

      debugPrint('✅ Successfully loaded ${destinations.length} destinations for category: ${_selectedCategory!.categoryName}');
      debugPrint('📂 Available subcategories: $_subcategories');
      debugPrint('🔍 Initial filtered destinations: ${_filteredDestinations.length}');

    } catch (e, stackTrace) {
      debugPrint('❌ Error loading catalog data: $e');
      debugPrint('📚 Stack trace: $stackTrace');
      setState(() {
        _isLoading = false;
        _destinationsList = [];
        _filteredDestinations = [];
        _subcategories = ['All'];
      });
    }
  }

  void _filterDestinations(String query) {
    // Cancel previous timer to avoid multiple rapid calls
    _debounceTimer?.cancel();

    // Debounce the search to improve performance
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      debugPrint('🔍 _filterDestinations called with query: "$query"');
      debugPrint('📊 Total destinations to filter: ${_destinationsList.length}');

      setState(() {
        _searchQuery = query.toLowerCase().trim();

        if (_searchQuery.isEmpty) {
          _filteredDestinations = List.from(_destinationsList);
          debugPrint('🔄 Query empty, showing all ${_filteredDestinations.length} destinations');
        } else {
          _filteredDestinations = _destinationsList.where((destination) {
            final titleMatches = destination.title.toLowerCase().contains(_searchQuery);
            final addressMatches = destination.address.toLowerCase().contains(_searchQuery);
            final subcategoryMatches = destination.subcategory.toLowerCase().contains(_searchQuery);

            final matches = titleMatches || addressMatches || subcategoryMatches;

            // Debug logging for first few items
            if (_destinationsList.indexOf(destination) < 3) {
              debugPrint('  🔎 "${destination.title}": title=$titleMatches, address=$addressMatches, subcat=$subcategoryMatches → $matches');
            }

            return matches;
          }).toList();

          debugPrint('✅ Filtered to ${_filteredDestinations.length} destinations for query "$query"');

          // Debug: Show first few results
          if (_filteredDestinations.isNotEmpty) {
            debugPrint('🎯 First few results:');
            for (int i = 0; i < (_filteredDestinations.length > 3 ? 3 : _filteredDestinations.length); i++) {
              debugPrint('  ${i + 1}. ${_filteredDestinations[i].title}');
            }
          }
        }
      });
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterDestinations('');
    debugPrint('🧹 Search cleared');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
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
            HomeAppBar(
              categoryName: _selectedCategory?.categoryName ?? "Loading...",
            ),
            Positioned(
              top: 15.5.h,
              left: Styles.mdPadding,
              right: Styles.mdPadding,
              child: Material(
                elevation: 10,
                shadowColor: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                child: SearchWidget(
                  hintText: "Find Your Culture",
                  controller: _searchController,
                  onChanged: (text) {
                    debugPrint('🎯 SearchWidget onChanged triggered: "$text"');
                    _filterDestinations(text);
                  },
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
            Expanded(
              child: _isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.beat(
                      color: Colors.blue,
                      size: 15.w,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Loading destinations...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              )
                  : _filteredDestinations.isEmpty
                  ? Center(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _searchQuery.isEmpty ? Icons.location_off : Icons.search_off,
                        size: 20.w,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _searchQuery.isEmpty
                            ? 'No destinations found in this category'
                            : 'No results found for "$_searchQuery"',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _searchQuery.isEmpty
                            ? 'Try selecting a different category'
                            : 'Try searching with different keywords',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_searchQuery.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        ElevatedButton.icon(
                          onPressed: _clearSearch,
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear Search'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )
                  : SingleChildScrollView(
                padding: EdgeInsets.only(bottom: Styles.mdSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Styles.xsSpacing),

                    // Show search results count
                    if (_searchQuery.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                        child: Row(
                          children: [
                            Icon(Icons.search, size: 24, color: Colors.grey[600]),
                            SizedBox(width: 2.w),
                            Text(
                              '${_filteredDestinations.length} results for "$_searchQuery"',
                              style: context.textTheme.bodyMedium
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _clearSearch,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.clear, size: 12.sp, color: Colors.grey[600]),
                                    SizedBox(width: 1.w),
                                    Text(
                                      'Clear',
                                      style: context.textTheme.bodyMedium
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ProductGridSection(
                      products: _filteredDestinations,
                      customFilters: _subcategories,
                      userId: GoogleAuthService.getAuthenticatedUserId(),
                      selectedCategory: _selectedCategory!.id!,
                      categoryColor: widget.categoryColor,
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