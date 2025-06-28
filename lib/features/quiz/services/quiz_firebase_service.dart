import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/quiz_models.dart';
import '../../../services/tracking_service.dart';
import '../../profile/services/achievement_service.dart';

class QuizFirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  // Simpan result quiz ke Firebase
  static Future<void> saveQuizResult(QuizResult result, String categoryId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('❌ User not logged in, cannot save quiz result');
        return;
      }      print('💾 Saving quiz result to Firebase...');
      print('📊 User: ${user.email}');
      print('📂 Category: $categoryId');
      print('🎯 Score: ${result.correctAnswers}/${result.totalQuestions}');
      print('💰 XP Earned: ${result.xpEarned}');
      print('📈 Accuracy: ${result.accuracy.toStringAsFixed(1)}%');

      final quizData = {
        'userId': user.uid,
        'userEmail': user.email,
        'categoryId': categoryId,
        'totalQuestions': result.totalQuestions,
        'correctAnswers': result.correctAnswers,
        'wrongAnswers': result.wrongAnswers,
        'xpEarned': result.xpEarned,
        'accuracy': result.accuracy,
        'timeTaken': result.timeTaken.inSeconds,
        'completedAt': FieldValue.serverTimestamp(),
        'level': await getCurrentUserLevel(),
      };      // Simpan ke collection quiz_history (bukan quiz_results)
      final docRef = await _firestore.collection('quiz_history').add(quizData);
      print('✅ Quiz result saved with ID: ${docRef.id}');      // Update user stats
      await _updateUserStats(result);
      print('✅ User stats updated successfully');      // Track category played
      await trackCategoryPlayed(categoryId);
      
      // Check and unlock achievements using tracking data
      try {
        await AchievementService.checkAchievementsFromTracking();
        print('🏆 Achievement check completed');
      } catch (achievementError) {
        print('⚠️ Achievement check failed but continuing: $achievementError');
      }
      
      // Debug: Verify data was saved
      print('🔍 Verifying saved data...');
      final savedDoc = await docRef.get();
      if (savedDoc.exists) {
        print('✅ Data verification successful');
        final savedData = savedDoc.data()!;
        print('📊 Saved: ${savedData['categoryId']} - ${savedData['accuracy']}%');
      } else {
        print('❌ Data verification failed - document not found');
      }
    } catch (e) {
      print('❌ Error saving quiz result: $e');
      throw Exception('Failed to save quiz result');
    }
  }

  // Update user stats setelah quiz
  static Future<void> _updateUserStats(QuizResult result) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final userStatsRef = _firestore.collection('user_stats').doc(user.uid);
      
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(userStatsRef);
        
        if (doc.exists) {
          // Update existing stats
          final currentData = doc.data()!;
          final currentXP = currentData['totalXP'] ?? 0;
          final currentQuizzes = currentData['quizzesCompleted'] ?? 0;
          final currentCorrectAnswers = currentData['totalCorrectAnswers'] ?? 0;
          final currentTotalQuestions = currentData['totalQuestions'] ?? 0;
            final newTotalXP = currentXP + result.xpEarned;
          final newQuizzesCompleted = currentQuizzes + 1;
          final newCorrectAnswers = currentCorrectAnswers + result.correctAnswers;
          final newTotalQuestions = currentTotalQuestions + result.totalQuestions;
          final newAccuracy = (newCorrectAnswers / newTotalQuestions) * 100;
          final newLevel = calculateLevel(newTotalXP);          // Check day streak logic dengan debugging
          final currentDayStreak = currentData['dayStreak'] ?? 0;
          final lastPlayed = currentData['lastPlayedAt'] as Timestamp?;
          
          print('🔍 Day Streak Debug:');
          print('📅 Current day streak: $currentDayStreak');
          print('⏰ Last played: ${lastPlayed?.toDate()}');
          
          // Calculate new day streak
          int newDayStreak = currentDayStreak;
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          
          print('📅 Today: $today');
          
          if (lastPlayed != null) {
            final lastPlayedDate = lastPlayed.toDate();
            final lastPlayDay = DateTime(lastPlayedDate.year, lastPlayedDate.month, lastPlayedDate.day);
            
            print('📅 Last play day: $lastPlayDay');
            
            // Calculate difference in days
            final difference = today.difference(lastPlayDay).inDays;
            print('📊 Days difference: $difference');
            
            // If played yesterday, increment streak
            if (difference == 1) {
              newDayStreak = currentDayStreak + 1;
              print('✅ Played yesterday! Streak incremented: $currentDayStreak -> $newDayStreak');
            } 
            // If played today already (same day)
            else if (difference == 0) {
              // Keep current streak - already played today
              newDayStreak = currentDayStreak;
              print('📅 Already played today. Keeping streak: $newDayStreak');
            } 
            // If missed a day or more, reset streak to 1
            else if (difference > 1) {
              newDayStreak = 1;
              print('💔 Missed days ($difference). Resetting streak to 1');
            }
            // If somehow difference is negative (playing in past), set to 1
            else {
              newDayStreak = 1;
              print('⚠️ Negative difference. Setting streak to 1');
            }
          } else {
            // First time playing
            newDayStreak = 1;
            print('🎉 First time playing! Setting streak to 1');
          }
          
          print('🎯 Final day streak: $newDayStreak');
          
          transaction.update(userStatsRef, {
            'totalXP': newTotalXP,
            'currentXP': _getCurrentLevelXP(newTotalXP),
            'nextLevelXP': _getNextLevelXP(newLevel),
            'level': newLevel,
            'levelTitle': _getLevelTitle(newLevel),
            'quizzesCompleted': newQuizzesCompleted,
            'totalCorrectAnswers': newCorrectAnswers,
            'totalQuestions': newTotalQuestions,
            'accuracy': newAccuracy,
            'lastPlayedAt': FieldValue.serverTimestamp(),
            'dayStreak': newDayStreak,
          });
        } else {
          
          transaction.set(userStatsRef, {
            'userId': user.uid,
            'name': user.displayName ?? 'User',
            'email': user.email,
            'photoUrl': user.photoURL,
            'totalXP': result.xpEarned,
            'currentXP': result.xpEarned,
            'nextLevelXP': 100, // Level 1 membutuhkan 100 XP
            'level': 1,
            'levelTitle': _getLevelTitle(1),
            'quizzesCompleted': 1,
            'totalCorrectAnswers': result.correctAnswers,
            'totalQuestions': result.totalQuestions,
            'accuracy': result.accuracy,
            'articlesRead': 0,
            'dayStreak': 1,
            'createdAt': FieldValue.serverTimestamp(),
            'lastPlayedAt': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      print('Error updating user stats: $e');
    }
  }

    static Future<UserStats> getUserStats() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return _getDefaultUserStats();
      }

      final doc = await _firestore.collection('user_stats').doc(user.uid).get();
      
      if (doc.exists) {
        final data = doc.data()!;
        return UserStats(
          name: data['name'] ?? user.displayName ?? 'User',
          email: data['email'] ?? user.email ?? '',
          photoUrl: data['photoUrl'] ?? user.photoURL,
          level: data['level'] ?? 1,
          levelTitle: data['levelTitle'] ?? _getLevelTitle(1),
          currentXP: data['currentXP'] ?? 0,
          nextLevelXP: data['nextLevelXP'] ?? 100,
          totalXP: data['totalXP'] ?? 0,
          quizzesCompleted: data['quizzesCompleted'] ?? 0,
          articlesRead: data['articlesRead'] ?? 0,
          dayStreak: data['dayStreak'] ?? 0,
          accuracy: (data['accuracy'] ?? 0.0).toDouble(),
        );
      } else {
        return _getDefaultUserStats();
      }
    } catch (e) {
      print('Error getting user stats: $e');
      return _getDefaultUserStats();
    }
  }
  
  // Method baru untuk mendapatkan stream real-time dari user stats
  static Stream<UserStats> getUserStatsStream() {
    final user = _auth.currentUser;
    if (user == null) {
      // Jika tidak ada user, return stream dengan default stats
      return Stream.value(_getDefaultUserStats());
    }
    
    return _firestore.collection('user_stats').doc(user.uid).snapshots().map((doc) {
      if (!doc.exists) {
        return _getDefaultUserStats();
      }
      
      final data = doc.data()!;
      return UserStats(
        name: data['name'] ?? user.displayName ?? 'User',
        email: data['email'] ?? user.email ?? '',
        photoUrl: data['photoUrl'] ?? user.photoURL,
        level: data['level'] ?? 1,
        levelTitle: data['levelTitle'] ?? _getLevelTitle(1),
        currentXP: data['currentXP'] ?? 0,
        nextLevelXP: data['nextLevelXP'] ?? 100,
        totalXP: data['totalXP'] ?? 0,
        quizzesCompleted: data['quizzesCompleted'] ?? 0,
        articlesRead: data['articlesRead'] ?? 0,
        dayStreak: data['dayStreak'] ?? 0,
        accuracy: (data['accuracy'] ?? 0.0).toDouble(),
      );
    });
  }

  // Get current user level
  static Future<int> getCurrentUserLevel() async {
    final stats = await getUserStats();
    return stats.level;
  }  // Get quiz history - tanpa compound index
  static Future<List<Map<String, dynamic>>> getQuizHistory() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('❌ User not logged in, cannot get quiz history');
        return [];
      }

      print('📊 Getting quiz history for user: ${user.email}');      // Query tanpa orderBy untuk menghindari composite index
      final querySnapshot = await _firestore
          .collection('quiz_history')
          .where('userId', isEqualTo: user.uid)
          .limit(10)
          .get();

      print('📋 Found ${querySnapshot.docs.length} quiz results');

      // Sort di client side
      final docs = querySnapshot.docs;
      docs.sort((a, b) {
        final aTime = a.data()['completedAt'];
        final bTime = b.data()['completedAt'];
        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime); // Descending order
      });

      final results = docs.map((doc) {
        final data = doc.data();
        print('📄 Quiz result: ${data['categoryId']} - ${data['accuracy']}% - ${data['xpEarned']} XP');
        return {
          'id': doc.id,
          'categoryId': data['categoryId'],
          'accuracy': data['accuracy'],
          'xpEarned': data['xpEarned'],
          'completedAt': data['completedAt'],
          'level': data['level'],
        };
      }).toList();

      print('✅ Quiz history retrieved successfully');
      return results;
    } catch (e) {
      print('❌ Error getting quiz history: $e');
      return [];
    }
  }

  // Get quiz history sebagai real-time stream
  static Stream<List<Map<String, dynamic>>> getQuizHistoryStream() {
    final user = _auth.currentUser;
    if (user == null) {
      print('❌ User not logged in, cannot get quiz history stream');
      return Stream.value([]);
    }

    print('📊 Creating quiz history stream for user: ${user.email}');    return _firestore
        .collection('quiz_history')
        .where('userId', isEqualTo: user.uid)
        .limit(10)
        .snapshots()
        .map((querySnapshot) {
          // Sort di client side
          final docs = querySnapshot.docs;
          docs.sort((a, b) {
            final aTime = a.data()['completedAt'];
            final bTime = b.data()['completedAt'];
            if (aTime == null || bTime == null) return 0;
            return bTime.compareTo(aTime); // Descending order
          });

          final results = docs.map((doc) {
            final data = doc.data();
            print('📄 Quiz result (stream): ${data['categoryId']} - ${data['accuracy']}% - ${data['xpEarned']} XP');
            return {
              'id': doc.id,
              'categoryId': data['categoryId'],
              'accuracy': data['accuracy'],
              'xpEarned': data['xpEarned'],
              'completedAt': data['completedAt'],
              'level': data['level'],
            };
          }).toList();

          print('✅ Quiz history stream updated');
          return results;
        });
  }

  // Simpan questions yang di-generate AI ke Firebase untuk cache
  static Future<void> saveGeneratedQuestions(
    List<Question> questions,
    String categoryId,
    int level,
  ) async {
    try {
      final questionsData = {
        'categoryId': categoryId,
        'level': level,
        'questions': questions.map((q) => {
          'id': q.id,
          'question': q.question,
          'options': q.options,
          'correctAnswerIndex': q.correctAnswerIndex,
        }).toList(),
        'generatedAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(hours: 24)), // Expire after 24 hours
        ),
      };

      await _firestore
          .collection('generated_questions')
          .doc('${categoryId}_level_$level')
          .set(questionsData);
    } catch (e) {
      print('Error saving generated questions: $e');
    }
  }

  // Get cached questions dari Firebase
  static Future<List<Question>?> getCachedQuestions(String categoryId, int level) async {
    try {
      final doc = await _firestore
          .collection('generated_questions')
          .doc('${categoryId}_level_$level')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        final expiresAt = data['expiresAt'] as Timestamp;
        
        // Check if not expired
        if (expiresAt.toDate().isAfter(DateTime.now())) {
          final questionsData = data['questions'] as List<dynamic>;
          return questionsData.map((q) => Question(
            id: q['id'],
            question: q['question'],
            options: List<String>.from(q['options']),
            correctAnswerIndex: q['correctAnswerIndex'],
            categoryId: categoryId,
          )).toList();
        }
      }
      return null;
    } catch (e) {
      print('Error getting cached questions: $e');
      return null;
    }
  }
  // Helper methods untuk level calculation
  static int calculateLevel(int totalXP) {
    if (totalXP < 100) return 1;
    if (totalXP < 250) return 2;
    if (totalXP < 500) return 3;
    if (totalXP < 800) return 4;
    if (totalXP < 1200) return 5;
    if (totalXP < 1700) return 6;
    if (totalXP < 2300) return 7;
    if (totalXP < 3000) return 8;
    if (totalXP < 4000) return 9;
    return 10; // Max level
  }
  static int _getCurrentLevelXP(int totalXP) {
    final level = calculateLevel(totalXP);
    final levelThresholds = [0, 100, 250, 500, 800, 1200, 1700, 2300, 3000, 4000];
    if (level >= levelThresholds.length) return totalXP - levelThresholds.last;
    return totalXP - levelThresholds[level - 1];
  }

  static int _getNextLevelXP(int level) {
    final levelThresholds = [100, 250, 500, 800, 1200, 1700, 2300, 3000, 4000, 5000];
    if (level >= levelThresholds.length) return levelThresholds.last;
    return levelThresholds[level - 1];
  }

  static String _getLevelTitle(int level) {
    switch (level) {
      case 1: return 'Cultural Newbie';
      case 2: return 'Local Wanderer';
      case 3: return 'Tradition Seeker';
      case 4: return 'Cultural Explorer';
      case 5: return 'Folklore Hunter';
      case 6: return 'Heritage Guardian';
      case 7: return 'Tradition Master';
      case 8: return 'Culture Sage';
      case 9: return 'Nusantara Legend';
      case 10: return 'King of Explorer Indonesia 👑';
      default: return 'Cultural Newbie';
    }
  }

  static UserStats _getDefaultUserStats() {
    final user = _auth.currentUser;
    return UserStats(
      name: user?.displayName ?? 'Guest User',
      email: user?.email ?? '',
      photoUrl: user?.photoURL,
      level: 1,
      levelTitle: 'Cultural Newbie',
      currentXP: 0,
      nextLevelXP: 100,
      totalXP: 0,
      quizzesCompleted: 0,
      articlesRead: 0,
      dayStreak: 0,
      accuracy: 0.0,
    );
  }

  // Helper function untuk debugging - bisa dipanggil dari UI
  static Future<void> debugUserStats() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('❌ No user logged in');
        return;
      }

      print('\n🔍 === USER STATS DEBUG ===');
      print('👤 User: ${user.email}');
      
      // Get user stats
      final doc = await _firestore.collection('user_stats').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        print('📊 Current Stats:');
        print('   Level: ${data['level']}');
        print('   Total XP: ${data['totalXP']}');
        print('   Day Streak: ${data['dayStreak']}');
        print('   Quizzes Completed: ${data['quizzesCompleted']}');
        print('   Last Played: ${data['lastPlayedAt']?.toDate()}');
      } else {
        print('❌ No user stats found');
      }
      
      // Get quiz history count
      final historyQuery = await _firestore
          .collection('quiz_history')
          .where('userId', isEqualTo: user.uid)
          .get();
      
      print('📋 Quiz History Count: ${historyQuery.docs.length}');
      
      if (historyQuery.docs.isNotEmpty) {
        print('📄 Recent Quiz Results:');
        for (var doc in historyQuery.docs.take(3)) {
          final data = doc.data();
          print('   - ${data['categoryId']}: ${data['accuracy']}% (${data['xpEarned']} XP)');
        }
      }
      
      print('=========================\n');
    } catch (e) {
      print('❌ Debug error: $e');
    }
  }

  // Helper function untuk reset day streak (untuk testing)
  static Future<void> resetDayStreak() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('user_stats').doc(user.uid).update({
        'dayStreak': 0,
        'lastPlayedAt': null,
      });
      
      print('✅ Day streak reset to 0');
    } catch (e) {
      print('❌ Error resetting day streak: $e');
    }
  }

  // Helper function untuk simulate yesterday play (untuk testing)
  static Future<void> simulateYesterdayPlay() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      
      await _firestore.collection('user_stats').doc(user.uid).update({
        'lastPlayedAt': Timestamp.fromDate(yesterday),
        'dayStreak': 1,
      });
      
      print('✅ Simulated yesterday play');
    } catch (e) {
      print('❌ Error simulating yesterday play: $e');
    }
  }
  // Track categories played by user (for quiz completion)
  static Future<void> trackCategoryPlayed(String categoryId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final userStatsRef = _firestore.collection('user_stats').doc(user.uid);
      
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(userStatsRef);
        
        if (doc.exists) {
          final currentData = doc.data()!;
          final categoriesPlayed = List<String>.from(currentData['categoriesPlayed'] ?? []);
          
          if (!categoriesPlayed.contains(categoryId)) {
            categoriesPlayed.add(categoryId);
            transaction.update(userStatsRef, {
              'categoriesPlayed': categoriesPlayed,
            });
            print('🎯 Quiz category $categoryId completed. Total quiz categories: ${categoriesPlayed.length}');
          }
        }
      });
      
      // Also track as explored category for achievements
      await TrackingService.trackCategoryExplored(categoryId);
    } catch (e) {
      print('Error tracking category: $e');
    }
  }

  // Get categories played by user
  static Future<Set<String>> getCategoriesPlayed() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return <String>{};

      final doc = await _firestore.collection('user_stats').doc(user.uid).get();
      
      if (doc.exists) {
        final data = doc.data()!;
        final categoriesPlayed = List<String>.from(data['categoriesPlayed'] ?? []);
        return Set<String>.from(categoriesPlayed);
      }
      
      return <String>{};
    } catch (e) {
      print('Error getting categories played: $e');
      return <String>{};
    }
  }

  // Method to get any user's stats by user ID
  static Future<UserStats?> getUserStatsByUserId(String userId) async {
    try {
      // First try to get from user_stats collection
      final statsDoc = await _firestore.collection('user_stats').doc(userId).get();
      
      if (statsDoc.exists) {
        final data = statsDoc.data()!;
        return UserStats(
          name: data['name'] ?? 'User',
          email: data['email'] ?? '',
          photoUrl: data['photoUrl'],
          level: data['level'] ?? 1,
          levelTitle: data['levelTitle'] ?? _getLevelTitle(1),
          currentXP: data['currentXP'] ?? 0,
          nextLevelXP: data['nextLevelXP'] ?? 100,
          totalXP: data['totalXP'] ?? 0,
          quizzesCompleted: data['quizzesCompleted'] ?? 0,
          articlesRead: data['articlesRead'] ?? 0,
          dayStreak: data['dayStreak'] ?? 0,
          accuracy: (data['accuracy'] ?? 0.0).toDouble(),
        );
      } else {
        // Fallback to users collection if user_stats doesn't exist
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          return UserStats(
            name: userData['name'] ?? 'User',
            email: userData['email'] ?? '',
            photoUrl: userData['photoURL'], // Note: different field name in users collection
            level: 1,
            levelTitle: _getLevelTitle(1),
            currentXP: 0,
            nextLevelXP: 100,
            totalXP: 0,
            quizzesCompleted: 0,
            articlesRead: 0,
            dayStreak: 0,
            accuracy: 0.0,
          );
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting user stats by user ID: $e');
      return null;
    }
  }
  
  // Method to get stream of any user's stats by user ID
  static Stream<UserStats?> getUserStatsStreamByUserId(String userId) {
    // First try user_stats collection
    return _firestore.collection('user_stats').doc(userId).snapshots().asyncMap((statsDoc) async {
      if (statsDoc.exists) {
        final data = statsDoc.data()!;
        return UserStats(
          name: data['name'] ?? 'User',
          email: data['email'] ?? '',
          photoUrl: data['photoUrl'],
          level: data['level'] ?? 1,
          levelTitle: data['levelTitle'] ?? _getLevelTitle(1),
          currentXP: data['currentXP'] ?? 0,
          nextLevelXP: data['nextLevelXP'] ?? 100,
          totalXP: data['totalXP'] ?? 0,
          quizzesCompleted: data['quizzesCompleted'] ?? 0,
          articlesRead: data['articlesRead'] ?? 0,
          dayStreak: data['dayStreak'] ?? 0,
          accuracy: (data['accuracy'] ?? 0.0).toDouble(),
        );
      } else {
        // Fallback to users collection
        try {
          final userDoc = await _firestore.collection('users').doc(userId).get();
          if (userDoc.exists) {
            final userData = userDoc.data()!;
            return UserStats(
              name: userData['name'] ?? 'User',
              email: userData['email'] ?? '',
              photoUrl: userData['photoURL'], // Note: different field name in users collection
              level: 1,
              levelTitle: _getLevelTitle(1),
              currentXP: 0,
              nextLevelXP: 100,
              totalXP: 0,
              quizzesCompleted: 0,
              articlesRead: 0,
              dayStreak: 0,
              accuracy: 0.0,
            );
          }
        } catch (e) {
          print('Error getting user from users collection: $e');
        }
        
        return null;
      }
    });
  }
}
