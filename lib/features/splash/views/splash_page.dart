import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hireka_mobile/core/app_colors.dart';
import 'package:hireka_mobile/core/styles.dart';
import 'package:hireka_mobile/database/shared_preferences_service.dart';
import 'package:hireka_mobile/l10n/l10n.dart';
import 'package:hireka_mobile/routes/router.dart';
import 'package:hireka_mobile/util/extensions.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    navigateToNextPage();

    super.initState();
  }

  void navigateToNextPage() {
    // bool isFirstTime = SharedPreferencesService.getIsFirstTime();
    bool isFirstTime = false;
    if (isFirstTime) {
      context.router.replace(const OnboardingRoute());
    } else {
      context.router.replace(const DashboardRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: AppColors.primary50),
      child: Center(
        child: Image.asset(
          'assets/core/logo.png',
          width: 138,
        ),
      ),
    ));
  }
}
