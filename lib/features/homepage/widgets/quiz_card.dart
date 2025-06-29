import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/util/extensions.dart';
import 'package:sizer/sizer.dart';

import '../../../core/styles.dart';
import '../../../routes/router.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 1.5.h, // Extra space untuk floating decorations
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main card container
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary50,
                  AppColors.primary50.withOpacity(0.9),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary50.withOpacity(0.4),
                  blurRadius: 2.h,
                  offset: Offset(0, 1.h),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Fun multi-layer game icon
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 9.w,
                          height: 9.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        Container(
                          width: 7.2.w,
                          height: 7.2.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.yellow.withOpacity(0.3),
                                Colors.orange.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(1.2.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white.withOpacity(0.2),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 0.5.w,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                IconsaxPlusBold.game,
                                color: AppColors.white,
                                size: 5.w,
                              ),
                              Positioned(
                                top: 0.5.w,
                                right: 0.5.w,
                                child: Container(
                                  width: 1.2.w,
                                  height: 1.2.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.yellow,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.yellow.withOpacity(0.5),
                                        blurRadius: 1.w,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Fun title with emoji
                          RichText(
                            text: TextSpan(
                              style: context.textTheme.titleLarge?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                              children: [
                                TextSpan(text: "Learn Culture, "),
                                TextSpan(
                                  text: "🌟",
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "The Fun Way!",
                            style: context.textTheme.titleLarge?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          // Fun subtitle with badge style
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 0.7.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("🎮", style: TextStyle(fontSize: 9.sp)),
                                SizedBox(width: 1.w),
                                Text(
                                  "Play game and get your point!",
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: AppColors.white,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Super fun button
                Container(
                  width: double.infinity,
                  height: 6.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Styles.mdRadius + 2),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.white,
                        AppColors.white.withOpacity(0.95),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 1.5.h,
                        offset: Offset(0, 0.5.h),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: 1.h,
                        offset: Offset(0, -0.2.h),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.primary50,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Styles.mdRadius + 2),
                      ),
                    ),
                    onPressed: () {
                      context.router.navigate(const HomeRouteQuiz());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Fun play icon container
                        Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary50.withOpacity(0.1),
                                AppColors.primary50.withOpacity(0.05),
                              ],
                            ),
                          ),
                          child: Icon(
                            IconsaxPlusBold.play,
                            color: AppColors.primary50,
                            size: 4.w,
                          ),
                        ),

                        SizedBox(width: 2.w),

                        Text(
                          "Let's Play Now",
                          style: context.textTheme.titleMedium?.copyWith(
                            color: AppColors.primary50,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),

                        SizedBox(width: 1.w),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Fun floating decorations - positioned relative to the card
          Positioned(
            top: -2.w,
            right: 3.w,
            child: Text(
              '🎯',
              style: TextStyle(
                fontSize: 6.w,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 1.5.w,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 4.w,
            left: -1.w,
            child: Text('⭐', style: TextStyle(fontSize: 4.w)),
          ),
          Positioned(
            bottom: -2.w,
            right: 4.w,
            child: Text('🎉', style: TextStyle(fontSize: 5.w)),
          ),
          Positioned(
            bottom: 4.w,
            left: -2.w,
            child: Text('🔥', style: TextStyle(fontSize: 3.5.w)),
          ),
        ],
      ),
    );
  }
}
