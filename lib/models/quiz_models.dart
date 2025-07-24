
import 'package:flutter/material.dart';

class QuizCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final Color color;
  final int totalQuestions;

  QuizCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.totalQuestions,
  });
}

class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String categoryId;
  final String? explanation; // Add explanation field

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.categoryId,
    this.explanation, // Optional explanation
  });
}

class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int xpEarned;
  final double accuracy;
  final Duration timeTaken;

  QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.xpEarned,
    required this.accuracy,
    required this.timeTaken,
  });
}

class UserStats {
  final String name;
  final String email;
  final String? photoUrl;
  final int level;
  final String levelTitle;
  final int currentXP;
  final int nextLevelXP;
  final int totalXP;
  final int quizzesCompleted;
  final int articlesRead;
  final int dayStreak;
  final double accuracy;

  UserStats({
    required this.name,
    required this.email,
    this.photoUrl,
    required this.level,
    required this.levelTitle,
    required this.currentXP,
    required this.nextLevelXP,
    required this.totalXP,
    required this.quizzesCompleted,
    required this.articlesRead,
    required this.dayStreak,
    required this.accuracy,
  });
}

