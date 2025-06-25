import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/features/auth/services/auth_service.dart';
import 'package:nusa_app/features/auth/widgets/auth_form.dart';
import 'package:nusa_app/features/auth/widgets/auth_wrapper.dart';
import 'package:nusa_app/features/profile/widgets/avatar_display.dart';
import 'package:nusa_app/features/profile/widgets/avatar_picker_dialog.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final auth = AuthService();

  String? selectedAvatarPath;
  bool isLoading = false;

  Future<void> _handleRegister() async {
    setState(() => isLoading = true);

    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();

    print("Email: '$email', Password: '$password'");
    
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      setState(() => isLoading = false);
      return;
    }

    final error = await auth.register(
      email,
      password,
      name,
      selectedAvatarPath ?? AvatarPickerDialog.avatarList[0],
    );

    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    } else {
      if (mounted) context.router.replace(const DashboardRoute());
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nusa90,
      body: SafeArea(
        child: AuthWrapper(
          title: "Create A New Account",
          subtitle: "Register & Get fun and easy to explore",
          showBackButton: true,
          child: Column(
            children: [
              AvatarDisplay(
                selectedAvatar: selectedAvatarPath,
                onAvatarSelected: (avatar) {
                  setState(() => selectedAvatarPath = avatar);
                },
              ),
              SizedBox(height: 2.h),
              AuthForm(
                nameController: nameCtrl,
                emailController: emailCtrl,
                passwordController: passwordCtrl,
                isLoading: isLoading,
                rememberMe: false,
                onRememberChanged: (_) {},
                onForgotPassword: () {},
                onSubmit: _handleRegister,
                onRegister: () => Navigator.pop(context),
                extraButton: SizedBox(height: 2.h),
                isRegister: true,
                submitText: "Register",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
