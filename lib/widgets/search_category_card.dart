import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart'; // Pastikan Sizer diinisialisasi di root (MyApp)

import '../core/styles.dart';
import '../widgets/custom_search.dart';
import '../features/homepage/widgets/categories_section.dart';

class SearchCategoryCard extends StatelessWidget {
  final String hintText;
  final Function()? onSearchTap;

  const SearchCategoryCard({
    Key? key,
    this.hintText = "Find your culture",
    this.onSearchTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 27.h, // Adjusted from 30.h to 27.h for better proportion
      padding: EdgeInsets.all(Styles.mdPadding),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Styles.mdRadius),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4, // Increased from 2 for smoother shadow
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          SearchWidget(
            hintText: hintText,
            onTap: onSearchTap,
          ),
          const SizedBox(height: Styles.mdSpacing), // Changed from lgSpacing to mdSpacing
          const Expanded(child: CategoriesSection()),
        ],
      ),
    );
  }
}
