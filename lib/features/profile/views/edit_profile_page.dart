import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/features/auth/widgets/nusa_text_field.dart';
import 'package:nusa_app/features/auth/widgets/submit_button.dart';
import 'package:nusa_app/features/profile/widgets/avatar_display.dart';
import 'package:nusa_app/services/google_auth_service.dart';

@RoutePage()
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  String? selectedAvatar;

  @override
  void initState() {
    super.initState();
    _loadUserFromFirestore();
  }

  Future<void> _loadUserFromFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();
    if (data != null) {
      setState(() {
        nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        selectedAvatar = data['avatar'];
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final newName = nameController.text.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Name cannot be empty'),
            backgroundColor: Colors.green),
      );
      return;
    }

    try {
      final uid = GoogleAuthService.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'name': newName,
          'avatar': selectedAvatar,
        });
      }

      // Sukses, beri notifikasi & kembali ke halaman profile
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Profile updated successfully"),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // return true untuk trigger reload
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.nusa90,
            padding: const EdgeInsets.only(top: 48, bottom: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                AvatarDisplay(
                  selectedAvatar: selectedAvatar,
                  onAvatarSelected: (path) =>
                      setState(() => selectedAvatar = path),
                  showEditIcon: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                NusaTextField(
                  controller: nameController,
                  hintText: "Name",
                  icon: Icons.person,
                  suffixIcon: Icons.edit,
                ),
                const SizedBox(height: 24),
                NusaTextField(
                  controller: emailController,
                  hintText: "Email",
                  icon: Icons.mail,
                  readOnly: true,
                ),
                const SizedBox(height: 32),
                SubmitButton(
                    isLoading: false,
                    onPressed: _handleSave,
                    text: "Save Change")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
