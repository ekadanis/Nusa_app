import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's profile data with real-time updates
  static Stream<UserProfileData> getCurrentUserProfileStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value(_getDefaultProfile());
    }

    // Combine data from both user_stats and users collections
    return _firestore.collection('user_stats').doc(user.uid).snapshots().map((statsDoc) {
      if (statsDoc.exists && statsDoc.data() != null) {
        final statsData = statsDoc.data()!;
        
        // Prefer user_stats data, but fallback to Google photo if no custom photo set
        String? photoUrl = statsData['photoUrl'];
        if (photoUrl == null || photoUrl.isEmpty) {
          photoUrl = user.photoURL; // Fallback to Google photo
        }
        
        return UserProfileData(
          name: statsData['name'] ?? user.displayName ?? 'User',
          email: statsData['email'] ?? user.email ?? '',
          photoUrl: photoUrl,
        );
      } else {
        // Fallback to Google profile data
        return UserProfileData(
          name: user.displayName ?? 'User',
          email: user.email ?? '',
          photoUrl: user.photoURL, // Show Google photo when no custom data exists
        );
      }
    });
  }

  // Get any user's profile data by user ID with real-time updates
  static Stream<UserProfileData?> getUserProfileStreamByUserId(String userId) {
    // First try to get from user_stats (updated profile data)
    return _firestore.collection('user_stats').doc(userId).snapshots().asyncMap((statsDoc) async {
      if (statsDoc.exists && statsDoc.data() != null) {
        final statsData = statsDoc.data()!;
        
        // Get Google photo as fallback if no custom photo set
        String? photoUrl = statsData['photoUrl'];
        String? googlePhotoUrl;
        
        // Try to get Google photo from users collection if needed
        if (photoUrl == null || photoUrl.isEmpty) {
          try {
            final userDoc = await _firestore.collection('users').doc(userId).get();
            if (userDoc.exists && userDoc.data() != null) {
              googlePhotoUrl = userDoc.data()!['photoURL'];
            }
          } catch (e) {
            print('Error fetching Google photo fallback: $e');
          }
        }
        
        return UserProfileData(
          name: statsData['name'] ?? 'User',
          email: statsData['email'] ?? '',
          photoUrl: photoUrl ?? googlePhotoUrl,
        );
      } else {
        // Fallback to users collection
        try {
          final userDoc = await _firestore.collection('users').doc(userId).get();
          if (userDoc.exists && userDoc.data() != null) {
            final userData = userDoc.data()!;
            return UserProfileData(
              name: userData['name'] ?? 'User',
              email: userData['email'] ?? '',
              photoUrl: userData['photoURL'], // Note: users collection uses 'photoURL'
            );
          }
        } catch (e) {
          print('Error fetching user from users collection: $e');
        }
        
        return null;
      }
    });
  }

  // Get user profile data (one-time fetch)
  static Future<UserProfileData?> getUserProfileByUserId(String userId) async {
    try {
      // First try user_stats
      final statsDoc = await _firestore.collection('user_stats').doc(userId).get();
      if (statsDoc.exists && statsDoc.data() != null) {
        final statsData = statsDoc.data()!;
        return UserProfileData(
          name: statsData['name'] ?? 'User',
          email: statsData['email'] ?? '',
          photoUrl: statsData['photoUrl'],
        );
      }

      // Fallback to users collection
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc.data() != null) {
        final userData = userDoc.data()!;
        return UserProfileData(
          name: userData['name'] ?? 'User',
          email: userData['email'] ?? '',
          photoUrl: userData['photoURL'], // Note: users collection uses 'photoURL'
        );
      }

      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Update user profile (updates both collections)
  static Future<void> updateUserProfile({
    required String name,
    String? photoUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final batch = _firestore.batch();

      // Update user_stats collection
      final userStatsRef = _firestore.collection('user_stats').doc(user.uid);
      
      // Check if user_stats document exists, if not create it
      final userStatsDoc = await userStatsRef.get();
      if (!userStatsDoc.exists) {
        // Create initial user_stats document
        batch.set(userStatsRef, {
          'name': name,
          'email': user.email ?? '',
          'photoUrl': photoUrl, // This will be null if no custom avatar selected
          'level': 1,
          'levelTitle': 'Cultural Newbie',
          'currentXP': 0,
          'nextLevelXP': 100,
          'totalXP': 0,
          'quizzesCompleted': 0,
          'articlesRead': 0,
          'dayStreak': 0,
          'accuracy': 0.0,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Update existing document
        batch.update(userStatsRef, {
          'name': name,
          'photoUrl': photoUrl, // This will be null if no custom avatar selected, preserving Google photo fallback
          'email': user.email,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // Update users collection
      final usersRef = _firestore.collection('users').doc(user.uid);
      batch.set(usersRef, {
        'name': name,
        'email': user.email,
        'photoURL': photoUrl, // Note: users collection uses 'photoURL'
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await batch.commit();
      print('✅ User profile updated successfully');
    } catch (e) {
      print('❌ Error updating user profile: $e');
      throw Exception('Failed to update user profile');
    }
  }

  static UserProfileData _getDefaultProfile() {
    final user = _auth.currentUser;
    return UserProfileData(
      name: user?.displayName ?? 'User',
      email: user?.email ?? '',
      photoUrl: user?.photoURL,
    );
  }
}

// Simple model for user profile data
class UserProfileData {
  final String name;
  final String email;
  final String? photoUrl;

  UserProfileData({
    required this.name,
    required this.email,
    this.photoUrl,
  });
}
