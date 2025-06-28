import 'package:flutter/material.dart';
import '../../../models/models.dart';
import 'realtime_user_info.dart';

class ForumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userId;
  final DateTime date;
  final UserModel? postAuthor;

  const ForumAppBar({
    super.key,
    required this.userId,
    required this.date,
    this.postAuthor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: RealTimeUserInfo(
        userId: userId,
        date: date,
      ),
      titleSpacing: 0,
    );
  }
}
