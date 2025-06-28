import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/features/profile/widgets/avatar_picker_dialog.dart';
import '../../../core/app_colors.dart';
import '../../../services/google_auth_service.dart';

class AvatarDisplay extends StatelessWidget {
  final String? selectedAvatar;
  final void Function(String) onAvatarSelected;
  final bool showEditIcon;

  const AvatarDisplay({
    super.key,
    required this.selectedAvatar,
    required this.onAvatarSelected,
    this.showEditIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    // Get Google photo as fallback
    final googlePhotoUrl = GoogleAuthService.currentUser?.photoURL;
    
    // Determine what image to show
    ImageProvider? imageProvider;
    if (selectedAvatar != null && selectedAvatar!.isNotEmpty) {
      if (selectedAvatar!.startsWith('assets/')) {
        imageProvider = AssetImage(selectedAvatar!);
      } else {
        imageProvider = NetworkImage(selectedAvatar!);
      }
    } else if (googlePhotoUrl != null && googlePhotoUrl.isNotEmpty) {
      imageProvider = NetworkImage(googlePhotoUrl);
    } else {
      imageProvider = const AssetImage('assets/avatar/avatar-1.jpg');
    }
    
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            backgroundImage: imageProvider,
          ),
          if (showEditIcon)
            Positioned(
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AvatarPickerDialog(
                      onAvatarSelected: onAvatarSelected,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary50,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    IconsaxPlusLinear.edit,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}