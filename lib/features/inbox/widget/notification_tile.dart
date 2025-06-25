import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/features/feeds/services/feed_service.dart';
import 'package:nusa_app/routes/router.dart';

class NotificationTile extends StatelessWidget {
  final String title;
  final String message;
  final String date;
  final IconData iconData;
  final Color iconColor;
  final String? postId;

  const NotificationTile({
    super.key,
    required this.title,
    required this.message,
    required this.date,
    required this.iconData,
    required this.iconColor,
    this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          onTap: () async {
            print("==========PRINT ON TAP======");
            print('========== ${postId} ==============');
            if (postId != null) {
              final forum = await FeedService.getForumById(postId!);
              print('========== ${forum} ==============');
              if (forum != null && context.mounted) {
                context.router.push(ForumDetailRoute(forumPost: forum));
              }
            }
          }),
    );
  }
}
