import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan ini
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nusa_app/features/inbox/services/inbox_notification_services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _saveFcmToken(_auth.currentUser!.uid);
      await  InboxNotificationServices.upsertWelcomeMessage();

      return null;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException code: ${e.code}");
      return e.message;
    }
  }

  // Register
  Future<String?> register(
      String email, String password, String? name, String avatarPath) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;

      // Update display name
      if (name != null && name.isNotEmpty) {
        await userCredential.user?.updateDisplayName(name);
        await userCredential.user?.reload();
      }

      // save data user in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'avatar': avatarPath,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _saveFcmToken(uid!);
      await InboxNotificationServices.upsertWelcomeMessage();

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An error occurred during registration.';
    }
  }

  //Forgot Password
  Future<String?> forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null; // sukses
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

Future<void> _saveFcmToken(String uid) async {
  final fcm = FirebaseMessaging.instance;
  final token = await fcm.getToken();

  if (token != null) {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'fcmToken': token,
    });
  }
}

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Cek user login
  User? get currentUser => _auth.currentUser;
}
