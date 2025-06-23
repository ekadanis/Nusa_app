import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusa_app/services/fcm_notification_helper.dart';

class LikeService {
  static Future<void> toggleLike({
    required String forumId,
    required String forumOwnerId,
    required String forumContent,
    required String currentUserId,
  }) async {
    final forumRef = FirebaseFirestore.instance.collection('forums').doc(forumId);

    final forumDoc = await forumRef.get();
    if (!forumDoc.exists) {
      print('[❌] Forum tidak ditemukan untuk update like!');
      return;
    }

    final likeRef = forumRef.collection('likes').doc(currentUserId);
    final likeDoc = await likeRef.get();
    final isLiked = likeDoc.exists;

    if (isLiked) {
      // Unlike
      await likeRef.delete();
      await forumRef.update({
        'like': FieldValue.increment(-1),
      });
    } else {
      // Like
      await likeRef.set({'likedAt': FieldValue.serverTimestamp()});
      await forumRef.update({
        'like': FieldValue.increment(1),
      });

      // Kirim notifikasi jika yang like bukan pemilik post
      if (forumOwnerId != currentUserId) {
        await sendPushToUser(
          receiverUid: forumOwnerId,
          title: "❤️ Your post got a like!",
          body: "Someone liked:: \"$forumContent\"",
          data: {
            "forumId": forumId,
            "type": "like",
          },
        );
      }
    }
  }

  static Future<bool> hasUserLiked({
    required String forumId,
    required String userId,
  }) async {
    final likeDoc = await FirebaseFirestore.instance
        .collection('forums')
        .doc(forumId)
        .collection('likes')
        .doc(userId)
        .get();

    return likeDoc.exists;
  }
}
