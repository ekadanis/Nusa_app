import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Tambahkan import ini
import 'package:nusa_app/l10n/l10n.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:nusa_app/util/extensions.dart';
import 'package:nusa_app/widgets/custom_button_onboarding.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:nusa_app/core/app_colors.dart';

import '../../../core/styles.dart';
import '../../../database/shared_preferences_service.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _skipToLastPage() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topRight,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.2),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _currentPage != 2
                      ? TextButton(
                          key: const ValueKey("skip"),
                          onPressed: _skipToLastPage,
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primary50,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 1.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                          ),
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        )
                      : const SizedBox(
                          key: ValueKey("skip-empty"),
                          width: 1,
                          height: 48,
                        ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildPage1(),
                  _buildPage2(),
                  _buildPage3(),
                ],
              ),
            ),

            // Page indicator and navigation
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Page indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary50
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: 30),

                  // Navigation button
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _currentPage == 2
                        ? SizedBox(
                            key: ValueKey("button"),
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                SharedPreferencesService.setIsFirstTime(false);
                                context.router.replace(const LoginRoute());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            key: ValueKey("empty"),
                            width: double.infinity,
                            height: 50,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 35.h, // Responsive height pakai Sizer
            width: 100.w, // Responsive width pakai Sizer
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SvgPicture.asset(
                'assets/images/onboarding/onboarding1.svg',
                fit: BoxFit.contain,
                placeholderBuilder: (BuildContext context) => Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 40),

          // Title
          Text(
            'Learn something',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary50,
            ),
          ),

          Text(
            'new every day.',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary50,
            ),
          ),

          SizedBox(height: 2.h),

          Flexible(
            child: Text(
              'Dive into Indonesia\'s traditions, history,\nand wisdom — made fun and easy to\nexplore!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 35.h,
            width: 100.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SvgPicture.asset(
                'assets/images/onboarding/onboarding2.svg',
                fit: BoxFit.contain,
                placeholderBuilder: (BuildContext context) => Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Text(
            'Discover Indonesian\nHeritage',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary50,
            ),
          ),
          SizedBox(height: 2.h),
          Flexible(
            child: Text(
              'Learn about the rich cultural diversity,\ntraditional arts, and historical landmarks\nthat make Indonesia unique.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 35.h,
            width: 100.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SvgPicture.asset(
                'assets/images/onboarding/onboarding3.svg',
                fit: BoxFit.contain,
                placeholderBuilder: (BuildContext context) => Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Text(
            'Start Your Learning\nJourney',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary50,
            ),
          ),
          SizedBox(height: 2.h),
          Flexible(
            child: Text(
              'Begin your adventure in understanding\nIndonesian wisdom, values, and\ntime-honored traditions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCharacter(Color color, int delay) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 1500 + (delay * 200)),
      curve: Curves.elasticOut,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.danger50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.brown[300],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 25,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
