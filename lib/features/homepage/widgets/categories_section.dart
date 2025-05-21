import 'package:flutter/material.dart';
import '../../../../core/styles.dart';
import '../../../../core/app_colors.dart';
import '../../../features/katalog_produk/views/katalog_produk.dart';
import 'category_item.dart';
// Add the import for page_transition package
import 'package:page_transition/page_transition.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Styles.mdPadding),
      padding: const EdgeInsets.all(Styles.mdPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Styles.mdRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey20.withOpacity(0.8),
            blurRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoriesGrid(context),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.9,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 6.0,
        mainAxisExtent: 85,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return CategoryItem(
          title: category["title"] as String,
          iconPath: category["icon"] as String,
          colorHex: category["colorHex"] as String,
          onTap: () {
            // Use PageTransition for smoother transitions
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 400),
                child: KatalogProdukPage(
                  categoryName: category["title"] as String,
                ),
                childCurrent: widget, // Reference to current widget for smoother transition
                curve: Curves.easeInOut, // Smooth curve
              ),
            );
          },
        );
      },
    );
  }

  static const _categories = [
    {
      "title": "Cultural Sites",
      "icon": "assets/category/cultural_sites.svg",
      "colorHex": "E6EEF9",
    },
    {
      "title": "Arts & Culture",
      "icon": "assets/category/art_culture.svg",
      "colorHex": "FCD8CA",
    },
    {
      "title": "Folk Instruments",
      "icon": "assets/category/folk_instruments.svg",
      "colorHex": "D9EDE1",
    },
    {
      "title": "Traditional Wear",
      "icon": "assets/category/traditional_wear.svg",
      "colorHex": "F5EDD1",
    },
    {
      "title": "Crafts & Artifacts",
      "icon": "assets/category/craft_artifacts.svg",
      "colorHex": "F8CECE",
    },
    {
      "title": "Local Foods",
      "icon": "assets/category/local_foods.svg",
      "colorHex": "DFD0FC",
    },
  ];
}