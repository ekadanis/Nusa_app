import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/widgets/back_button.dart';

class ImageResultHeader extends StatelessWidget {
  final File image;
  final String cultureName;

  const ImageResultHeader({
    Key? key,
    required this.image,
    required this.cultureName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      child: Container(
        height: 30.h,
        width: 100.w,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.file(
                image,
                fit: BoxFit.cover,
              ),
            ),
            
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Back Button
            Positioned(
              top: 5.h,
              left: 4.w,
              child: CustomBackButton(
                backgroundColor: AppColors.grey60.withOpacity(0.3),
                iconColor: AppColors.grey10,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),

            // Culture Name
            Positioned(
              bottom: 3.h,
              left: 4.w,
              right: 4.w,
              child: Text(
                cultureName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
