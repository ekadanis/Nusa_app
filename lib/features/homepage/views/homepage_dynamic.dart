// import 'package:flutter/material.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:sizer/sizer.dart';
// import 'package:iconsax_plus/iconsax_plus.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../../core/styles.dart';
// import '../../../core/app_colors.dart';
// import '../../../widgets/custom_search.dart';
// import '../widgets/home_app_bar.dart';
// import '../widgets/home_featured_banner.dart';
// import '../widgets/home_location_banner.dart';
// import '../widgets/categories_section.dart';
// import '../widgets/generic_section.dart';

// @RoutePage()
// class HomePageDynamic extends StatefulWidget {
//   const HomePageDynamic({Key? key}) : super(key: key);

//   @override
//   State<HomePageDynamic> createState() => _HomePageDynamicState();
// }

// class _HomePageDynamicState extends State<HomePageDynamic> {
//   final TextEditingController _searchController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool _isLoading = true;
//   List<Map<String, String>> _categories = [];
//   Map<String, List<Map<String, dynamic>>> _categoryData = {};
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//   }

//   Future<void> _loadCategories() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = '';
//       });

//       // Load categories
//       final categoriesSnapshot = await _firestore.collection('categories').get();
//       final categoriesList = categoriesSnapshot.docs.map((doc) {
//         final data = doc.data();
//         return {
//           "title": data['title'] as String,
//           "categoryName": data['categoryName'] as String,
//         };
//       }).toList();

//       // Store categories
//       setState(() {
//         _categories = categoriesList;
//       });

//       // Load data for each category
//       for (var category in _categories) {
//         await _loadCategoryData(category['categoryName']!);
//       }

//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Failed to load data: ${e.toString()}';
//       });
//       debugPrint('Error loading categories: $e');
//     }
//   }

//   Future<void> _loadCategoryData(String categoryName) async {
//     try {
//       final itemsSnapshot = await _firestore
//           .collection('items')
//           .where('category', isEqualTo: categoryName)
//           .get();

//       final items = itemsSnapshot.docs.map((doc) {
//         final data = doc.data();
//         return {
//           "id": doc.id,
//           "title": data['title'] as String,
//           "location": data['location'] as String,
//           "imageUrl": data['imageUrl'] as String,
//           "isFavorite": data['isFavorite'] as bool? ?? false,
//           "likes": data['likes'] as int? ?? 0,
//           "recommendation": data['recommendation'] as double? ?? 0.0,
//           "kategori": data['kategori'] as String? ?? '',
//         };
//       }).toList();

//       setState(() {
//         _categoryData[categoryName] = items;
//       });
//     } catch (e) {
//       debugPrint('Error loading items for $categoryName: $e');
//     }
//   }

//   List<Map<String, dynamic>> _getCategoryData(String category) {
//     return _categoryData[category] ?? [];
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(22.h),
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             const HomeAppBar(),
//             Positioned(
//               top: 16.5.h,
//               left: Styles.mdPadding,
//               right: Styles.mdPadding,
//               child: Material(
//                 elevation: 10,
//                 shadowColor: Colors.black.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(12),
//                 child: SizedBox(
//                   child: SearchWidget(
//                     hintText: "Find your culture",
//                     controller: _searchController,
//                     onChanged: (text) {
//                       debugPrint('Search text: $text');
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         bottom: false,
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : _errorMessage.isNotEmpty
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(_errorMessage, 
//                           style: const TextStyle(color: Colors.red),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: _loadCategories,
//                           child: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   )
//                 : Column(
//                     children: [
//                       SizedBox(height: Styles.lgSpacing),
//                       Expanded(
//                         child: ListView(
//                           padding: const EdgeInsets.only(bottom: 24),
//                           physics: const BouncingScrollPhysics(),
//                           children: [
//                             SizedBox(height: Styles.xsSpacing),
//                             const CategoriesSection(),
//                             const SizedBox(height: Styles.smSpacing),
//                             const HomeFeaturedBanner(),
//                             const SizedBox(height: Styles.smSpacing),
//                             const HomeLocationBanner(),
//                             const SizedBox(height: Styles.smSpacing),
                            
//                             // Loop through all categories and create GenericSection widgets
//                             for (var category in _categories) ...[
//                               GenericSection(
//                                 title: category["title"]!,
//                                 categoryName: category["categoryName"]!,
//                                 items: _getCategoryData(category["categoryName"]!),
//                                 locationIcon: Icon(
//                                   IconsaxPlusBold.location,
//                                   color: AppColors.success50,
//                                   size: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: Styles.smSpacing),
//                             ],
                            
//                             const SizedBox(height: Styles.xlSpacing),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//       ),
//     );
//   }
// }