import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../core/app_colors.dart';

class AvatarPickerDialog extends StatelessWidget {
  final void Function(String selectedAvatarPath) onAvatarSelected;

  const AvatarPickerDialog({
    super.key,
    required this.onAvatarSelected,
  });


  static const List<String> avatarList = [
    'assets/avatar/avatar-1.jpg',
    'assets/avatar/avatar-2.jpg',
    'assets/avatar/avatar-3.jpg',
    'assets/avatar/avatar-4.jpg',
    'assets/avatar/avatar-5.jpg',
    'assets/avatar/avatar-6.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Choose Avatar",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary50,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: avatarList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final path = avatarList[index];
                    return GestureDetector(
                      onTap: () {
                        onAvatarSelected(path);
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage(path),
                        radius: 30,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(IconsaxPlusLinear.close_circle),
              color: AppColors.grey40,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}