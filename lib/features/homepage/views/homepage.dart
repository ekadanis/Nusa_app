import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../core/styles.dart';
import '../../../core/app_colors.dart';
import '../../../widgets/custom_search.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_featured_banner.dart';
import '../widgets/home_location_banner.dart';
import '../widgets/categories_section.dart';
import '../widgets/generic_section.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  // List of all categories to be displayed
  final List<Map<String, String>> _categories = [
    {"title": "Cultural Sites", "categoryName": "Cultural Sites"},
    {"title": "Arts & Culture", "categoryName": "Arts & Culture"},
    {"title": "Folk Instruments", "categoryName": "Folk Instruments"},
    {"title": "Traditional Wear", "categoryName": "Traditional Wear"},
    {"title": "Crafts & Artifacts", "categoryName": "Crafts & Artifacts"},
    {"title": "Local Foods", "categoryName": "Local Foods"},
  ];

  // Sample data function - will be replaced with API call later
  List<Map<String, dynamic>> _getSampleData(String category) {
    // This will be replaced with API calls in the future
    if (category == "Cultural Sites") {
      return [
        {
          "title": "Candi Borobudur",
          "location": "Magelang, Central Java",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 200,
          "recommendation": 9.5,
          "kategori": "Temple",
        },
        {
          "title": "Keraton Yogyakarta",
          "location": "Yogyakarta, DIY",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": true,
          "likes": 160,
          "recommendation": 8.3,
          "kategori": "Palace",
        },
        {
          "title": "Candi Prambanan",
          "location": "Yogyakarta, DIY",
          "imageUrl": "https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272",
          "isFavorite": false,
          "likes": 180,
          "recommendation": 9.0,
          "kategori": "Temple",
        },
      ];
    } else if (category == "Arts & Culture") {
      return [
        {
          "title": "Batik Parang",
          "location": "Solo, Central Java",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 120,
          "recommendation": 8.5,
          "kategori": "Hand-drawn batik",
        },
        {
          "title": "Batik Mega Mendung",
          "location": "Cirebon, West Java",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": true,
          "likes": 185,
          "recommendation": 7.8,
          "kategori": "Hand-drawn batik",
        },
        {
          "title": "Songket Palembang",
          "location": "Palembang, South Sumatra",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 90,
          "recommendation": 9.2,
          "kategori": "Songket",
        },
      ];
    } else if (category == "Folk Instruments") {
      return [
        {
          "title": "Angklung",
          "location": "Bandung, West Java",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 150,
          "recommendation": 8.7,
          "kategori": "Bamboo instruments",
        },
        {
          "title": "Gamelan",
          "location": "Yogyakarta, DIY",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": true,
          "likes": 230,
          "recommendation": 9.4,
          "kategori": "Gongs",
        },
        {
          "title": "Sasando",
          "location": "NTT",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 80,
          "recommendation": 7.5,
          "kategori": "String instruments",
        },
      ];
    } else if (category == "Traditional Wear") {
      return [
        {
          "title": "Kebaya",
          "location": "Java",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 170,
          "recommendation": 8.9,
          "kategori": "Women's dresses",
        },
        {
          "title": "Beskap",
          "location": "Central Java",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": true,
          "likes": 110,
          "recommendation": 7.6,
          "kategori": "Men's outfits",
        },
        {
          "title": "Baju Bodo",
          "location": "South Sulawesi",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 95,
          "recommendation": 8.1,
          "kategori": "Women's dresses",
        },
      ];
    } else if (category == "Crafts & Artifacts") {
      return [
        {
          "title": "Wayang Kulit Jawa",
          "location": "Solo, Central Java",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 130,
          "recommendation": 8.3,
          "kategori": "Puppetry & masks",
        },
        {
          "title": "Ukiran Jepara",
          "location": "Jepara, Central Java",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": true,
          "likes": 145,
          "recommendation": 8.7,
          "kategori": "Wood carvings",
        },
        {
          "title": "Keris Surakarta",
          "location": "Solo, Central Java",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 115,
          "recommendation": 9.0,
          "kategori": "Traditional weapons",
        },
      ];
    } else if (category == "Local Foods") {
      return [
        {
          "title": "Rendang",
          "location": "West Sumatra",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 220,
          "recommendation": 9.7,
          "kategori": "Meat dishes",
        },
        {
          "title": "Nasi Gudeg",
          "location": "Yogyakarta",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": true,
          "likes": 175,
          "recommendation": 8.5,
          "kategori": "Rice meals",
        },
        {
          "title": "Klepon",
          "location": "Java",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 125,
          "recommendation": 7.8,
          "kategori": "Traditional desserts",
        },
      ];
    } else {
      // Default sample data for any other category
      return [
        {
          "title": "Sample Item 1 for $category",
          "location": "Sample Location 1",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 120,
          "recommendation": 8.5,
          "kategori": "Sample Category",
        },
        {
          "title": "Sample Item 2 for $category",
          "location": "Sample Location 2",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": true,
          "likes": 185,
          "recommendation": 7.8,
          "kategori": "Sample Category",
        },
        {
          "title": "Sample Item 3 for $category",
          "location": "Sample Location 3",
          "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 90,
          "recommendation": 9.2,
          "kategori": "Sample Category",
        },
      ];
    }
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
            const HomeAppBar(),
            Positioned(
              top: 16.5.h,
              left: Styles.mdPadding,
              right: Styles.mdPadding,
              child: Material(
                elevation: 10,
                shadowColor: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  child: SearchWidget(
                    hintText: "Find your culture",
                    controller: _searchController,
                    onChanged: (text) {
                      debugPrint('Search text: $text');
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
            SizedBox(height: Styles.lgSpacing),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(height: Styles.xsSpacing),
                  const CategoriesSection(),
                  const SizedBox(height: Styles.smSpacing),
                  const HomeFeaturedBanner(),
                  const SizedBox(height: Styles.smSpacing),
                  const HomeLocationBanner(),
                  const SizedBox(height: Styles.smSpacing),
                  
                  // Loop through all categories and create GenericSection widgets
                  for (var category in _categories) ...[
                    GenericSection(
                      title: category["title"]!,
                      categoryName: category["categoryName"]!,
                      items: _getSampleData(category["categoryName"]!),
                      locationIcon: Icon(
                        IconsaxPlusBold.location,
                        color: AppColors.success50,
                        size: 16,
                      ),
                    ),
                    const SizedBox(height: Styles.smSpacing),
                  ],
                  
                  const SizedBox(height: Styles.xlSpacing),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}