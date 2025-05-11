import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hireka_mobile/l10n/l10n.dart';
import 'package:hireka_mobile/routes/router.dart';
import 'package:hireka_mobile/util/extensions.dart';
import 'package:hireka_mobile/widgets/custom_button_onboarding.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:hireka_mobile/core/app_colors.dart';

import '../../../core/styles.dart';
import '../../../database/shared_preferences_service.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // final PageController _controller = PageController();
  // int currentIndex = 0;

  // Future<void> _goToNextPage() async {
  //   if (currentIndex < 2) {
  //     _controller.nextPage(
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeInOut,
  //     );
  //   } else {
  //     await SharedPreferencesService.setIsFirstTime(value: false);
  //     context.router.replace(const DashboardRoute());
  //   }
  // }

  // void _goToPreviousPage() {
  //   if (currentIndex > 0) {
  //     _controller.previousPage(
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeInOut,
  //     );
  //   }
  // }

  // void _skip() {
  //   _controller.animateToPage(
  //     2,
  //     duration: const Duration(milliseconds: 800),
  //     curve: Curves.easeInOut,
  //   );
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _controller.addListener(() {
  //     final newIndex = _controller.page?.round() ?? 0;
  //     if (newIndex != currentIndex) {
  //       setState(() {
  //         currentIndex = newIndex;
  //       });
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Placeholder()),
    );
  }

  // Widget _buildContent(String image, String title, String description) {
  //   return Center(
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Image.asset(
  //           image,
  //           width: 100.w,
  //           height: 36.h,
  //           fit: BoxFit.contain,
  //         ),
  //         Text(
  //           title,
  //           style: context.textTheme.headlineMedium?.copyWith(
  //             fontWeight: FontWeight.bold,
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //         const SizedBox(height: 12),
  //         Text(
  //           description,
  //           style: context.textTheme.bodySmall?.copyWith(
  //             fontSize: 13,
  //             color: AppColors.grey70,
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
