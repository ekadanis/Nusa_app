import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrackingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Track when user reads an article
  static Future<void> trackArticleRead(String articleId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final userStatsRef = _firestore.collection('user_stats').doc(user.uid);
      
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(userStatsRef);
        
        if (doc.exists) {
          final currentData = doc.data()!;
          final articlesRead = List<String>.from(currentData['readArticles'] ?? []);
          final currentCount = currentData['articlesRead'] ?? 0;
          
          if (!articlesRead.contains(articleId)) {
            articlesRead.add(articleId);
            transaction.update(userStatsRef, {
              'readArticles': articlesRead,
              'articlesRead': currentCount + 1,
              'lastArticleReadAt': FieldValue.serverTimestamp(),
            });
            print('📚 Article $articleId tracked. Total articles read: ${currentCount + 1}');
          }
        } else {
          // Create initial user stats if doesn't exist
          transaction.set(userStatsRef, {
            'userId': user.uid,
            'name': user.displayName ?? 'User',
            'email': user.email,
            'photoUrl': user.photoURL,
            'readArticles': [articleId],
            'articlesRead': 1,
            'exploredCategories': [],
            'categoriesExplored': 0,
            'quizzesCompleted': 0,
            'dayStreak': 0,
            'totalXP': 0,
            'level': 1,
            'createdAt': FieldValue.serverTimestamp(),
            'lastArticleReadAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          print('📚 First article tracked: $articleId');
        }
      });
    } catch (e) {
      print('Error tracking article: $e');
    }
  }

  // Track when user explores a category (clicks on category widget di beranda)
  static Future<void> trackCategoryExplored(String categoryId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final userStatsRef = _firestore.collection('user_stats').doc(user.uid);
      
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(userStatsRef);
        
        if (doc.exists) {
          final currentData = doc.data()!;
          final exploredCategories = List<String>.from(currentData['exploredCategories'] ?? []);
          
          if (!exploredCategories.contains(categoryId)) {
            exploredCategories.add(categoryId);
            transaction.update(userStatsRef, {
              'exploredCategories': exploredCategories,
              'categoriesExplored': exploredCategories.length,
              'lastCategoryExploredAt': FieldValue.serverTimestamp(),
            });
            print('🗺️ Category $categoryId explored. Total categories: ${exploredCategories.length}');
          }
        } else {
          // Create initial user stats if doesn't exist
          transaction.set(userStatsRef, {
            'userId': user.uid,
            'name': user.displayName ?? 'User',
            'email': user.email,
            'photoUrl': user.photoURL,
            'readArticles': [],
            'articlesRead': 0,
            'exploredCategories': [categoryId],
            'categoriesExplored': 1,
            'quizzesCompleted': 0,
            'dayStreak': 0,
            'totalXP': 0,
            'level': 1,
            'createdAt': FieldValue.serverTimestamp(),
            'lastCategoryExploredAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          print('🗺️ First category explored: $categoryId');
        }
      });
    } catch (e) {
      print('Error tracking category exploration: $e');
    }
  }

  // Get articles read by user
  static Future<Set<String>> getArticlesRead() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return <String>{};

      final doc = await _firestore.collection('user_stats').doc(user.uid).get();
      
      if (doc.exists) {
        final data = doc.data()!;
        final readArticles = List<String>.from(data['readArticles'] ?? []);
        return Set<String>.from(readArticles);
      }
      
      return <String>{};
    } catch (e) {
      print('Error getting articles read: $e');
      return <String>{};
    }
  }

  // Get categories explored by user
  static Future<Set<String>> getCategoriesExplored() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return <String>{};

      final doc = await _firestore.collection('user_stats').doc(user.uid).get();
      
      if (doc.exists) {
        final data = doc.data()!;
        final exploredCategories = List<String>.from(data['exploredCategories'] ?? []);
        return Set<String>.from(exploredCategories);
      }
      
      return <String>{};
    } catch (e) {
      print('Error getting categories explored: $e');
      return <String>{};
    }
  }

  // Get user stats for achievements
  static Future<Map<String, dynamic>> getUserTrackingStats() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return {};

      final doc = await _firestore.collection('user_stats').doc(user.uid).get();
      
      if (doc.exists) {
        final data = doc.data()!;
        return {
          'articlesRead': data['articlesRead'] ?? 0,
          'categoriesExplored': data['categoriesExplored'] ?? 0,
          'quizzesCompleted': data['quizzesCompleted'] ?? 0,
          'dayStreak': data['dayStreak'] ?? 0,
          'readArticles': List<String>.from(data['readArticles'] ?? []),
          'exploredCategories': List<String>.from(data['exploredCategories'] ?? []),
        };
      }
      
      return {};
    } catch (e) {
      print('Error getting user tracking stats: $e');
      return {};
    }
  }
}
