import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/styles.dart';
import '../../../../widgets/site_card.dart';
import '../../../features/katalog_produk/views/katalog_produk.dart';
import 'section_header.dart';
import 'filter_chip_widget.dart';

class LocalFoodsSection extends StatefulWidget {
  const LocalFoodsSection({Key? key}) : super(key: key);

  @override
  State<LocalFoodsSection> createState() => _LocalFoodsSectionState();
}

class _LocalFoodsSectionState extends State<LocalFoodsSection> {
  String _selectedFilter = "Discover";
  
  // Data section dengan properti likes dan recommendation score
  final List<Map<String, dynamic>> _foodItems = [
    {
      "title": "Rendang",
      "location": "West Sumatra",
      "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
      "isFavorite": false,
      "likes": 215,
      "recommendation": 9.5,
      "kategori": "Main Course",
    },
    {
      "title": "Gudeg",
      "location": "Yogyakarta",
      "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
      "isFavorite": true,
      "likes": 180,
      "recommendation": 8.3,
      "kategori": "Main Course",
    },
    {
      "title": "Sate Ayam",
      "location": "Various Regions",
      "imageUrl": "https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272",
      "isFavorite": false,
      "likes": 195,
      "recommendation": 9.2,
      "kategori": "Street Food",
    },
    {
      "title": "Gado-gado",
      "location": "Jakarta",
      "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
      "isFavorite": true,
      "likes": 160,
      "recommendation": 8.7,
      "kategori": "Salad",
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
          _filteredItems = List.from(_foodItems)
            ..sort((a, b) => (b["likes"] as int).compareTo(a["likes"] as int));
          break;
        case "Recommended":
          // Urutkan berdasarkan skor rekomendasi (tertinggi ke terendah)
          _filteredItems = List.from(_foodItems)
            ..sort((a, b) => (b["recommendation"] as double).compareTo(a["recommendation"] as double));
          break;
        case "Discover":
        default:
          // Tampilkan semua tanpa urutan khusus
          _filteredItems = List.from(_foodItems);
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
          title: "Local Foods",
          onSeeAll: () {
            debugPrint('Navigating to Katalog with category: Local Foods');
            
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 300),
                child: KatalogProdukPage(
                  categoryName: "Local Foods",
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
                  debugPrint('Filter Discover terpilih pada Local Foods');
                },
              ),
              FilterChipWidget(
                label: "Most Like",
                isSelected: _selectedFilter == "Most Like",
                onTap: () {
                  _filterItems("Most Like");
                  debugPrint('Filter Most Like terpilih pada Local Foods');
                },
              ),
              FilterChipWidget(
                label: "Recommended",
                isSelected: _selectedFilter == "Recommended",
                onTap: () {
                  _filterItems("Recommended");
                  debugPrint('Filter Recommended terpilih pada Local Foods');
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
              children: _filteredItems.map((food) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: food == _filteredItems.last ? 0 : Styles.mdSpacing,
                  ),
                  child: SiteCard(
                    title: food["title"],
                    location: food["location"],
                    imageUrl: food["imageUrl"],
                    onTap: () {},
                    onFavorite: () {
                      // Implement favorite toggle here
                      setState(() {
                        food["isFavorite"] = !(food["isFavorite"] as bool);
                      });
                    },
                    isFavorite: food["isFavorite"] as bool,
                    kategori: food["kategori"],
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