import 'package:flutter/material.dart';

class AvatarPickerDialog extends StatelessWidget {
  final void Function(String selectedAvatarPath) onAvatarSelected;

  const AvatarPickerDialog({
    super.key,
    required this.onAvatarSelected,
  });


  static const List<String> avatarList = [
    'assets/avatar/avatar-1.png',
    'assets/avatar/avatar-2.png',
    'assets/avatar/avatar-3.png',
    'assets/avatar/avatar-4.png',
    'assets/avatar/avatar-5.png',
    'assets/avatar/avatar-6.png',
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
                const Text(
                  "Choose Avatar",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
