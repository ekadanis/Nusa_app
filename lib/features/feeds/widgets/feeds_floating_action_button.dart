import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/features/feeds/widgets/create_post_dialog.dart';

class FeedsFloatingActionButton extends StatelessWidget {
  final bool showFAB;

  const FeedsFloatingActionButton({
    super.key,
    required this.showFAB,
  });

  @override
  Widget build(BuildContext context) {
    if (!showFAB) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary50.withOpacity(0.4),
            spreadRadius: 4,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        backgroundColor: AppColors.primary50,
        shape: const CircleBorder(),
        elevation: 0,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const CreatePostDialog();
      },
    );
  }
}
