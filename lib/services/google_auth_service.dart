import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  }  /// Masuk dengan Google
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Mulai proses autentikasi
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // Pengguna membatalkan sign-in
        return null;
      }

      // Dapatkan detail autentikasi dari request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Buat credential baru
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Masuk ke Firebase dengan credential Google
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      return userCredential;    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      // Penanganan error yang lebih spesifik
      if (e.toString().contains('channel-error')) {
        throw Exception('Google Sign-In tidak dikonfigurasi dengan benar. Silakan periksa setup Firebase dan SHA-1 fingerprint.');
      } else if (e.toString().contains('network_error')) {
        throw Exception('Error jaringan. Silakan periksa koneksi internet Anda.');
      } else if (e.toString().contains('sign_in_canceled')) {
        throw Exception('Sign in dibatalkan.');
      }
      
      throw e;
    }
  }
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

  /// Dapatkan informasi user untuk ditampilkan di UI
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
}
