import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/app_colors.dart';
import '../../../core/styles.dart';
import '../../../widgets/site_card.dart';
import '../../../routes/router.dart';
import 'section_header.dart';
import 'filter_chip_widget.dart';
import 'package:sizer/sizer.dart';

class GenericSection extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final String categoryName;
  final Widget? locationIcon;

  const GenericSection({
    Key? key,
    required this.title,
    required this.items,
    required this.categoryName,
    this.locationIcon,
  }) : super(key: key);

  @override
  State<GenericSection> createState() => _GenericSectionState();
}

class _GenericSectionState extends State<GenericSection> {
  String _selectedFilter = "Discover";
  late List<Map<String, dynamic>> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);
  }

  @override
  void didUpdateWidget(GenericSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update filtered items when widget items change (e.g., from Firebase)
    if (oldWidget.items != widget.items) {
      _filteredItems = List.from(widget.items);
      _filterItems(_selectedFilter); // Re-apply current filter
    }
  }

  void _filterItems(String filter) {
    setState(() {
      _selectedFilter = filter;
      
      // Apply filtering logic
      _filteredItems = List.from(widget.items);
      
      if (filter == "Most Like") {
        _filteredItems.sort((a, b) {
          int likesA = (a["likes"] ?? 0) is int ? a["likes"] : int.tryParse(a["likes"].toString()) ?? 0;
          int likesB = (b["likes"] ?? 0) is int ? b["likes"] : int.tryParse(b["likes"].toString()) ?? 0;
          return likesB.compareTo(likesA);
        });
      } else if (filter == "Recommended") {
        _filteredItems.sort((a, b) {
          double recA = (a["recommendation"] ?? 0.0) is double 
              ? a["recommendation"] 
              : double.tryParse(a["recommendation"].toString()) ?? 0.0;
          double recB = (b["recommendation"] ?? 0.0) is double 
              ? b["recommendation"] 
              : double.tryParse(b["recommendation"].toString()) ?? 0.0;
          return recB.compareTo(recA);
        });
      }
      // "Discover" filter keeps original order
    });
  }

  @override
  Widget build(BuildContext context) {
    // Don't show section if no items
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: widget.title,
          onSeeAll: () {
            debugPrint('Navigating to Katalog with category: ${widget.categoryName}');
            // Using AutoRouter for navigation
            context.router.push(KatalogProdukRoute(categoryName: widget.categoryName));
          },
        ),
        const SizedBox(height: Styles.xsSpacing),
        
        // Filter chips
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Styles.mdPadding),
            children: [
              FilterChipWidget(
                label: "Discover",
                isSelected: _selectedFilter == "Discover",
                onTap: () {
                  _filterItems("Discover");
                  debugPrint('Filter Discover terpilih pada ${widget.title}');
                },
              ),
              FilterChipWidget(
                label: "Most Like",
                isSelected: _selectedFilter == "Most Like",
                onTap: () {
                  _filterItems("Most Like");
                  debugPrint('Filter Most Like terpilih pada ${widget.title}');
                },
              ),
              FilterChipWidget(
                label: "Recommended",
                isSelected: _selectedFilter == "Recommended",
                onTap: () {
                  _filterItems("Recommended");
                  debugPrint('Filter Recommended terpilih pada ${widget.title}');
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: Styles.smSpacing),
        
        // Items list
        if (_filteredItems.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Styles.mdPadding),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
              decoration: BoxDecoration(
                color: AppColors.grey10.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.grey30.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    IconsaxPlusLinear.document,
                    color: AppColors.grey50,
                    size: 48,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'No ${widget.title.toLowerCase()} available',
                    style: TextStyle(
                      color: AppColors.grey50,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Check back later for new content',
                    style: TextStyle(
                      color: AppColors.grey40,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Styles.mdPadding),
            child: IntrinsicHeight(
              child: Row(
                children: _filteredItems.map((item) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: item == _filteredItems.last ? 0 : Styles.mdSpacing,
                    ),
                    child: SiteCard(
                      title: item["title"] ?? "Unknown Title",
                      location: item["location"] ?? "Unknown Location",
                      imageUrl: item["imageUrl"] ?? "https://images.unsplash.com/photo-1565967511849-76a60a516170",
                      onTap: () {
                        // Handle item tap - could navigate to detail page
                        debugPrint('Tapped on: ${item["title"]}');
                      },
                      onFavorite: () {
                        // Implement favorite toggle here
                        setState(() {
                          item["isFavorite"] = !(item["isFavorite"] as bool? ?? false);
                        });
                        debugPrint('Favorite toggled for: ${item["title"]}');
                      },
                      isFavorite: item["isFavorite"] as bool? ?? false,
                      kategori: item["kategori"] ?? item["category"] ?? "General",
                      locationIcon: widget.locationIcon ?? Icon(
                        IconsaxPlusBold.location,
                        color: AppColors.success50,
                        size: 16,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}