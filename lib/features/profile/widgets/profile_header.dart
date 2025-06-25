import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/features/profile/widgets/avatar_display.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? selectedAvatar;
  final void Function(String) onAvatarSelected;
  final bool showEditIcon;
  // final VoidCallback? onEditProfile;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.selectedAvatar,
    required this.onAvatarSelected,
    required this.showEditIcon,
    // this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.nusa90,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AvatarDisplay(
            selectedAvatar: selectedAvatar,
            onAvatarSelected: onAvatarSelected,
            showEditIcon: false,
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
