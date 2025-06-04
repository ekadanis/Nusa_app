import 'package:cloud_firestore/cloud_firestore.dart';
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
  final CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('categories');
  final CollectionReference destinationsCollection =
      FirebaseFirestore.instance.collection('destinations');

  // Loading state and Firebase data
  bool _isLoading = true;
  List<Map<String, dynamic>> _categoriesData = [];
  Map<String, List<Map<String, dynamic>>> _destinationsByCategory = {};

  @override
  void initState() {
    super.initState();
    _fetchFirebaseData();
  }

  // Fetch data from Firebase
  Future<void> _fetchFirebaseData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Fetch categories first
      QuerySnapshot categoriesSnapshot = await categoriesCollection.get();

      List<Map<String, dynamic>> fetchedCategories = [];

      for (var doc in categoriesSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        fetchedCategories.add({
          'id': doc.id,
          'categoryName': data['categoryName'] ?? '',
          'title': data['title'] ?? data['categoryName'] ?? '',
          ...data,
        });
      }

      // Fetch destinations for each category
      Map<String, List<Map<String, dynamic>>> destinationsByCategory = {};

      for (var category in fetchedCategories) {
        String categoryId = category['id'];

        // Query destinations where categoryId matches
        QuerySnapshot destinationsSnapshot = await destinationsCollection
            .where('categoryId', isEqualTo: categoryId)
            .get();

        List<Map<String, dynamic>> destinations = [];

        for (var destDoc in destinationsSnapshot.docs) {
          Map<String, dynamic> destData =
              destDoc.data() as Map<String, dynamic>;
          destinations.add({
            'id': destDoc.id,
            'title': destData['title'] ?? 'Unknown',
            'location': destData['location'] ?? 'Unknown Location',
            'imageUrl': destData['imageUrl'] ??
                'https://images.unsplash.com/photo-1565967511849-76a60a516170',
            'isFavorite': destData['isFavorite'] ?? false,
            'category': destData['category'] ?? category['title'],
            'categoryId': categoryId,
            'likes': destData['likes'] ?? 0,
            'recommendation': destData['recommendation'] ?? 0.0,
            'kategori':
                destData['kategori'] ?? destData['category'] ?? 'General',
            ...destData,
          });
        }

        destinationsByCategory[category['categoryName']] = destinations;
      }

      setState(() {
        _categoriesData = fetchedCategories;
        _destinationsByCategory = destinationsByCategory;
        _isLoading = false;
      });

      // Debug print to see what we got from Firebase
      print(
          '🔥 Firebase Categories Fetched: ${_categoriesData.length} categories');
      for (var category in _categoriesData) {
        String categoryName = category['categoryName'];
        int destinationCount =
            _destinationsByCategory[categoryName]?.length ?? 0;
        print('- ${category['title']}: $destinationCount destinations');
      }
    } catch (e) {
      print('❌ Error fetching Firebase data: $e');
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Default categories structure (fallback)
  final List<Map<String, String>> _defaultCategories = [
    {"title": "Cultural Sites", "categoryName": "Cultural Sites"},
    {"title": "Arts & Culture", "categoryName": "Arts & Culture"},
    {"title": "Folk Instruments", "categoryName": "Folk Instruments"},
    {"title": "Traditional Wear", "categoryName": "Traditional Wear"},
    {"title": "Crafts & Artifacts", "categoryName": "Crafts & Artifacts"},
    {"title": "Local Foods", "categoryName": "Local Foods"},
  ];

  // Get categories - Firebase data or default
  List<Map<String, String>> _getCategories() {
    if (_categoriesData.isNotEmpty) {
      return _categoriesData.map((category) {
        return {
          "title":
              (category['title'] ?? category['categoryName'] ?? '').toString(),
          "categoryName": (category['categoryName'] ?? '').toString(),
        };
      }).toList();
    }
    return _defaultCategories;
  }

  // Get data for each section - Firebase data or sample data
  List<Map<String, dynamic>> _getDataForSection(String categoryName) {
    // First try to get from Firebase destinations
    if (_destinationsByCategory.containsKey(categoryName) &&
        _destinationsByCategory[categoryName]!.isNotEmpty) {
      return _destinationsByCategory[categoryName]!;
    }

    // Fallback to sample data
    return _getSampleData(categoryName);
  }

  // Sample data function - fallback when Firebase data is not available
  List<Map<String, dynamic>> _getSampleData(String category) {
    if (category == "Cultural Sites") {
      return [
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
    } else if (category == "Arts & Culture") {
      return [
        {
          "title": "Batik Parang",
          "location": "Solo, Central Java",
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 120,
          "recommendation": 8.5,
          "kategori": "Hand-drawn batik",
        },
        {
          "title": "Batik Mega Mendung",
          "location": "Cirebon, West Java",
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": true,
          "likes": 185,
          "recommendation": 7.8,
          "kategori": "Hand-drawn batik",
        },
        {
          "title": "Songket Palembang",
          "location": "Palembang, South Sumatra",
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
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
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 150,
          "recommendation": 8.7,
          "kategori": "Bamboo instruments",
        },
        {
          "title": "Gamelan",
          "location": "Yogyakarta, DIY",
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": true,
          "likes": 230,
          "recommendation": 9.4,
          "kategori": "Gongs",
        },
        {
          "title": "Sasando",
          "location": "NTT",
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
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
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 170,
          "recommendation": 8.9,
          "kategori": "Women's dresses",
        },
        {
          "title": "Beskap",
          "location": "Central Java",
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": true,
          "likes": 110,
          "recommendation": 7.6,
          "kategori": "Men's outfits",
        },
        {
          "title": "Baju Bodo",
          "location": "South Sulawesi",
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
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
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 130,
          "recommendation": 8.3,
          "kategori": "Puppetry & masks",
        },
        {
          "title": "Ukiran Jepara",
          "location": "Jepara, Central Java",
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": true,
          "likes": 145,
          "recommendation": 8.7,
          "kategori": "Wood carvings",
        },
        {
          "title": "Keris Surakarta",
          "location": "Solo, Central Java",
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
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
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 220,
          "recommendation": 9.7,
          "kategori": "Meat dishes",
        },
        {
          "title": "Nasi Gudeg",
          "location": "Yogyakarta",
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": true,
          "likes": 175,
          "recommendation": 8.5,
          "kategori": "Rice meals",
        },
        {
          "title": "Klepon",
          "location": "Java",
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
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
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": false,
          "likes": 120,
          "recommendation": 8.5,
          "kategori": "Sample Category",
        },
        {
          "title": "Sample Item 2 for $category",
          "location": "Sample Location 2",
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
          "isFavorite": true,
          "likes": 185,
          "recommendation": 7.8,
          "kategori": "Sample Category",
        },
        {
          "title": "Sample Item 3 for $category",
          "location": "Sample Location 3",
          "imageUrl":
              "https://images.unsplash.com/photo-1565967511849-76a60a516170",
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
    final categories = _getCategories();

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

            // Show loading indicator
            if (_isLoading)
              Padding(
                padding: EdgeInsets.all(2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary50,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Loading cultural data...',
                      style: TextStyle(
                        color: AppColors.primary50,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchFirebaseData,
                color: AppColors.primary50,
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

                    // Firebase Data Status (for debugging)
                    if (!_isLoading) ...[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Styles.mdPadding),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: _categoriesData.isNotEmpty
                                ? AppColors.success50.withOpacity(0.1)
                                : AppColors.danger50.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _categoriesData.isNotEmpty
                                  ? AppColors.success50.withOpacity(0.3)
                                  : AppColors.danger50.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _categoriesData.isNotEmpty
                                    ? IconsaxPlusBold.tick_circle
                                    : IconsaxPlusBold.close_circle,
                                color: _categoriesData.isNotEmpty
                                    ? AppColors.success50
                                    : AppColors.danger50,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  _categoriesData.isNotEmpty
                                      ? '🔥 Firebase: ${_categoriesData.length} categories loaded'
                                      : '📦 Using sample data (Firebase empty)',
                                  style: TextStyle(
                                    color: _categoriesData.isNotEmpty
                                        ? AppColors.success50
                                        : AppColors.danger50,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: Styles.smSpacing),
                    ],

                    // Loop through all categories and create GenericSection widgets
                    for (var category in categories) ...[
                      GenericSection(
                        title: category["title"]!,
                        categoryName: category["categoryName"]!,
                        items: _getDataForSection(category["categoryName"]!),
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
            ),
          ],
        ),
      ),
    );
  }
}
