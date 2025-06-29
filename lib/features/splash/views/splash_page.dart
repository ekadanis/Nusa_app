import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/core/styles.dart';
import 'package:nusa_app/database/shared_preferences_service.dart';
import 'package:nusa_app/l10n/l10n.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:nusa_app/services/google_auth_service.dart';
import 'package:nusa_app/util/extensions.dart';
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
    print("\n\nINITIAL PAGE\n\n");
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      navigateToNextPage();
    });
  }

  void navigateToNextPage() async {
    // Cek status authentication terlebih dahulu
    final isAuthenticated = GoogleAuthService.isSignedIn;
    
    if (isAuthenticated) {
      // Jika sudah login, langsung ke dashboard
      context.router.replace(const DashboardRoute());
      return;
    }
    
    // Jika belum login, cek apakah first time
    final isFirstTime = await SharedPreferencesService.getIsFirstTime();

    if (isFirstTime) {
      context.router.replace(const OnboardingRoute());
    } else {
      context.router.replace(const LoginRoute()); // ke halaman login
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: AppColors.primary50),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/core/logo.svg',
              width: 138,
            ),
            SizedBox(height: 2.h),
            Text(
              'nusa',
              style: TextStyle(
                fontSize: 30.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
