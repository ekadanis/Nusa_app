import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/styles.dart';
import '../../../../widgets/site_card.dart';
import '../../../features/katalog_produk/views/katalog_produk.dart';
import '../../../routes/router.dart';
import 'section_header.dart';
import 'filter_chip_widget.dart';

class CulturalSitesSection extends StatefulWidget {
  const CulturalSitesSection({Key? key}) : super(key: key);

  @override
  State<CulturalSitesSection> createState() => _CulturalSitesSectionState();
}

class _CulturalSitesSectionState extends State<CulturalSitesSection> {
  String _selectedFilter = "Discover";

  // Data section dengan properti likes dan recommendation score
  final List<Map<String, dynamic>> _siteItems = [
    {
      "title": "Candi Borobudur",
      "location": "Magelang, Central Java",
      "imageUrl":
          "https://images.unsplash.com/photo-1565967511849-76a60a516170",
      "isFavorite": false,
      "likes": 200,
      "recommendation": 9.5,
      "kategori": "Temple",
    },
    {
      "title": "Keraton Yogyakarta",
      "location": "Yogyakarta, DIY",
      "imageUrl":
          "https://images.unsplash.com/photo-1565967511849-76a60a516170",
      "isFavorite": true,
      "likes": 160,
      "recommendation": 8.3,
      "kategori": "Palace",
    },
    {
      "title": "Candi Prambanan",
      "location": "Yogyakarta, DIY",
      "imageUrl":
          "https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272",
      "isFavorite": false,
      "likes": 180,
      "recommendation": 9.0,
      "kategori": "Temple",
    },
  ];

  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filterItems(_selectedFilter);
  }

  void _filterItems(String filter) {
    setState(() {
      _selectedFilter = filter;

      // Filter items berdasarkan kriteria
      switch (filter) {
        case "Most Like":
          // Urutkan berdasarkan jumlah likes (tertinggi ke terendah)
          _filteredItems = List.from(_siteItems)
            ..sort((a, b) => (b["likes"] as int).compareTo(a["likes"] as int));
          break;
        case "Recommended":
          // Urutkan berdasarkan skor rekomendasi (tertinggi ke terendah)
          _filteredItems = List.from(_siteItems)
            ..sort((a, b) => (b["recommendation"] as double)
                .compareTo(a["recommendation"] as double));
          break;
        case "Discover":
        default:
          // Tampilkan semua tanpa urutan khusus
          _filteredItems = List.from(_siteItems);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Cultural Sites",
          onSeeAll: () {
            debugPrint('Navigating to Katalog with category: Cultural Sites');

            // Using AutoRouter for navigation
            context.router
                .push(KatalogProdukRoute(categoryName: "Cultural Sites"));
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
                  debugPrint('Filter Discover terpilih pada Cultural Sites');
                },
              ),
              FilterChipWidget(
                label: "Most Like",
                isSelected: _selectedFilter == "Most Like",
                onTap: () {
                  _filterItems("Most Like");
                  debugPrint('Filter Most Like terpilih pada Cultural Sites');
                },
              ),
              FilterChipWidget(
                label: "Recommended",
                isSelected: _selectedFilter == "Recommended",
                onTap: () {
                  _filterItems("Recommended");
                  debugPrint('Filter Recommended terpilih pada Cultural Sites');
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
              children: _filteredItems.map((site) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: site == _filteredItems.last ? 0 : Styles.mdSpacing,
                  ),
                  child: SiteCard(
                    title: site["title"],
                    location: site["location"],
                    imageUrl: site["imageUrl"],
                    onTap: () {},
                    onFavorite: () {
                      // Implement favorite toggle here
                      setState(() {
                        site["isFavorite"] = !(site["isFavorite"] as bool);
                      });
                    },
                    isFavorite: site["isFavorite"] as bool,
                    kategori: site["kategori"],
                    locationIcon: Icon(
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
