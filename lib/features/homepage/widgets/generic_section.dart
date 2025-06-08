import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/app_colors.dart';
import '../../../core/styles.dart';
import '../../../widgets/site_card.dart';
import '../../../routes/router.dart';
import 'section_header.dart';
import 'filter_chip_widget.dart';

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

  void _filterItems(String filter) {
    setState(() {
      _selectedFilter = filter;
      
      // Apply filtering logic
      _filteredItems = List.from(widget.items);
      
      if (filter == "Most Like") {
        _filteredItems.sort((a, b) => (b["likes"] ?? 0).compareTo(a["likes"] ?? 0));
      } else if (filter == "Recommended") {
        _filteredItems.sort((a, b) => (b["recommendation"] ?? 0).compareTo(a["recommendation"] ?? 0));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    title: item["title"],
                    location: item["location"],
                    imageUrl: item["imageUrl"],
                    onTap: () {},
                    onFavorite: () {
                      // Implement favorite toggle here
                      setState(() {
                        item["isFavorite"] = !(item["isFavorite"] as bool);
                      });
                    },
                    isFavorite: item["isFavorite"] as bool,
                    kategori: item["kategori"],
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
