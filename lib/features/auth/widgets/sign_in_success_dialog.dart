import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:sizer/sizer.dart';

class SignInSuccessDialog extends StatelessWidget {
  const SignInSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🔵 Background blur
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        Center(
          child: Container(
            width: 80.w,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/banner/loading-signIn.png',
                  width: 24.w,
                ),
                SizedBox(height: 2.h),
                const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.nusa90,
                  ),
                ),
                const Text(
                  "Successful",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.nusa90,
                  ),
                ),
                SizedBox(height: 2.h),
                const Text(
                  "Please wait...\nYou will be directed to the homepage soon.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 3.h),
                const CircularProgressIndicator(
                  color: AppColors.nusa90,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
