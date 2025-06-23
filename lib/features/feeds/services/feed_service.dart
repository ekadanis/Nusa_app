import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusa_app/core/services/fcm_service.dart';
import 'package:nusa_app/models/forum_model.dart';

class FeedService {
  /// Membuat post baru ke koleksi `feeds` dan mengirim notifikasi ke semua user kecuali pemilik post.
  static Future<void> createFeedPost({
    required ForumModel forumPost,
    required String currentUserId,
  }) async {
    // 1. Tambahkan post ke Firestore
    final docRef = await FirebaseFirestore.instance
        .collection('feeds')
        .add(forumPost.toFirestore());

    // 2. Ambil semua user dari koleksi `users`
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    // 3. Ambil nama user yang membuat post
    final currentUserDoc =
        usersSnapshot.docs.firstWhere((doc) => doc.id == currentUserId);
    final currentUserName = currentUserDoc.data()['name'] ?? 'Someone';

    // 4. Kirim notifikasi ke user lain
    for (final doc in usersSnapshot.docs) {
      if (doc.id == currentUserId) continue; // Jangan kirim ke diri sendiri

      final docData = doc.data();
      final fcmToken = docData['fcmToken'];

      if (fcmToken != null && fcmToken.toString().isNotEmpty) {
        await FCMService.sendNotification(
          deviceToken: fcmToken,
          title: '📝 New Post!',
          body:
              'New Feed from @$currentUserName! on the forum!',
          data: {
            'type': 'new_post',
            'post_id': docRef.id,
          },
        );
      }
    }
  }
}
