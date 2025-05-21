import 'package:flutter/material.dart';
import 'package:nusa_app/widgets/site_card.dart';
import '../../../core/styles.dart';
import '../../../core/app_colors.dart';
import '../../homepage/widgets/filter_chip_widget.dart';
import '../../homepage/widgets/section_header.dart';
import 'package:sizer/sizer.dart';
import '../views/katalog_produk.dart';

class ProductGridSection extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final Function()? onSeeAll;
  final List<String>? customFilters;

  const ProductGridSection({
    Key? key,
    required this.products,
    this.onSeeAll,
    this.customFilters,
  }) : super(key: key);

  @override
  State<ProductGridSection> createState() => _ProductGridSectionState();
}

class _ProductGridSectionState extends State<ProductGridSection> {
  int _selectedFilterIndex = 0;
  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(widget.products);
  }

  void _filterProducts(int index, String filter) {
    setState(() {
      _selectedFilterIndex = index;

      // Filter "All" - show all products
      if (index == 0 || filter == "All") {
        _filteredProducts = List.from(widget.products);
        return;
      }

      // Filter by category
      try {
        _filteredProducts = widget.products
            .where((product) =>
                product.containsKey("category") &&
                product["category"].toString().toLowerCase() ==
                    filter.toLowerCase())
            .toList();

        // If no results, show all and log
        if (_filteredProducts.isEmpty) {
          _filteredProducts = List.from(widget.products);
          debugPrint('No products found for category: $filter');

          // Debug: list available categories
          final availableCategories = widget.products
              .map((product) => product["category"])
              .toSet()
              .toList();
          debugPrint('Available categories: $availableCategories');
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
    // Ensure filters are not null with default value if null
    final filters = widget.customFilters ?? ["All"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Menambahkan section header jika ada onSeeAll callback
        if (widget.onSeeAll != null)
          SectionHeader(
            title: "Products",
            onSeeAll: widget.onSeeAll,
          ),
        
        SizedBox(height: 1.h), // Using sizer for responsive spacing
        
        SizedBox(
          height: 5.h, // Using sizer for responsive height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w), // Using sizer for responsive padding
            itemCount: filters.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 2.w), // Using sizer for responsive padding
                child: FilterChipWidget(
                  label: filters[index],
                  isSelected: _selectedFilterIndex == index,
                  onTap: () => _filterProducts(index, filters[index]),
                ),
              );
            },
          ),
        ),
        
        SizedBox(height: 2.h), // Using sizer for responsive spacing
        
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w), // Using sizer for responsive padding
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75, // Optimized for SiteCard proportions
              crossAxisSpacing: 3.w, // Using sizer for responsive spacing
              mainAxisSpacing: 2.h, // Using sizer for responsive spacing
            ),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return SiteCard(
                title: product["title"] ?? "Untitled",
                imageUrl: product["imageUrl"] ?? "",
                location: product["location"] ?? "Unknown location",
                kategori: product["category"] ?? "Uncategorized",
                onTap: () {
                  debugPrint('Product tapped: ${product["title"]}');
                },
                onFavorite: () {
                  debugPrint('Favorite toggled for: ${product["title"]}');
                },
                isFavorite: product["isFavorite"] ?? false,
              );
            },
          ),
        ),
        
        SizedBox(height: 2.h), // Using sizer for responsive spacing
      ],
    );
  }
}