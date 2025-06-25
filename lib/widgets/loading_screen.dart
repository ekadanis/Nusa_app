import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nusa_app/core/app_colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.beat(
              color: AppColors.primary50,
              size: 15.w,
            ),
            SizedBox(height: 3.h),
            Text(
              'Generating content with AI...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.grey60,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Please wait a moment',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey50,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
