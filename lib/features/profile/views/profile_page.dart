import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:nusa_app/services/google_auth_service.dart';
import 'package:nusa_app/features/profile/widgets/profile_header.dart';
import 'package:nusa_app/features/profile/widgets/logout_button.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoggingOut = false;
  String displayName = '';
  String email = '';
  String? selectedAvatarPath;

  @override
  void initState() {
    super.initState();
    final user = GoogleAuthService.getUserInfo();
    displayName = user['displayName'] ?? 'User';
    email = user['email'] ?? 'No email';
    selectedAvatarPath = user['photoURL'];
    _loadUserInfo();
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);

    try {
      await GoogleAuthService.signOut();

      if (mounted) {
        context.router.replace(const LoginRoute());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully logged out'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.nusa90,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result =
                  await context.router.push(const EditProfileRoute());

              if (result == true) {
                // Refresh data user setelah kembali dari EditProfilePage
                _loadUserInfo();
              }
            },
          )
        ],
      ),
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          ProfileHeader(
            name: displayName,
            email: email,
            selectedAvatar: selectedAvatarPath,
            onAvatarSelected: (path) {
              setState(() => selectedAvatarPath = path);
            },
            showEditIcon: false,
            // onEditProfile: () => context.router.push(const EditProfileRoute()),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: LogoutButton(
              isLoading: _isLoggingOut,
              onPressed: _handleLogout,
            ),
          ),
        ],
      ),
    );
  }

  void _loadUserInfo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();
    if (data != null) {
      setState(() {
        displayName = data['name'] ?? 'User';
        email = data['email'] ?? 'No email';
        selectedAvatarPath = data['avatar'];
      });
    }
  }
}
