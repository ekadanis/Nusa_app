import 'package:flutter/material.dart';
import 'package:nusa_app/features/profile/widgets/avatar_picker_dialog.dart';

class AvatarDisplay extends StatelessWidget {
  final String? selectedAvatar;
  final void Function(String) onAvatarSelected;

  const AvatarDisplay({
    super.key,
    required this.selectedAvatar,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            backgroundImage: AssetImage(selectedAvatar ?? 'assets/avatar/avatar-1.png'),
          ),
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
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
