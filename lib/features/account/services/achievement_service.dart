import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/achievement_model.dart';
import '../../../services/tracking_service.dart';

class AchievementService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all available achievements with their unlock status from Firebase
  static Stream<List<Achievement>> getAchievementsStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value(_getDefaultAchievements());
    }

    return _firestore
        .collection('user_achievements')
        .doc(user.uid)        .snapshots()
        .map((doc) {
      final unlockedAchievements = doc.exists 
          ? List<String>.from(doc.data()?['unlockedAchievements'] ?? [])
          : <String>[];

      return _getAllAchievements().map((achievement) {
        return Achievement(
          id: achievement.id,
          title: achievement.title,
          description: achievement.description,
          icon: achievement.icon,
          isUnlocked: unlockedAchievements.contains(achievement.id),
        );
      }).toList();
    });
  }

  // Get achievements as Future (for non-stream usage)
  static Future<List<Achievement>> getAchievements() async {
    final user = _auth.currentUser;
    if (user == null) {
      return _getDefaultAchievements();
    }

    try {
      final doc = await _firestore
          .collection('user_achievements')
          .doc(user.uid)
          .get();

      final unlockedAchievements = doc.exists
          ? List<String>.from(doc.data()?['unlockedAchievements'] ?? [])
          : <String>[];      return _getAllAchievements().map((achievement) {
        return Achievement(
          id: achievement.id,
          title: achievement.title,
          description: achievement.description,
          icon: achievement.icon,
          isUnlocked: unlockedAchievements.contains(achievement.id),
        );
      }).toList();
    } catch (e) {
      print('Error getting achievements: $e');
      return _getDefaultAchievements();
    }
  }

  // Unlock an achievement
  static Future<void> unlockAchievement(String achievementId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final docRef = _firestore.collection('user_achievements').doc(user.uid);
      
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        
        List<String> unlockedAchievements = [];
        if (doc.exists) {
          unlockedAchievements = List<String>.from(
            doc.data()?['unlockedAchievements'] ?? []
          );
        }

        if (!unlockedAchievements.contains(achievementId)) {
          unlockedAchievements.add(achievementId);
          
          transaction.set(docRef, {
            'userId': user.uid,
            'unlockedAchievements': unlockedAchievements,
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          print('🏆 Achievement unlocked: $achievementId');
        }
      });
    } catch (e) {
      print('Error unlocking achievement: $e');
    }
  }
  // Check and unlock achievements based on user stats
  static Future<void> checkAndUnlockAchievements({
    required int quizzesCompleted,
    required int articlesRead,
    required int categoriesExplored,
    required int dayStreak,
  }) async {
    try {
      // 1. Knowledge Seeker: Read 10 articles
      if (articlesRead >= 10) {
        await unlockAchievement('knowledge_seeker');
      }

      // 2. Quiz Beginner: Complete 10 quizzes
      if (quizzesCompleted >= 10) {
        await unlockAchievement('quiz_beginner');
      }

      // 3. Quiz Master: Complete 20 quizzes
      if (quizzesCompleted >= 20) {
        await unlockAchievement('quiz_master');
      }

      // 4. Culture Explorer: Explore all 6 categories
      if (categoriesExplored >= 6) {
        await unlockAchievement('culture_explorer');
      }

      // 5. Fire Streak: Maintain 7 day streak
      if (dayStreak >= 7) {
        await unlockAchievement('fire_streak');
      }

    } catch (e) {
      print('Error checking achievements: $e');
    }
  }
  // Check achievements using tracking data
  static Future<void> checkAchievementsFromTracking() async {
    try {
      final trackingStats = await TrackingService.getUserTrackingStats();
      
      await checkAndUnlockAchievements(
        quizzesCompleted: trackingStats['quizzesCompleted'] ?? 0,
        articlesRead: trackingStats['articlesRead'] ?? 0,
        categoriesExplored: trackingStats['categoriesExplored'] ?? 0,
        dayStreak: trackingStats['dayStreak'] ?? 0,
      );
      
      print('🏆 Achievement check completed from tracking data');
    } catch (e) {
      print('Error checking achievements from tracking: $e');
    }
  }

  // Get all possible achievements (master list)
  static List<Achievement> _getAllAchievements() {
    return [      Achievement(
        id: 'knowledge_seeker',
        title: 'Knowledge Seeker',
        description: 'Read 10 articles',
        icon: '📚',
        isUnlocked: false,
      ),
      Achievement(
        id: 'quiz_beginner',
        title: 'Quiz Beginner',
        description: 'Complete 10 quizzes',
        icon: '🎯',
        isUnlocked: false,
      ),      Achievement(
        id: 'quiz_master',
        title: 'Quiz Master',
        description: 'Complete 20 quizzes',
        icon: '🏆',
        isUnlocked: false,
      ),
      Achievement(
        id: 'culture_explorer',
        title: 'Culture Explorer',
        description: 'Explore all 6 categories',
        icon: '🗺️',
        isUnlocked: false,
      ),
      Achievement(
        id: 'fire_streak',
        title: 'Fire Streak',
        description: 'Maintain 7-day streak',
        icon: '🔥',
        isUnlocked: false,
      ),
    ];
  }
  // Default achievements for fallback
  static List<Achievement> _getDefaultAchievements() {
    return _getAllAchievements().map((achievement) {
      return Achievement(
        id: achievement.id,
        title: achievement.title,
        description: achievement.description,
        icon: achievement.icon,
        isUnlocked: false,
      );
    }).toList();
  }
}
