import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../../../services/firestore_service.dart';
import 'user_avatar_widget.dart';

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
      title: AppBarUserInfo(
        userId: userId,
        date: date,
        postAuthor: postAuthor,
      ),
      titleSpacing: 0,
    );
  }
}

class AppBarUserInfo extends StatelessWidget {
  final String userId;
  final DateTime date;
  final UserModel? postAuthor;

  const AppBarUserInfo({
    super.key,
    required this.userId,
    required this.date,
    this.postAuthor,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: postAuthor != null 
          ? Future.value(postAuthor) 
          : FirestoreService.getUserById(userId),
      builder: (context, snapshot) {
        final user = snapshot.data;        return Row(
          children: [
            UserAvatarWidget(
              user: user, 
              radius: 16,
              userId: userId,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Unknown User',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  _formatDate(date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
