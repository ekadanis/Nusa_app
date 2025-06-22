import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:nusa_app/widgets/site_card.dart';
import '../../homepage/widgets/filter_chip_widget.dart';
import '../../homepage/widgets/section_header.dart';
import 'package:sizer/sizer.dart';
import '../../../models/models.dart';
import '../../../services/firestore_service.dart';
import '../../../routes/router.dart';

class ProductGridSection extends StatefulWidget {
  final List<DestinationModel> products;
  final Function()? onSeeAll;
  final List<String>? customFilters;
  final String? userId;
  final String selectedCategory;

  const ProductGridSection({
    Key? key,
    required this.products,
    this.onSeeAll,
    this.customFilters,
    this.userId,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  State<ProductGridSection> createState() => _ProductGridSectionState();
}

class _ProductGridSectionState extends State<ProductGridSection> {
  int _selectedFilterIndex = 0;
  List<DestinationModel> _filteredProducts = [];
  Map<String, bool> _favoriteStatus = {};
  Map<String, int> _likeCount = {};
  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(widget.products);
    _initializeLikeCounts();
    _loadFavoriteStatus();
  }

  @override
  void didUpdateWidget(covariant ProductGridSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.products != widget.products) {
      setState(() {
        _filteredProducts = List.from(widget.products);
        _initializeLikeCounts(); // Perbarui like count
        _loadFavoriteStatus();  // Perbarui status favorite
      });
    }
  }


  void _initializeLikeCounts() {
    for (var item in widget.products) {
      if (item.id != null) {
        _likeCount[item.id!] = item.like;
      }
    }
  }

  void _loadFavoriteStatus() async {
    if (widget.userId != null) {
      for (var item in widget.products) {
        if (item.id != null) {
          final isFavorite = await FirestoreService.hasUserLikedDestination(
              widget.userId!, item.id!);
          if (mounted) {
            setState(() {
              _favoriteStatus[item.id!] = isFavorite;
            });
          }
        }
      }
    }
  }

  void _toggleFavorite(DestinationModel item) async {
    if (widget.userId != null && item.id != null) {
      try {
        await FirestoreService.toggleDestinationLike(widget.userId!, item.id!);
        if (mounted) {
          setState(() {
            final isCurrentlyFavorite = _favoriteStatus[item.id!] ?? false;
            _favoriteStatus[item.id!] = !isCurrentlyFavorite;

            // Update like count immediately
            final currentLikeCount = _likeCount[item.id!] ?? item.like;
            if (!isCurrentlyFavorite) {
              // User is adding a like
              _likeCount[item.id!] = currentLikeCount + 1;
            } else {
              // User is removing a like
              _likeCount[item.id!] =
                  (currentLikeCount - 1).clamp(0, double.infinity).toInt();
            }
          });
        }
        debugPrint(
            'Favorite toggled for: ${item.title}, new like count: ${_likeCount[item.id!]}');
      } catch (e) {
        debugPrint('Error toggling favorite: $e');
      }
    }
  }

  void _filterProducts(int index, String filter) {
    setState(() {
      _selectedFilterIndex = index;

      // Filter "All" - show all products
      if (index == 0 || filter == "All") {
        _filteredProducts = List.from(widget.products);
        return;
      }

      // Filter by subcategory
      try {
        _filteredProducts = widget.products
            .where((product) =>
                product.subcategory.toLowerCase() == filter.toLowerCase())
            .toList();

        // If no results, show all and log
        if (_filteredProducts.isEmpty) {
          _filteredProducts = List.from(widget.products);
          debugPrint('No products found for subcategory: $filter');

          // Debug: list available subcategories
          final availableSubcategories = widget.products
              .map((product) => product.subcategory)
              .toSet()
              .toList();
          debugPrint('Available subcategories: $availableSubcategories');
        }
      } catch (e) {
        // If error, show all products
        _filteredProducts = List.from(widget.products);
        debugPrint('Error filtering: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filters = widget.customFilters ?? ["All"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.onSeeAll != null)
          SectionHeader(
            title: "Products",
            onSeeAll: widget.onSeeAll,
          ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 5.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: filters.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: FilterChipWidget(
                  label: filters[index],
                  isSelected: _selectedFilterIndex == index,
                  onTap: () => _filterProducts(index, filters[index]),
                  selectedCategory: widget.selectedCategory,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
            ),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return SiteCard(
                title: product.title,
                imageUrl: product.imageUrl,
                location: product.address,
                kategori: product.subcategory,
                likeCount: _likeCount[product.id] ?? product.like,
                onTap: () {
                  context.router
                      .push(DetailRouteDestination(destination: product));
                },
                onFavorite: () => _toggleFavorite(product),
                isFavorite: _favoriteStatus[product.id] ?? false,
                categoryId: widget.selectedCategory,
              );
            },
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}
