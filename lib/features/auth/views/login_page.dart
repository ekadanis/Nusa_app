import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/features/auth/services/auth_service.dart';
import 'package:nusa_app/features/auth/services/secure_storage_service.dart';
import 'package:nusa_app/features/auth/widgets/auth_form.dart';
import 'package:nusa_app/features/auth/widgets/auth_wrapper.dart';
import 'package:nusa_app/features/auth/widgets/google_sign_in_button.dart';
import 'package:nusa_app/features/auth/widgets/sign_in_success_dialog.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:nusa_app/services/google_auth_service.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final auth = AuthService();
  final storage = SecureStorageService();

  bool isLoading = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  //remember Me
  void _loadSavedCredentials() async {
    final creds = await storage.getCredentials();
    setState(() {
      emailCtrl.text = creds['email'] ?? '';
      passwordCtrl.text = creds['password'] ?? '';
      rememberMe = creds['email'] != null && creds['password'] != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nusa90,
      body: SafeArea(
        child: AuthWrapper(
          child: AuthForm(
            emailController: emailCtrl,
            passwordController: passwordCtrl,
            isLoading: isLoading,
            rememberMe: rememberMe,
            onRememberChanged: (val) =>
                setState(() => rememberMe = val ?? false),
            onForgotPassword: _handleForgotPassword,
            onSubmit: _handleLogin,
            onRegister: () => context.router.push(const RegisterRoute()),
            extraButton: GoogleSignInButton(
              isLoading: isLoading,
              onPressed: _handleGoogleSignIn,
            ),
            isRegister: false,
            submitText: "Sign In",
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() => isLoading = true);

    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();

    print("Email: '$email', Password: '$password'");

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      setState(() => isLoading = false);
      return;
    }

    final error = await auth.login(email, password);

    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      await storage.clearCredentials();
    } else {
      if (rememberMe) {
        await storage.saveCredentials(email, password);
      } else {
        await storage.clearCredentials();
      }

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const SignInSuccessDialog(),
        );

        // Tunggu 2 detik lalu navigasi ke dashboard
        await Future.delayed(const Duration(seconds: 2));
        if (context.mounted) {
          context.router.replace(const DashboardRoute());
        }
      }
    }

    setState(() => isLoading = false);
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => isLoading = true);

    try {
      final userCredential = await GoogleAuthService.signInWithGoogle();
      if (userCredential != null && mounted) {
        context.router.replace(const DashboardRoute());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Welcome, ${userCredential.user?.displayName ?? 'User'}!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _handleForgotPassword() async {
    final email = emailCtrl.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email first.")),
      );
      return;
    }

    final error = await auth.forgotPassword(email);

    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset email sent.")),
        );
      }
    }
  }
}
