import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;
  final String title;
  final String subtitle;
  final bool showBackButton;

  const AuthWrapper({
    super.key,
    required this.child,
    this.title = "Welcome 👋",
    this.subtitle = "Let’s Get You Started With Nusa",
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(height: 1.h),
        // if (showBackButton)
        //   Align(
        //     alignment: Alignment.centerLeft,
        //     child: IconButton(
        //       icon: const Icon(Icons.arrow_back, color: Colors.white),
        //       onPressed: () => Navigator.pop(context),
        //     ),
        //   ),
        SizedBox(height: 2.h),
        Column(
          children: [
            SvgPicture.asset(
              'assets/core/logo.svg',
              width: 20.w,
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            padding:
                EdgeInsets.only(left: 6.w, right: 6.w, bottom: 3.h, top: 1.h),
            child: SingleChildScrollView(child: child),
          ),
        ),
      ],
    );
  }
}
