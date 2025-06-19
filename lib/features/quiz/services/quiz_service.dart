import 'package:flutter/material.dart';
import '../../../models/quiz_models.dart';
import '../../../core/app_colors.dart';
import 'gemini_service.dart';
import 'quiz_firebase_service.dart';

class QuizService {
  static List<QuizCategory> getCategories() {
    return [
      QuizCategory(
        id: 'cultural-sites',
        name: 'Cultural Sites',
        description: 'Quiz about Indonesian cultural heritage sites',
        icon: 'assets/category/cultural_sites.svg',
        color: AppColors.quizBlue,
        totalQuestions: 50,
      ),
      QuizCategory(
        id: 'arts-culture',
        name: 'Arts & Culture',
        description: 'Quiz about Indonesian arts and culture',
        icon: 'assets/category/art_culture.svg',
        color: AppColors.quizOrange,
        totalQuestions: 45,
      ),
      QuizCategory(
        id: 'folk-instruments',
        name: 'Folk Instruments',
        description: 'Quiz about traditional Indonesian instruments',
        icon: 'assets/category/folk_instruments.svg',
        color: AppColors.quizGreen,
        totalQuestions: 30,
      ),
      QuizCategory(
        id: 'traditional-wear',
        name: 'Traditional Wear',
        description: 'Quiz about Indonesian traditional clothing',
        icon: 'assets/category/traditional_wear.svg',
        color: AppColors.quizYellow,
        totalQuestions: 25,
      ),
      QuizCategory(
        id: 'crafts-artifacts',
        name: 'Crafts & Artifacts',
        description: 'Quiz about Indonesian crafts and artifacts',
        icon: 'assets/category/craft_artifacts.svg',
        color: AppColors.quizRed,
        totalQuestions: 35,
      ),
      QuizCategory(
        id: 'local-foods',
        name: 'Local Foods',
        description: 'Quiz about Indonesian traditional cuisine',
        icon: 'assets/category/local_foods.svg',
        color: AppColors.quizPurple,
        totalQuestions: 40,
      ),
    ];
  } // Generate questions dengan AI berdasarkan level user

  static Future<List<Question>> getQuestionsByCategory(
      String categoryId) async {
    print('🎯 Starting getQuestionsByCategory for: $categoryId');

    try {
      // Get user level dari Firebase
      final userLevel = await QuizFirebaseService.getCurrentUserLevel();
      print('👤 User level: $userLevel');

      // Generate questions dengan AI - FULL API MODE
      final categoryName = _getCategoryNameById(categoryId);
      print('📂 Category name: $categoryName');

      print('🤖 Calling Gemini API to generate questions...');
      final questions = await GeminiService.generateQuestions(
        categoryName: categoryName,
        level: userLevel,
        questionCount: 5, // 5 pertanyaan per quiz
      );

      print('✅ Generated ${questions.length} questions successfully');

      // Save to cache after successful generation
      try {
        await QuizFirebaseService.saveGeneratedQuestions(
            questions, categoryId, userLevel);
        print('💾 Questions saved to cache');
      } catch (cacheError) {
        print('⚠️ Cache save failed but continuing: $cacheError');
      }

      return questions;
    } catch (e) {
      print('❌ CRITICAL ERROR: Failed to generate questions from API: $e');
      print('� NO FALLBACK - Full API mode only');

      // Throw error instead of using fallback
      throw Exception(
          'Failed to generate quiz questions. Please check your internet connection and try again. Error: $e');
    }
  }

  static String _getCategoryNameById(String categoryId) {
    switch (categoryId) {
      case 'cultural-sites':
        return 'Cultural Sites';
      case 'arts-culture':
        return 'Arts & Culture';
      case 'folk-instruments':
        return 'Folk Instruments';
      case 'traditional-wear':
        return 'Traditional Wear';
      case 'crafts-artifacts':
        return 'Crafts & Artifacts';
      case 'local-foods':
        return 'Local Foods';
      default:
        return 'Indonesian Culture';
    }
  }
  // Get user stats dari Firebase
  static Future<UserStats> getUserStats() async {
    return await QuizFirebaseService.getUserStats();
  }
  
  // Get user stats as real-time stream dari Firebase
  static Stream<UserStats> getUserStatsStream() {
    return QuizFirebaseService.getUserStatsStream();
  }

  // Simpan quiz result ke Firebase
  static Future<void> saveQuizResult(
      QuizResult result, String categoryId) async {
    await QuizFirebaseService.saveQuizResult(result, categoryId);
  }

  // Get quiz history dari Firebase
  static Future<List<Map<String, dynamic>>> getQuizHistory() async {
    return await QuizFirebaseService.getQuizHistory();
  }

  // Get quiz history dari Firebase sebagai real-time stream
  static Stream<List<Map<String, dynamic>>> getQuizHistoryStream() {
    return QuizFirebaseService.getQuizHistoryStream();
  }

  static List<Achievement> getAchievements() {
    return [
      Achievement(
        id: 'knowledge_seeker',
        title: 'Knowledge Seeker',
        description: 'Read 50+ articles',
        icon: '📚',
        isUnlocked: true,
        color: AppColors.quizBlue,
      ),
      Achievement(
        id: 'quiz_master',
        title: 'Quiz Master',
        description: 'Complete 25+ quizzes',
        icon: '🏆',
        isUnlocked: true,
        color: AppColors.quizYellow,
      ),
      Achievement(
        id: 'culture_expert',
        title: 'Culture Expert',
        description: 'Explore all 6 categories',
        icon: '⭐',
        isUnlocked: false,
        color: AppColors.quizPurple,
      ),
      Achievement(
        id: 'perfect_score',
        title: 'Perfect Score',
        description: 'Get 100% in any quiz',
        icon: '🎯',
        isUnlocked: true,
        color: AppColors.quizGreen,
      ),
    ];
  }

  // Helper methods for UI components
  static String getCategoryNameById(String? categoryId) {
    switch (categoryId) {
      case 'cultural-sites':
        return 'Cultural Sites';
      case 'arts-culture':
        return 'Arts & Culture';
      case 'folk-instruments':
        return 'Folk Instruments';
      case 'traditional-wear':
        return 'Traditional Wear';
      case 'crafts-artifacts':
        return 'Crafts & Artifacts';
      case 'local-foods':
        return 'Local Foods';
      default:
        return 'Unknown Category';
    }
  }

  static Color getCategoryColor(String? categoryId) {
    switch (categoryId) {
      case 'cultural-sites':
        return AppColors.quizBlue; // 4286EF
      case 'arts-culture':
        return AppColors.quizOrange; // FF6629
      case 'folk-instruments':
        return AppColors.quizGreen; // 48BB78
      case 'traditional-wear':
        return AppColors.quizYellow; // ECC94B
      case 'crafts-artifacts':
        return AppColors.quizRed; // F73131
      case 'local-foods':
        return AppColors.quizPurple; // 8A4FFF
      default:
        return AppColors.quizBlue;
    }
  }

  static String formatTimeAgo(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';

    try {
      DateTime dateTime;
      if (timestamp is String) {
        dateTime = DateTime.parse(timestamp);
      } else {
        // Assume Firebase Timestamp
        dateTime = timestamp.toDate();
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
