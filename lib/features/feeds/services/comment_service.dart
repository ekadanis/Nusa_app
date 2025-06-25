import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/services/fcm_service.dart';
import 'package:nusa_app/models/comment_model.dart';
import 'package:nusa_app/models/forum_model.dart';
import 'package:nusa_app/services/firestore_service.dart';
import 'package:nusa_app/services/google_auth_service.dart';

Future<void> commentService({
  required TextEditingController controller,
  required ForumModel forumPost,
  required BuildContext context,
  required VoidCallback onStart,
  required VoidCallback onComplete,
}) async {
  final text = controller.text.trim();
  final currentUser = GoogleAuthService.currentUser;

  if (text.isEmpty || currentUser == null || forumPost.id == null) return;

  onStart();

  try {
    final comment = CommentModel(
      content: text,
      userId: currentUser.uid,
      forumId: forumPost.id!,
      date: DateTime.now(),
    );

    await FirestoreService.addComment(comment);
    controller.clear();

    if (forumPost.userId != currentUser.uid) {
      final postOwner = await FirestoreService.getUserById(forumPost.userId);
      final fcmToken = postOwner?.fcmToken;

      if (postOwner != null && fcmToken != null && fcmToken.isNotEmpty) {
        print('ID Notifikasi: ${postOwner.id}');
        final title = "💬 New Comment";
        final message =
            "${currentUser.displayName ?? 'Someone'} commented on your feed";

        // Push Notification
        await FCMService.sendNotification(
          deviceToken: fcmToken,
          title: title,
          body: message,
          data: {
            "forum_id": forumPost.id!,
            "type": "comment",
          },
        );
        print("ceeeek");
        // Inbox Notification (Firestore)
        final notifcomment = await FirebaseFirestore.instance
            .collection('inbox_notification')
            .doc(postOwner.id)
            .collection('items')
            .add({
          'title': title,
          'message': message,
          'postId': forumPost.id!,
          'type': 'comment',
          'updateAt': FieldValue.serverTimestamp(),
        });

        print('ID Notifikasi: ${notifcomment.id}');
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment added successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add comment: $e')),
      );
    }
  } finally {
    onComplete();
  }
}
