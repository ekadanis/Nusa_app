import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nusa_app/features/feeds/services/feed_service.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:nusa_app/util/extensions.dart';

import '../../../core/app_colors.dart';

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
            width: 40,
            height: 40,
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
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            )
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.grey50,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: Text(
            _formatDate(date),
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

String _formatDate(String date) {
  try {
    final inputFormat = DateFormat('dd-MM-yyyy');
    final outputFormat = DateFormat('d MMMM yyyy');
    final parsedDate = inputFormat.parse(date);
    return outputFormat.format(parsedDate);
  } catch (e) {
    return date; // fallback jika format tidak valid
  }
}
