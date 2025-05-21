import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/styles.dart';
import '../../../../widgets/site_card.dart';
import '../../../features/katalog_produk/views/katalog_produk.dart';
import 'section_header.dart';
import 'filter_chip_widget.dart';

class FolkInstrumentsSection extends StatefulWidget {
  const FolkInstrumentsSection({Key? key}) : super(key: key);

  @override
  State<FolkInstrumentsSection> createState() => _FolkInstrumentsSectionState();
}

class _FolkInstrumentsSectionState extends State<FolkInstrumentsSection> {
  String _selectedFilter = "Discover";
  
  // Data section dengan properti likes dan recommendation score
  final List<Map<String, dynamic>> _instrumentItems = [
    {
      "title": "Gamelan",
      "location": "Central Java",
      "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
      "isFavorite": false,
      "likes": 105,
      "recommendation": 8.7,
      "kategori": "Percussion Instrument",
    },
    {
      "title": "Angklung",
      "location": "West Java",
      "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
      "isFavorite": true,
      "likes": 170,
      "recommendation": 9.0,
      "kategori": "Bamboo Instrument",
    },
    {
      "title": "Sasando",
      "location": "East Nusa Tenggara",
      "imageUrl": "https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272",
      "isFavorite": false,
      "likes": 88,
      "recommendation": 8.5,
      "kategori": "String Instrument",
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
          _filteredItems = List.from(_instrumentItems)
            ..sort((a, b) => (b["likes"] as int).compareTo(a["likes"] as int));
          break;
        case "Recommended":
          // Urutkan berdasarkan skor rekomendasi (tertinggi ke terendah)
          _filteredItems = List.from(_instrumentItems)
            ..sort((a, b) => (b["recommendation"] as double).compareTo(a["recommendation"] as double));
          break;
        case "Discover":
        default:
          // Tampilkan semua tanpa urutan khusus
          _filteredItems = List.from(_instrumentItems);
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
          title: "Folk Instruments",
          onSeeAll: () {
            debugPrint('Navigating to Katalog with category: Folk Instruments');
            
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 300),
                child: KatalogProdukPage(
                  categoryName: "Folk Instruments",
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
                  debugPrint('Filter Discover terpilih pada Folk Instruments');
                },
              ),
              FilterChipWidget(
                label: "Most Like",
                isSelected: _selectedFilter == "Most Like",
                onTap: () {
                  _filterItems("Most Like");
                  debugPrint('Filter Most Like terpilih pada Folk Instruments');
                },
              ),
              FilterChipWidget(
                label: "Recommended",
                isSelected: _selectedFilter == "Recommended",
                onTap: () {
                  _filterItems("Recommended");
                  debugPrint('Filter Recommended terpilih pada Folk Instruments');
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
              children: _filteredItems.map((instrument) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: instrument == _filteredItems.last ? 0 : Styles.mdSpacing,
                  ),
                  child: SiteCard(
                    title: instrument["title"],
                    location: instrument["location"],
                    imageUrl: instrument["imageUrl"],
                    onTap: () {},
                    onFavorite: () {
                      // Implement favorite toggle here
                      setState(() {
                        instrument["isFavorite"] = !(instrument["isFavorite"] as bool);
                      });
                    },
                    isFavorite: instrument["isFavorite"] as bool,
                    kategori: instrument["kategori"],
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