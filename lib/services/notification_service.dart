import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a new notification
  static Future<void> addNotification({
    required String userId,
    required String title,
    required String message,
    String? type,
    Map<String, dynamic>? data,
  }) async {
    try {
      final notificationRef = _firestore
          .collection('notifications')
          .doc(userId)
          .collection('items')
          .doc();

      await notificationRef.set({
        'id': notificationRef.id,
        'title': title,
        'message': message,
        'type': type ?? 'general',
        'data': data ?? {},
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update unread count
      await _updateUnreadCount(userId);
    } catch (e) {
      print('Error adding notification: $e');
    }
  }

  // Update unread count
  static Future<void> _updateUnreadCount(String userId) async {
    try {
      final unreadQuery = await _firestore
          .collection('notifications')
          .doc(userId)
          .collection('items')
          .where('isRead', isEqualTo: false)
          .get();

      final unreadCount = unreadQuery.docs.length;

      await _firestore.collection('notifications').doc(userId).set({
        'unreadCount': unreadCount,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating unread count: $e');
    }
  }

  // Mark all notifications as read
  static Future<void> markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      
      final unreadQuery = await _firestore
          .collection('notifications')
          .doc(userId)
          .collection('items')
          .where('isRead', isEqualTo: false)
          .get();

      for (final doc in unreadQuery.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      // Update main document
      batch.update(
        _firestore.collection('notifications').doc(userId),
        {
          'unreadCount': 0,
          'lastReadTime': FieldValue.serverTimestamp(),
        },
      );

      await batch.commit();
    } catch (e) {
      print('Error marking notifications as read: $e');
    }
  }

  // Get notification stream for current user
  static Stream<QuerySnapshot> getNotificationsStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('notifications')
        .doc(currentUser.uid)
        .collection('items')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Example: Send notification when user completes quiz
  static Future<void> sendQuizCompletionNotification({
    required String userId,
    required String quizName,
    required int score,
    required int totalQuestions,
  }) async {
    await addNotification(
      userId: userId,
      title: 'Quiz Completed! 🎉',
      message: 'You scored $score/$totalQuestions on $quizName quiz!',
      type: 'quiz_completion',
      data: {
        'quizName': quizName,
        'score': score,
        'totalQuestions': totalQuestions,
      },
    );
  }

  // Example: Send achievement unlock notification
  static Future<void> sendAchievementNotification({
    required String userId,
    required String achievementTitle,
  }) async {
    await addNotification(
      userId: userId,
      title: 'Achievement Unlocked! 🏆',
      message: 'You\'ve earned: $achievementTitle',
      type: 'achievement',
      data: {
        'achievementTitle': achievementTitle,
      },
    );
  }

  // Example: Send level up notification
  static Future<void> sendLevelUpNotification({
    required String userId,
    required int newLevel,
    required String levelTitle,
  }) async {
    await addNotification(
      userId: userId,
      title: 'Level Up! ⬆️',
      message: 'Congratulations! You\'ve reached Level $newLevel: $levelTitle',
      type: 'level_up',
      data: {
        'newLevel': newLevel,
        'levelTitle': levelTitle,
      },
    );
  }
}
