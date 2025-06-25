import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:nusa_app/features/auth/widgets/nusa_password_field.dart';
import 'package:nusa_app/features/auth/widgets/nusa_text_field.dart';
import 'package:nusa_app/features/auth/widgets/submit_button.dart';

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
          Text("Name", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          SizedBox(height: 1.h),
          NusaTextField(
            controller: nameController!,
            hintText: "Enter Your Name",
            icon: Icons.person_outline,
          ),
          SizedBox(height: 2.h),
        ],

        Text("Email", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        SizedBox(height: 1.h),
        NusaTextField(
          controller: emailController,
          hintText: "Enter Email Address",
          icon: Icons.email_outlined,
        ),
        SizedBox(height: 3.h),

        Text("Password", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
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
                  ),
                  const Text("Remember Me"),
                ],
              ),
              TextButton(
                onPressed: onForgotPassword,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: Colors.blueAccent,
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

        Center(
          child: GestureDetector(
            onTap: onRegister,
            child: RichText(
              text: TextSpan(
                text: isRegister ? "Already have an account? " : "Don't have an account? ",
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: isRegister ? "Login Now" : "Register Now",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 2.5.h),
        extraButton,
      ],
    );
  }

  TextStyle _labelStyle() => TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.bold,
      );
}
