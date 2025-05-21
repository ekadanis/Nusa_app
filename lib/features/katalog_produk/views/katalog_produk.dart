import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sizer/sizer.dart';
import '../../../core/styles.dart';
import '../../../widgets/custom_search.dart';
import '../widgets/HomeAppBar_KatalogScreen.dart';
import '../widgets/product_grid_section.dart';

@RoutePage()
class KatalogProdukPage extends StatefulWidget {
  final String? categoryName;
  
  const KatalogProdukPage({Key? key, this.categoryName}) : super(key: key);

  @override
  State<KatalogProdukPage> createState() => _KatalogProdukPageState();
}

class _KatalogProdukPageState extends State<KatalogProdukPage> {
  final TextEditingController _searchController = TextEditingController();
  late List<Map<String, dynamic>> _productsList;
  late Map<String, dynamic> _selectedCategory;
  
  @override
  void initState() {
    super.initState();
    _initializeData();
  }
    void _initializeData() {
    // Find the selected category from the categories list
    // Debug print to check what category name is being passed
    debugPrint('Searching for category: ${widget.categoryName}');
    
    // List all available categories for debugging
    debugPrint('Available categories: ${_categories.map((c) => c["category"]).toList()}');
    
    _selectedCategory = _categories.firstWhere(
      (category) {
        debugPrint('Checking against: ${category["category"]}');
        return category["category"] == (widget.categoryName ?? "Cultural Sites");
      },
      orElse: () {
        debugPrint('No matching category found, using first category');
        return _categories.first;
      },
    );
    
    // Initialize products list based on the category
    _productsList = _getDummyProducts(_selectedCategory["category"]);
  }
    List<Map<String, dynamic>> _getDummyProducts(String category) {
    // This would normally come from an API or database
    // For now, we'll create dummy data based on the category
    switch(category) {
      case "Cultural Sites":
        return [
          {
            "title": "Candi Borobudur",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Magelang, Central Java",
            "isFavorite": true,
            "category": "Temple"
          },
          {
            "title": "Candi Prambanan",
            "imageUrl": "https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272",
            "location": "Yogyakarta, DIY",
            "isFavorite": false,
            "category": "Temple"
          },
          {
            "title": "Taman Mini Indonesia Indah",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Jakarta, DKI Jakarta",
            "isFavorite": true,
            "category": "Cultural Park"
          },
          {
            "title": "Keraton Yogyakarta",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Yogyakarta, DIY",
            "isFavorite": false,
            "category": "Palace"
          },
          {
            "title": "Rumah Gadang",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Padang, West Sumatra",
            "isFavorite": true,
            "category": "Traditional House"
          },
          {
            "title": "Situs Gunung Padang",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Cianjur, West Java",
            "isFavorite": false,
            "category": "Archaelogical Site"
          },
        ];
      case "Arts & Culture":
        return [
          {
            "title": "Batik Parang",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Solo, Central Java",
            "isFavorite": true,
            "category": "Hand-drawn batik"
          },
          {
            "title": "Batik Mega Mendung",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Cirebon, West Java",
            "isFavorite": false,
            "category": "Hand-drawn batik"
          },
          {
            "title": "Songket Palembang",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Palembang, South Sumatra",
            "isFavorite": true,
            "category": "Songket"
          },
          {
            "title": "Tenun Ikat Sumba",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Sumba, East Nusa Tenggara",
            "isFavorite": false,            "category": "Woven fabrics"
          },
        ];
      case "Crafts & Artifacts":
        return [
          {
            "title": "Wayang Kulit Jawa",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Solo, Central Java",
            "isFavorite": true,
            "category": "Puppetry & masks"
          },
          {
            "title": "Ukiran Jepara",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Jepara, Central Java",
            "isFavorite": false,
            "category": "Wood carvings"
          },
          {
            "title": "Keramik Plered",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Purwakarta, West Java",
            "isFavorite": true,
            "category": "Pottery & ceramics"
          },
          {
            "title": "Keris Surakarta",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Solo, Central Java",
            "isFavorite": false,            "category": "Traditional weapons"
          },
        ];
      case "Folk Instruments":
        return [
          {
            "title": "Angklung",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Bandung, West Java",
            "isFavorite": true,
            "category": "Bamboo instruments"
          },
          {
            "title": "Gamelan",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Yogyakarta, DIY",
            "isFavorite": false,
            "category": "Gongs"
          },
          {
            "title": "Kendang",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Bali",
            "isFavorite": true,
            "category": "Percussion drums"
          },
          {
            "title": "Sasando",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "NTT",
            "isFavorite": false,
            "category": "String instruments"
          },
        ];
      case "Traditional Wear":
        return [
          {
            "title": "Kebaya",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Java",
            "isFavorite": true,
            "category": "Women's dresses"
          },
          {
            "title": "Beskap",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Central Java",
            "isFavorite": false,
            "category": "Men's outfits"
          },
          {
            "title": "Baju Bodo",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "South Sulawesi",
            "isFavorite": true,
            "category": "Women's dresses"
          },
          {
            "title": "Pakaian Adat Dayak",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Kalimantan",
            "isFavorite": false,
            "category": "Festival costumes"
          },
        ];
      case "Local Foods":
        return [
          {
            "title": "Rendang",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "West Sumatra",
            "isFavorite": true,
            "category": "Meat dishes"
          },
          {
            "title": "Nasi Gudeg",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Yogyakarta",
            "isFavorite": false,
            "category": "Rice meals"
          },
          {
            "title": "Sate Padang",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "West Sumatra",
            "isFavorite": true,
            "category": "Meat dishes"
          },
          {
            "title": "Klepon",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Java",
            "isFavorite": false,
            "category": "Traditional desserts"
          },
        ];
      default:
        return [
          {
            "title": "Sample Item",
            "imageUrl": "https://images.unsplash.com/photo-1565967511849-76a60a516170",
            "location": "Sample Location",
            "isFavorite": false,
            "category": "Sample Category"
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                HomeAppBar(
                  categoryName: _selectedCategory["category"],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Styles.mdSpacing),
                        ProductGridSection(
                          products: _productsList,
                          customFilters: List<String>.from(_selectedCategory["subcategories"]),
                        ),
                        const SizedBox(height: Styles.mdSpacing),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 15.h,
              left: 0,
              right: 0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Styles.mdPadding),
                  child: SearchWidget(
                    hintText: "Find Your Culture",
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
    );
  }
    // Categories data
  static final List<Map<String, dynamic>> _categories = [
    {
      "category": "Cultural Sites",
      "subcategories": [
        "All",
        "Temple",
        "Cultural Park",
        "Archaelogical Site",
        "Traditional House"
      ]
    },
    {
      "category": "Arts & Culture",
      "subcategories": [
        "All",
        "Hand-drawn batik",
        "Stamped batik",
        "Woven fabrics",
        "Songket"
      ]
    },
    {
      "category": "Folk Instruments",
      "subcategories": [
        "All",
        "Bamboo instruments",
        "Percussion drums",
        "String instruments",
        "Gongs"
      ]
    },
    {
      "category": "Traditional Wear",
      "subcategories": [
        "All",
        "Women's dresses",
        "Men's outfits",
        "Ritual attire",
        "Festival costumes"
      ]
    },
    {
      "category": "Crafts & Artifacts",
      "subcategories": [
        "All",
        "Puppetry & masks",
        "Wood carvings",
        "Pottery & ceramics",
        "Traditional weapons"
      ]
    },
    {
      "category": "Local Foods",
      "subcategories": [
        "All",
        "Meat dishes",
        "Rice meals",
        "Street snacks",
        "Traditional desserts"
      ]
    }
  ];
}
