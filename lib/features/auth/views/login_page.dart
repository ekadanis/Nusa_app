import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/routes/router.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/core/logo.png',
              width: 138,
              color: AppColors.nusa90,
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              "Let's Get You Started With Nusa",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.grey400,
                    fontWeight: FontWeight.w100,
                  ),
            ),
            SizedBox(
              height: 52,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _socialLoginButton(
                context: context,
                onPressed: () {
                  context.router.push(DashboardRoute());
                },
                text: "Sign In Using Google Account",
                icon: Image.asset(
                  // 'assets/icons/google.svg',
                  'assets/core/logo.png',
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialLoginButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required String text,
    required Widget icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(color: Colors.grey[300]!),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            SizedBox(width: 28, child: icon),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey400,
                    ),
              ),
            ),
            const SizedBox(width: 28),
          ],
        ),
      ),
    );
  }
}
