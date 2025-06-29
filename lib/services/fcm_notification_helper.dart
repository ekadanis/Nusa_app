import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusa_app/core/services/fcm_service.dart';

Future<void> sendPushToUser({
  required String receiverUid,
  required String title,
  required String body,
  Map<String, dynamic>? data,
}) async {
  final userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(receiverUid)
      .get();

  final fcmToken = userDoc.data()?['fcmToken'];
  if (fcmToken != null && fcmToken is String) {
    // Increment unreadCount setiap ada notifikasi baru
    final notifRef =
        FirebaseFirestore.instance.collection('notifications').doc(receiverUid);
    await notifRef.set({
      'unreadCount': FieldValue.increment(1),
      // Tambahkan field lain jika perlu
    }, SetOptions(merge: true));

    await FCMService.sendNotification(
      deviceToken: fcmToken,
      title: title,
      body: body,
      data: data ?? {},
    );
  }
}
