import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusa_app/services/fcm_notification_helper.dart';

class CommentService {
  static Future<void> addComment({
    required String forumId,
    required String content,
    required String currentUserId,
  }) async {
    // 1. Tambah komentar
    await FirebaseFirestore.instance.collection('comments').add({
      'forumId': forumId,
      'userId': currentUserId,
      'content': content,
      'date': FieldValue.serverTimestamp(),
    });

    // 2. Tambah counter komentar di forum
    await FirebaseFirestore.instance
        .collection('forums')
        .doc(forumId)
        .update({
      'commentsCount': FieldValue.increment(1),
    });

    // 3. Kirim push ke pemilik forum
    final forumDoc = await FirebaseFirestore.instance
        .collection('forums')
        .doc(forumId)
        .get();

    final forumOwnerId = forumDoc.data()?['userId'];
    final forumContent = forumDoc.data()?['content'] ?? "";

    if (forumOwnerId != null && forumOwnerId != currentUserId) {
      await sendPushToUser(
        receiverUid: forumOwnerId,
        title: "💬 Komentar Baru",
        body: "Someone commented: \"$forumContent\"",
        data: {
          "forumId": forumId,
          "type": "comment",
        },
      );
    }
  }
}
