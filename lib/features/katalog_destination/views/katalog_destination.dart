import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sizer/sizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../core/styles.dart';
import '../../../widgets/custom_search.dart';
import '../widgets/home_appbar_katalog_screen.dart';
import '../widgets/product_grid_section.dart';
import '../../../services/firestore_service.dart';
import '../../../services/google_auth_service.dart';
import '../../../models/models.dart';

@RoutePage()
class KatalogProdukPage extends StatefulWidget {
  final String? categoryName;

  const KatalogProdukPage({Key? key, this.categoryName}) : super(key: key);

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

      // Get all categories to find the matching one
      final categories = await FirestoreService.getCategories();

      if (widget.categoryName != null) {
        _selectedCategory = categories.firstWhere(
          (category) => category.categoryName == widget.categoryName,
          orElse: () => categories.first,
        );
      } else {
        _selectedCategory = categories.first;
      }

      // Get destinations for this category
      final destinations = await FirestoreService.getDestinationsByCategory(
        _selectedCategory!.id!,
        limit: 50, // Get more destinations for catalog
      );

      // Get unique subcategories from destinations
      final subcategoriesSet = <String>{'All'};
      for (var destination in destinations) {
        if (destination.subcategory.isNotEmpty) {
          subcategoriesSet.add(destination.subcategory);
        }
      }      setState(() {
        _destinationsList = destinations;
        _filteredDestinations = destinations; // Initialize filtered list
        _subcategories = subcategoriesSet.toList();
        _isLoading = false;
      });

      debugPrint(
          '✅ Loaded ${destinations.length} destinations for category: ${_selectedCategory!.categoryName}');
      debugPrint('📂 Subcategories: $_subcategories');
    } catch (e) {
      debugPrint('❌ Error loading catalog data: $e');      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterDestinations(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredDestinations = List.from(_destinationsList);
      } else {
        _filteredDestinations = _destinationsList.where((destination) {
          final titleMatches = destination.title.toLowerCase().contains(_searchQuery);
          final addressMatches = destination.address.toLowerCase().contains(_searchQuery);
          final subcategoryMatches = destination.subcategory.toLowerCase().contains(_searchQuery);
          
          return titleMatches || addressMatches || subcategoryMatches;
        }).toList();
      }
    });
  }

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
                child: SizedBox(                  child: SearchWidget(
                    hintText: "Find Your Culture",
                    controller: _searchController,
                    onChanged: (text) {
                      _filterDestinations(text);
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
            Expanded(              child: _isLoading
                  ? Center(
                      child: LoadingAnimationWidget.beat(
                        color: Colors.blue,
                        size: 15.w,
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
                                  Icons.search_off,
                                  size: 20.w,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  _searchQuery.isEmpty 
                                      ? 'No destinations found'
                                      : 'No results found for "$_searchQuery"',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'Try searching with different keywords',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,                        children: [                          SizedBox(height: Styles.xsSpacing),
                          ProductGridSection(
                            products: _filteredDestinations,
                            customFilters: _subcategories,
                            userId: GoogleAuthService.getAuthenticatedUserId(),
                          ),
                          const SizedBox(height: Styles.mdSpacing),
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
