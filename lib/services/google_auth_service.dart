import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class GoogleAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Dapatkan user saat ini
  static User? get currentUser => _auth.currentUser;

  /// Periksa apakah user sudah masuk
  static bool get isSignedIn => _auth.currentUser != null;

  /// Stream perubahan status autentikasi
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Inisialisasi Google Sign-In
  static Future<void> initialize() async {
    try {
      await _googleSignIn.signInSilently();
    } catch (e) {
      // Error handling dapat ditambahkan di sini jika diperlukan
    }
  }

  /// Masuk dengan Google

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Mulai proses autentikasi
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // Pengguna membatalkan sign-in
        return null;
      }

      // Dapatkan detail autentikasi dari request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Buat credential baru
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ); // Masuk ke Firebase dengan credential Google
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Create or update user profile in Firestore with Google data
      if (userCredential.user != null) {
        await createOrUpdateUserProfile(userCredential.user!);
        await saveFcmToken();
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      // Penanganan error yang lebih spesifik
      if (e.toString().contains('channel-error')) {
        throw Exception(
            'Google Sign-In tidak dikonfigurasi dengan benar. Silakan periksa setup Firebase dan SHA-1 fingerprint.');
      } else if (e.toString().contains('network_error')) {
        throw Exception(
            'Error jaringan. Silakan periksa koneksi internet Anda.');
      } else if (e.toString().contains('sign_in_canceled')) {
        throw Exception('Sign in dibatalkan.');
      }

      throw e;
    }
  }

  static Future<void> saveFcmToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (token != null && uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'fcm_token': token,
      });
    }
  }
  // static Future<User?> signInSilently() async {
  //   try {
  //     final googleUser = await _googleSignIn.signInSilently();
  //     if (googleUser == null) return null;

  //     final googleAuth = await googleUser.authentication;
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final userCredential = await _auth.signInWithCredential(credential);

  //     if (userCredential.user != null) {
  //       await createOrUpdateUserProfile(userCredential.user!);
  //     }

  //     return userCredential.user;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  /// Keluar
  static Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw e;
    }
  }

  /// Dapatkan user ID saat ini
  static String? get currentUserId => _auth.currentUser?.uid;

  static Map<String, String?> getUserInfo() {
    final user = _auth.currentUser;
    return {
      'uid': user?.uid,
      'displayName': user?.displayName,
      'email': user?.email,
      'photoURL': user?.photoURL,
    };
  }

  /// Periksa apakah user sudah terotentikasi dan kembalikan user ID
  static String? getAuthenticatedUserId() {
    return _auth.currentUser?.uid;
  }

  /// Create or update user profile in Firestore with Google profile data
  static Future<void> createOrUpdateUserProfile(User user) async {
    try {
      final userModel = UserModel(
        id: user.uid,
        name: user.displayName ?? 'User',
        email: user.email ?? '',
        password: '', // For Google Auth users, password is not stored
        photoURL: user.photoURL, // Save Google profile photo
      );

      // Use set with merge to create or update the user profile
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userModel.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      throw e;
    }
  }

  /// Refresh current user profile with latest Google data
  static Future<void> refreshCurrentUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await createOrUpdateUserProfile(user);
      }
    } catch (e) {
      throw e;
    }
  }
}
