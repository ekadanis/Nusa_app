import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class OfflineScreen extends StatelessWidget {
  final VoidCallback? onRetry;

  const OfflineScreen({
    Key? key,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Offline Icon
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  color: AppColors.grey20,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  IconsaxPlusBold.wifi_square,
                  size: 12.w,
                  color: AppColors.grey50,
                ),
              ),

              SizedBox(height: 4.h), // Main Message
              Text(
                'No Internet Connection',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.grey80,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 1.5.h),

              // Sub Message
              Text(
                'Please check your internet connection and try again.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey60,
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 4.h),

              // Retry Button
              if (onRetry != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: Icon(
                      IconsaxPlusBold.refresh,
                      size: 5.w,
                    ),
                    label: Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary50,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 1.8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
