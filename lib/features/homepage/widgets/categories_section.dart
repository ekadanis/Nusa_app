import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/styles.dart';
import 'category_item.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the category items
    final List<Map<String, dynamic>> categories = [
      {
        "title": "Cultural Sites",
        "icon": "assets/category/Cultural.svg",
      },
      {
        "title": "Arts & Culture",
        "icon": "assets/category/Cultural-1.svg",
      },
      {
        "title": "Folk Instruments",
        "icon": "assets/category/Cultural-2.svg",
      },
      {
        "title": "Traditional Wear",
        "icon": "assets/category/Cultural-3.svg",
      },
      {
        "title": "Crafts & Artifacts",
        "icon": "assets/category/Cultural-4.svg",
      },
      {
        "title": "Local Foods",
        "icon": "assets/category/Cultural-5.svg",
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.9, // Adjusted for better proportion
        crossAxisSpacing: 10.0, // Increased spacing between columns
        mainAxisSpacing: 6.0, // Adjusted for better vertical spacing
        mainAxisExtent: 85, // Reduced from 90 for better fit
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryItem(
          title: categories[index]["title"],
          icon: SvgPicture.asset(categories[index]["icon"]),
          onTap: () {},
        );
      },
    );
  }
}