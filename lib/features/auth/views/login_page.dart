import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:nusa_app/services/google_auth_service.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await GoogleAuthService.signInWithGoogle();
      
      if (userCredential != null && mounted) {        // Successfully signed in, navigate to dashboard  
        context.router.replace(const DashboardRoute());
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome, ${userCredential.user?.displayName ?? 'User'}!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }  }

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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.grey400,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(
              height: 52,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),              child: _socialLoginButton(
                context: context,
                onPressed: _isLoading ? null : () => _handleGoogleSignIn(),
                text: _isLoading ? "Signing in..." : "Sign In Using Google Account",
                icon: _isLoading 
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.nusa90),
                      ),
                    )
                  : Image.asset(
                      'assets/icons/google.png',
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
    required VoidCallback? onPressed,
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
