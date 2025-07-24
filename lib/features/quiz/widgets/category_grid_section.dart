import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sizer/sizer.dart';
import '../../../routes/router.dart';
import '../services/quiz_service.dart';
import '../widgets/category_card.dart';
import '../../../helpers/user_action_tracker.dart';

class CategoryGridSection extends StatelessWidget {
  const CategoryGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = QuizService.getCategories();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Category',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        SizedBox(height: 2.h),
        
        // Categories Grid - Fixed tanpa scroll
        SizedBox(
          height: 80.h, // Height diperbesar untuk menampilkan semua 6 kategori (3 baris x 2 kolom)
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(), // Tidak bisa di-scroll
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85, // Ratio yang pas untuk card
              crossAxisSpacing: 3.w, // Menggunakan Sizer
              mainAxisSpacing: 1.5.h, // Spacing antar baris
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {              return CategoryCard(
                category: categories[index],
                onTap: () async {
                  // Track category exploration for achievements
                  await UserActionTracker.trackCategoryExplored(categories[index].id);
                  
                  // Navigate to quiz dengan parameter yang benar
                  context.router.push(
                    QuizRoute(categoryId: categories[index].id),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
