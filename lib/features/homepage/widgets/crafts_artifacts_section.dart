import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/styles.dart';
import '../../../../widgets/site_card.dart';
import '../../../features/katalog_produk/views/katalog_produk.dart';
import 'section_header.dart';
import 'filter_chip_widget.dart';

class CraftsArtifactsSection extends StatefulWidget {
  const CraftsArtifactsSection({Key? key}) : super(key: key);

  @override
  State<CraftsArtifactsSection> createState() => _CraftsArtifactsSectionState();
}

class _CraftsArtifactsSectionState extends State<CraftsArtifactsSection> {
  String _selectedFilter = "Discover";
  
  // Data section dengan properti likes dan recommendation score
  final List<Map<String, dynamic>> _artifactItems = [
    {
      "title": "Wayang Kulit",
      "location": "Java",
      "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
      "isFavorite": false,
      "likes": 110,
      "recommendation": 8.6,
      "kategori": "Traditional Puppet",
    },
    {
      "title": "Keris",
      "location": "Central Java",
      "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
      "isFavorite": true,
      "likes": 175,
      "recommendation": 7.9,
      "kategori": "Traditional Weapon",
    },
    {
      "title": "Pottery from Lombok",
      "location": "Lombok, West Nusa Tenggara",
      "imageUrl": "https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272",
      "isFavorite": false,
      "likes": 95,
      "recommendation": 9.1,
      "kategori": "Pottery",
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
          _filteredItems = List.from(_artifactItems)
            ..sort((a, b) => (b["likes"] as int).compareTo(a["likes"] as int));
          break;
        case "Recommended":
          // Urutkan berdasarkan skor rekomendasi (tertinggi ke terendah)
          _filteredItems = List.from(_artifactItems)
            ..sort((a, b) => (b["recommendation"] as double).compareTo(a["recommendation"] as double));
          break;
        case "Discover":
        default:
          // Tampilkan semua tanpa urutan khusus
          _filteredItems = List.from(_artifactItems);
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
          title: "Crafts & Artifacts",
          onSeeAll: () {
            debugPrint('Navigating to Katalog with category: Crafts & Artifacts');
            
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 300),
                child: KatalogProdukPage(
                  categoryName: "Crafts & Artifacts",
                ),
              ),
            );
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
                  debugPrint('Filter Discover terpilih');
                },
              ),
              FilterChipWidget(
                label: "Most Like",
                isSelected: _selectedFilter == "Most Like",
                onTap: () {
                  _filterItems("Most Like");
                  debugPrint('Filter Most Like terpilih');
                },
              ),
              FilterChipWidget(
                label: "Recommended",
                isSelected: _selectedFilter == "Recommended",
                onTap: () {
                  _filterItems("Recommended");
                  debugPrint('Filter Recommended terpilih');
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
              children: _filteredItems.map((artifact) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: artifact == _filteredItems.last ? 0 : Styles.mdSpacing,
                  ),
                  child: SiteCard(
                    title: artifact["title"],
                    location: artifact["location"],
                    imageUrl: artifact["imageUrl"],
                    onTap: () {},
                    onFavorite: () {
                      // Implement favorite toggle here
                      setState(() {
                        artifact["isFavorite"] = !(artifact["isFavorite"] as bool);
                      });
                    },
                    isFavorite: artifact["isFavorite"] as bool,
                    kategori: artifact["kategori"],
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