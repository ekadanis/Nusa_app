import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../models/quiz_models.dart';
import '../../../core/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final QuizCategory category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),        child: Padding(
          padding: EdgeInsets.all(3.w), // Menggunakan Sizer
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [// Icon
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    category.icon,
                    width: 8.w,
                    height: 8.w,
                    colorFilter: ColorFilter.mode(
                      category.color,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),              // Category Name
              Text(
                category.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 3.5.w, // Menggunakan Sizer
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Maksimal 2 baris
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 0.5.h),

              // Description
              Text(
                category.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey50,
                  fontSize: 2.5.w, // Menggunakan Sizer
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 1.5.h),

              // Start Quiz Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: category.color,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        IconsaxPlusBold.play,
                        color: Colors.white,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Start Quiz',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}