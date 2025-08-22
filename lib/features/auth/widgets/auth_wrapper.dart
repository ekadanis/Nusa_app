import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nusa_app/services/google_auth_service.dart';
import 'package:nusa_app/features/auth/views/login_page.dart';
import 'package:nusa_app/features/dashboard/views/dashboard_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: GoogleAuthService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading indicator while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Check if user is signed in
        if (snapshot.hasData && snapshot.data != null) {
          // User is signed in, show dashboard
          return const DashboardPage();
        } else {
          // User is not signed in, show login page
          return const LoginPage();
        }
      },
    );
  }
}
