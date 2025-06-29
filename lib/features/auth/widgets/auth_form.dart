import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:nusa_app/features/auth/widgets/nusa_password_field.dart';
import 'package:nusa_app/features/auth/widgets/nusa_text_field.dart';
import 'package:nusa_app/features/auth/widgets/submit_button.dart';
import 'package:nusa_app/core/app_colors.dart';

class AuthForm extends StatelessWidget {
  final TextEditingController? nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final bool rememberMe;
  final void Function(bool?)? onRememberChanged;
  final VoidCallback onForgotPassword;
  final VoidCallback onSubmit;
  final VoidCallback onRegister;
  final Widget extraButton;
  final bool isRegister;
  final String submitText;

  const AuthForm({
    super.key,
    this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.rememberMe,
    required this.onRememberChanged,
    required this.onForgotPassword,
    required this.onSubmit,
    required this.onRegister,
    required this.extraButton,
    this.isRegister = false,
    this.submitText = "Sign In",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isRegister && nameController != null) ...[
          Text("Name",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 1.h),
          NusaTextField(
            controller: nameController!,
            hintText: "Enter Your Name",
            icon: Icons.person_outline,
          ),
          SizedBox(height: 2.h),
        ],
        Text("Email",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 1.h),
        NusaTextField(
          controller: emailController,
          hintText: "Enter Email Address",
          icon: Icons.email_outlined,
        ),
        SizedBox(height: 3.h),
        Text("Password",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 1.h),
        NusaPasswordField(controller: passwordController),
        SizedBox(height: 2.h),
        if (!isRegister) // hanya untuk Login
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: onRememberChanged,
                    activeColor: AppColors.primary50,
                  ),
                  Text("Remember Me",
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              TextButton(
                onPressed: onForgotPassword,
                child: Text(
                  "Forgot Password?",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary50,
                      ),
                ),
              )
            ],
          ),
        if (!isRegister) SizedBox(height: 2.h),
        SubmitButton(
          isLoading: isLoading,
          onPressed: onSubmit,
          text: submitText,
        ),
        SizedBox(height: 2.h),
        extraButton,
        SizedBox(height: 2.5.h),
        Center(
          child: GestureDetector(
            onTap: onRegister,
            child: RichText(
              text: TextSpan(
                text: isRegister
                    ? "Already have an account? "
                    : "Don't have an account? ",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.grey90,
                      fontSize: 14.sp,
                    ),
                children: [
                  TextSpan(
                    text: isRegister ? "Login Now" : "Register Now",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primary50,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 14.sp,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _labelStyle() => TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.bold,
      );
}
